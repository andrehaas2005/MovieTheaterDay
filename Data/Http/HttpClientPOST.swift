import Foundation

public protocol HttpClientPOST {
    func post(to url: URL, with data: Data?)
}
