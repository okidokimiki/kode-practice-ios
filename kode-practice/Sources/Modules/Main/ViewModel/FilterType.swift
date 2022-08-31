enum FilterType: String {
    case byAlphabet
    case byBirthday
    
    mutating func toggle() {
        switch self {
        case .byAlphabet:
            self = .byBirthday
        case .byBirthday:
            self = .byAlphabet
        }
    }
}
