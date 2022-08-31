import Foundation

struct BaseNetworkTask<Input: Encodable, Output: Decodable>: NetworkTask {
    
    // MARK: - NetworkTask
    
    typealias Input = Input
    typealias Output = Output
    
    var baseURL: URL? {
        URL(string: "https://stoplight.io/mocks/")
    }
    
    // MARK: - Internal Properties
    
    var pathURN: String
    var httpMethod: HTTPMethod
    
    // MARK: - Private Properties
    
    private let session: URLSession = URLSession(configuration: .default)
    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()
    
    // MARK: - Initilization
    
    init(method: HTTPMethod, path: String) {
        self.pathURN = path
        self.httpMethod = method
    }
    
    // MARK: - NetworkTask
    
    func performRequest(
        input: Input,
        _ onResponseWasReceived: @escaping (_ result: Result<Output, Error>) -> Void
    ) {
        do {
            let request = try getRequest(with: input)
            let dataTask = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    onResponseWasReceived(.failure(error))
                }
                
                guard let data = data else {
                    return onResponseWasReceived(.failure(NetworkTaskError.unknownError))
                }
                
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    return onResponseWasReceived(.failure(NetworkTaskError.badResponse(response)))
                }
                
                do {
                    let mappedModel = try jsonDecoder.decode(Output.self, from: data)
                    onResponseWasReceived(.success(mappedModel))
                } catch {
                    onResponseWasReceived(.failure(error))
                }
            }
            dataTask.resume()
        } catch {
            onResponseWasReceived(.failure(error))
        }
    }
    
}

// MARK: - EmptyModel

extension BaseNetworkTask where Input == EmptyModel {
    
    func performRequest(_ onResponseWasReceived: @escaping (_ result: Result<Output, Error>) -> Void) {
        performRequest(input: EmptyModel(), onResponseWasReceived)
    }
    
}

// MARK: - Private Methods

private extension BaseNetworkTask {
    
    enum NetworkTaskError: Error {
        case badResponse(URLResponse?)
        case unknownError
        case urlWasNotFound
        case urlComponentWasNotCreated
        case parametersIsNotValidJsonObject
    }
    
    func getRequest(with parameters: Input) throws -> URLRequest {
        guard let url = completedURI else {
            throw NetworkTaskError.urlWasNotFound
        }
        
        var request: URLRequest
        switch httpMethod {
        case .get:
            let newURL = try getUrlWithQueryParameters(for: url, parameters: parameters)
            request = URLRequest(url: newURL)
        case .post:
            request = URLRequest(url: url)
            request.httpBody = try getParametersForBody(from: parameters)
        }
        request.timeoutInterval = 5
        request.httpMethod = httpMethod.method
        request.cachePolicy = .useProtocolCachePolicy
        // uncomment to present error-alert screen
        // request.addValue("example=error-500", forHTTPHeaderField: "Prefer")
        request.addValue("dynamic=true", forHTTPHeaderField: "Prefer")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    func getUrlWithQueryParameters(for url: URL, parameters: Input) throws -> URL {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw NetworkTaskError.urlComponentWasNotCreated
        }
        
        let parametersInDataRepresenation = try jsonEncoder.encode(parameters)
        let parametersInDictionaryRepresentation = try JSONSerialization.jsonObject(with: parametersInDataRepresenation)
        
        guard let parametersInDictionaryRepresentation = parametersInDictionaryRepresentation as? [String: Any] else {
            throw NetworkTaskError.parametersIsNotValidJsonObject
        }
        
        let queryItems = parametersInDictionaryRepresentation.map { key, value in
            return URLQueryItem(name: key, value: "\(value)")
        }
        
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        
        guard let newUrlWithQuery = urlComponents.url else {
            throw NetworkTaskError.urlWasNotFound
        }
        
        return newUrlWithQuery
    }
    
    func getParametersForBody(from encodableParameters: Input) throws -> Data {
        return try jsonEncoder.encode(encodableParameters)
    }
    
}
