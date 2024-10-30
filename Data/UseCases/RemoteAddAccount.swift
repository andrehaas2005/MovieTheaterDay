import Foundation
import Domain

final class RemoteAddAccount: AddAccount {
    
    let url: URL
     let httpClientPost: HttpPostClient
    
      init(url: URL, httpClientPost: HttpPostClient) {
        self.url = url
        self.httpClientPost = httpClientPost
    }
    
    func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void){
        httpClientPost.post(to: url, with: addAccountModel.toData()){ result in
            switch result {
            case .success(let data):
                if let model: AccountModel = data.toModel() {
                    completion(.success(model))
                } else {
                    completion(.failure(.unexpected))
                }
                
            case .failure:
                completion(.failure(.unexpected))
            }
        }
    }
}
