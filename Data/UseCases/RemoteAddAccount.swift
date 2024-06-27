
import Foundation
import Domain

public final class RemoteAddAccount {
    public let url: URL
    public let httpClientPost: HttpClientPOST
    
    public init(url: URL, httpClientPost: HttpClientPOST) {
        self.url = url
        self.httpClientPost = httpClientPost
    }
    
    public func add(addAccountModel: AddAccountModel){
        httpClientPost.post(to: url, with: addAccountModel.toData())
    }
}

