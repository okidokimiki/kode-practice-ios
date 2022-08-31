import Foundation

protocol NetworkTask {
    
    associatedtype Input: Encodable
    associatedtype Output: Decodable
    
    var baseURL: URL? { get }
    var pathURN: String { get }
    var completedURI: URL? { get }
    var httpMethod: HTTPMethod { get }
    
    func performRequest(
        input: Input,
        _ onResponseWasReceived: @escaping (_ result: Result<Output, Error>) -> Void
    )
    
}

extension NetworkTask {
    
    var completedURI: URL? {
        baseURL?.appendingPathComponent(pathURN)
    }
}
