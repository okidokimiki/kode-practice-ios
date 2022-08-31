enum HTTPMethod: String {
    case get
    case post
}

extension HTTPMethod {
    
    var method: String {
        rawValue.uppercased()
    }
}
