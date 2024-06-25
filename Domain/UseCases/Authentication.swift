import Foundation

protocol Authentication {
    func auth(credential: CredentialRequestModel, completion: @escaping (Result<TokenModel,Error>)->Void)
    func getToken(completion: @escaping (Result<String,Error>)->Void)
}
