import XCTest
import Domain
import Data

final class RemoteAddAccountTests: XCTestCase {
    func test_add_should_call_httpClient_with_correct_url() {
        let url = URL(string: "http://any-url.com")!
        let (sut, httpClientSpy) = makeSut(url: url)
        sut.add(addAccountModel: makeAddAccountModel())
        
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
    func test_add_should_call_httpClient_with_correct_data() {
        let addAccountModel = makeAddAccountModel()
        let (sut, httpClientSpy) = makeSut()
        sut.add(addAccountModel: addAccountModel)
        
        XCTAssertEqual(httpClientSpy.data, addAccountModel.toDsta())
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
    
    class HttpClientSpy: HttpPostClient {
        var url: URL?
        var data: Data?
        
        func post(to url: URL, with data: Data?) {
            self.url = url
            self.data = data
        }
    }
}
