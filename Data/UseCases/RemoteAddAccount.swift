import Foundation
import Domain

final class RemoteAddAccount {
    let url: URL
     let httpClientPost: HttpPostClient
    
      init(url: URL, httpClientPost: HttpPostClient) {
        self.url = url
        self.httpClientPost = httpClientPost
    }
    
    func add(addAccountModel: AddAccountModel, completion: @escaping (DomainError) -> Void){
         httpClientPost.post(to: url, with: addAccountModel.toData()){_ in }
    }
}

