import XCTest
import Domain
import Data

final class RemoteAddAccountTests: XCTestCase {
    func test_add_should_call_httpClient_with_correct_url() {
        let url = URL(string: "http://any-url.com")!
        let (sut, httpClientSpy) = makeSut(url: url)
        sut.add(addAccountModel: makeAddAccountModel()) { _ in }
        
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
    
    func test_add_should_call_httpClient_with_correct_data() {
        let addAccountModel = makeAddAccountModel()
        let (sut, httpClientSpy) = makeSut()
        sut.add(addAccountModel: addAccountModel) {_ in }
        
        XCTAssertEqual(httpClientSpy.data, addAccountModel.toData())
    }
    
    func test_add_should_complete_with_error_with_client_cmoplete_with_error() {
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .unexpected)
            case .success: XCTFail("Expected error receive \(result) instead")
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithError(.noConnectivity)
        wait(for: [exp], timeout: 1)
    }
    
    func test_add_should_complete_with_account_with_client_cmoplete_with_data() {
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        let expectedAccount = makeAccountModel()
        sut.add(addAccountModel: makeAddAccountModel()) { result in
            switch result {
            case .failure: XCTFail("Expected success receive \(result) instead")
            case .success(let receivedAccount): XCTAssertEqual(receivedAccount, expectedAccount)
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithData(expectedAccount.toData()!)
        wait(for: [exp], timeout: 1)
    }
}

extension RemoteAddAccountTests
{
    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        // system under test
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        
        return (sut, httpClientSpy)
    }
    
    func makeAddAccountModel() -> AddAccountModel {
        AddAccountModel(name: "any name", email: "anyemail@email.com", password: "anypassword", passwordConfirmation: "anypassword")
    }
    
    func makeAccountModel() -> AccountModel {
        AccountModel(id: "any_id", name: "any name", email: "anyemail@email.com", password: "anypassword")
    }
    
    class HttpClientSpy: HttpPostClient {
        var urls = [URL]()
        var data: Data?
        var completion: ((Result<Data, HttpError>) -> Void)?
        
        func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
            self.urls.append(url)
            self.data = data
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError) {
            completion?(.failure(error))
        }
        
        func completeWithData(_ data: Data){
            completion?(.success(data))
        }
    }
}
