import XCTest
import Alamofire

class AlamofireAdapter {
    private let session: Session
    
    func post(to url: URL) {
        session.request(url, method: .post).resume()
    }
    
    init(session: Session = .default) {
        self.session = session
    }
}

final class AlamofireAdapterTests: XCTestCase {
    func test_() {
        let url = makeUrl()
        let config = URLSessionConfiguration.default
        config.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration: config)
        let sut = AlamofireAdapter(session: session)
        sut.post(to: url)
        let exp = expectation(description: "waiting")
        
        UrlProtocolStub.observerRequest { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }

}

class UrlProtocolStub: URLProtocol {
    static var emit: ((URLRequest) -> Void)?
    
    static func observerRequest(completion: @escaping (URLRequest) -> Void) {
        UrlProtocolStub.emit = completion
    }
    
    override open class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override open func startLoading() {
        UrlProtocolStub.emit?(request)
    }
    
    override open func stopLoading() {
        
    }
}