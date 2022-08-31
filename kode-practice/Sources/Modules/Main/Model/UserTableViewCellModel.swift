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
