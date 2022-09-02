import Foundation

extension Int {
    func ruWordAge() -> String {
        guard self != 1 else { return "год" }
        
        var moreThanTwenty: String {
            if self % 10 == 1 {
                return "год"
            } else if (1...4).contains(self % 10) {
                return  "года"
            }
            
            return "лет"
        }
        
        var moreThanFive: String {
            self < 20 ? "лет" : moreThanTwenty
        }
        
        return (2...4).contains(self) ? "года" : moreThanFive
    }
}
