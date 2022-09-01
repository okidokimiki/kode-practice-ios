import Foundation

struct DetailsViewModel {
    
    // MARK: - Internal Properties
    
    let user: UserTableViewCellModel
    var dateInfo: Observable<DateInfoTableViewCellModel?> = Observable(nil)
    let phoneInfo: Observable<PhoneInfoTableViewCellModel?> = Observable(nil)
    
    // MARK: - Initilization
    
    init(_ user: UserTableViewCellModel) {
        self.user = user
        dateInfo.value = .init(birthday: birthday, age: age)
        phoneInfo.value = .init(phoneNumber: phoneNumber)
    }
}

// MARK: - Private Methods

private extension DetailsViewModel {
    
    var birthday: String? {
        guard let birthdayDate = user.birthdayDate else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "d MMMM yyyy"
        
        return dateFormatter
            .string(from: birthdayDate)
    }
    
    var age: Int? {
        guard let birthdayDate = user.birthdayDate else { return nil }
        
        return Calendar.current.dateComponents([.year], from: birthdayDate, to: Date()).year ?? nil
    }
    
    var phoneNumber: String {
        var sanitizedPhone = user.phone
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "-", with: "")
        
        let space = " "
        let countryCode = "7"
        
        let cityCode = sanitizedPhone.prefix(3)
        sanitizedPhone.removeFirst(3)
        
        var uniqueNumber: String {
            let firstThree = sanitizedPhone.prefix(3)
            sanitizedPhone.removeFirst(3)
            
            let firstTwo = sanitizedPhone.prefix(2)
            sanitizedPhone.removeFirst(2)
            
            let secontTwo = sanitizedPhone.prefix(2)
            
            return space + firstThree + space + firstTwo + space + secontTwo
        }
        
        return "+" + countryCode + space + "(\(cityCode))" + uniqueNumber
    }
}
