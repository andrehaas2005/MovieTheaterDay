import XCTest
import Domain
import Data

final class RemoteAddAccountTests: XCTestCase {
    
    func test_add_should_call_httpclient_with_correct_url() {
        let url = URL(string: "http://any-url.com")!
        let (sut, httpClientSpy) = makeSut(url: url)
        sut.add(addAccountModel: makeAddAccountModel())
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
    func test_add_should_call_httpclient_with_correct_data() {
        let (sut, httpClientSpy) = makeSut()
        let addAccountModel = makeAddAccountModel()
        let data = addAccountModel.toData()
        sut.add(addAccountModel: addAccountModel)
        XCTAssertEqual(httpClientSpy.data, data)
    }
}

extension RemoteAddAccountTests {
    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteAddAccount, httpClient: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClientPost: httpClientSpy)
        return (sut, httpClientSpy)
    }
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "any_name", email: "any_email", password: "any_password", passwordConfirmation: "any_password")
    }
    
    class HttpClientSpy: HttpClientPOST {
        var url: URL?
        var data: Data?
        func post(to url: URL, with data: Data?) {
            self.url = url
            self.data = data
        }
    }
}
