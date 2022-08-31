import Foundation

struct UserTableViewCellModel {
    let logoUrl: String
    let fullName: String
    let userTag: String
    let department: Department
    let birthdayDate: Date?
    let phone: String
    
    init(item: Item) {
        self.logoUrl = item.avatarUrl
        self.fullName = "\(item.firstName) \((item.lastName))"
        self.userTag = item.userTag
        self.department = item.department
        self.birthdayDate = item.birthdayDate
        self.phone = item.phone
    }
}

extension UserTableViewCellModel {
    var shortFormatBirthday: String? {
        guard let birthdayDate = birthdayDate else { return nil }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        
        dateFormatter.dateFormat = "d"
        let day = dateFormatter
            .string(from: birthdayDate)
        
        dateFormatter.dateFormat = "MMM"
        let month = dateFormatter
            .string(from: birthdayDate)
            .prefix(3)
            .replacingOccurrences(of: ".", with: "")

        return "\(day) \(month)"
    }
}
