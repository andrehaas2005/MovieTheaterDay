import Foundation

struct CredentialRequestModel: Model {
    let userName: String
    let passWord: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case passWord = "password"
        case requestToken = "request_token"
    }
}
