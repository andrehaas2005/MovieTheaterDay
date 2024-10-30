import XCTest
import Domain
@testable import Data

final class RemoteAddAccountTests: XCTestCase {
    
    func test_add_should_call_httpclient_with_correct_url() {
        let url = URL(string: "http://any-url.com")!
        let (sut, httpClientSpy) = makeSut(url: url)
        sut.add(addAccountModel: makeAddAccountModel()){_ in}
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
    
    func test_add_should_call_httpclient_with_correct_data() {
        let (sut, httpClientSpy) = makeSut()
        let addAccountModel = makeAddAccountModel()
        let data = addAccountModel.toData()
        sut.add(addAccountModel: addAccountModel){_ in}
        XCTAssertEqual(httpClientSpy.data, data)
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_error() {
        let (sut, httpClientSpy) = makeSut()
        let addAccountModel = makeAddAccountModel()
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: addAccountModel) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .unexpected)
            case .success: XCTFail("Expectes error receive \(result) instead")
                
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithError(.noConnectivity)
       wait(for: [exp], timeout: 1)
    }
    
    func test_add_should_complete_with_account_if_client_complete_with_valid_data() {
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        let addAccountModel = makeAddAccountModel()
        let expectedAccount = makeAccountModel()
        sut.add(addAccountModel: addAccountModel) { result in
            switch result {
            case .failure:
                XCTFail("Expectes success receive \(result) instead")
                
            case .success(let receivedAccount):
                XCTAssertEqual(receivedAccount, expectedAccount)
            }
            
            exp.fulfill()
        }
        httpClientSpy.completeWithData(expectedAccount.toData()!)
       wait(for: [exp], timeout: 1)
    }
    
    func test_add_should_complete_with_account_if_client_complete_with_invalid_data() {
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        let addAccountModel = makeAddAccountModel()
        let expectedAccount = makeAccountModel()
        sut.add(addAccountModel: addAccountModel) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .unexpected)
            case .success(let receivedAccount):
                XCTFail("Expectes success receive \(result) instead")
            }
            
            exp.fulfill()
        }
        httpClientSpy.completeWithData(Data("invalid_data".utf8))
       wait(for: [exp], timeout: 1)
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
    
    func makeAccountModel() -> AccountModel {
        return AccountModel(id: "any_id", name: "any_name", email: "any_email", password: "any_password")
    }
    
    class HttpClientSpy: HttpPostClient {
        var urls = [URL]()
        var data: Data?
        var completion: ((Result<Data, HttpError>)-> Void)?
        
        func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
            self.urls.append(url)
            self.data = data
            
            self.completion = completion
        }
        

        func completeWithError(_ error: HttpError) {
            completion?(.failure(error))
        }
        
        func completeWithData(_ data: Data) {
            completion?(.success(data))
        }
    }
}
