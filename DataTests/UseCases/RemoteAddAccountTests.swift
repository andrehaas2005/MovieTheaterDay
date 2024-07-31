import XCTest
import Domain
@testable import Data

final class RemoteAddAccountTests: XCTestCase {
    
    func test_add_should_call_httpclient_with_correct_url() {
        let url = URL(string: "http://any-url.com")!
        let (sut, httpClientSpy) = makeSut(url: url)
        sut.add(addAccountModel: makeAddAccountModel()){_ in}
        XCTAssertEqual(httpClientSpy.url, url)
        XCTAssertEqual(httpClientSpy.callsCount, 1)
    }
    
    func test_add_should_call_httpclient_with_correct_data() {
        let (sut, httpClientSpy) = makeSut()
        let addAccountModel = makeAddAccountModel()
        let data = addAccountModel.toData()
        sut.add(addAccountModel: addAccountModel){_ in}
        XCTAssertEqual(httpClientSpy.data, data)
    }
}

extension RemoteAddAccountTests {
    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteAddAccount, httpClient: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut =  RemoteAddAccount(url: url, httpClientPost: httpClientSpy)
        return (sut, httpClientSpy)
    }
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "any_name", email: "any_email", password: "any_password", passwordConfirmation: "any_password")
    }
    
    class HttpClientSpy: HttpPostClient {
        var url: URL?
        var data: Data?
        var callsCount = 0
        var completion: ((Result<Data, HttpError>)-> Void)?
        func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
            self.url = url
            self.data = data
            callsCount += 1
            self.completion = completion
        }
        

        func completeWithError(_ error: HttpError) {
            completion?(.failure(error))
        }
    }
}
