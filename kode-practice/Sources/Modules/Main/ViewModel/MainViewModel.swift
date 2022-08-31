/*
 users --
     departamentUsers --
        filteredByAlphabetUsers
        filteredByHappyBirthdayThisYearUsers
        filteredByHappyBirthdayNextYearUsers
 */

import Foundation

struct MainViewModel {
    
    // MARK: - Observable Properties
    
    var tabs: Observable<[TabCollectionViewCellModel]> = Observable([])
    
    var filteredBy: Observable<FilterType> = Observable(.byAlphabet)
    var networkState: Observable<NetworkState> = Observable(.default)
    
    var users: Observable<[UserTableViewCellModel]> = Observable([])
    var departmentUsers: Observable<[UserTableViewCellModel]> = Observable([])
    
    // MARK: - Computed Properties
    
    var selectedTabNumber: Int {
        UserDefaults.standard.integer(forKey: R.Keys.UserDefaults.selectedTab.rawValue)
    }
    
    var filteredByAlphabetUsers: [UserTableViewCellModel] {
        departmentUsers.value.sorted { $0.fullName < $1.fullName }
    }
    
    var filteredByHappyBirthdayThisYearUsers: [UserTableViewCellModel] {
        departmentUsers.value
            .filter { daysBetweenNow(and: $0.birthdayDate) > .zero }
            .sorted(by: { Date.MonthDay(date: $0.birthdayDate) < Date.MonthDay(date: $1.birthdayDate) })
    }
    
    var filteredByHappyBirthdayNextYearUsers: [UserTableViewCellModel] {
        departmentUsers.value
            .filter { daysBetweenNow(and: $0.birthdayDate) < .zero }
            .sorted(by: { Date.MonthDay(date: $0.birthdayDate) < Date.MonthDay(date: $1.birthdayDate) })
    }
    
    // MARK: - Public Methods
    
    func getTabs() {
        tabs.value = Department.allCases.map { TabCollectionViewCellModel(title: $0.title) }
    }
    
    func saveLastUsedTab(_ tabNumber: Int) {
        UserDefaults.standard.set(tabNumber, forKey: R.Keys.UserDefaults.selectedTab.rawValue)
    }
    
    func getUsers() {
        UsersService().loadUsers { result in
            switch result {
            case .success(let userList):
                users.value = userList.items.map { UserTableViewCellModel(item: $0) }
                networkState.value = .default
            case .failure(let requstError):
                networkState.value = .failed(.internalServerError(requstError))
            }
        }
    }
    
    func getDepartmentUsers(of department: Department) {
        if case .all = department {
            departmentUsers.value = users.value
        } else {
            departmentUsers.value = users.value.filter { $0.department == department }
        }
    }
    
    // MARK: - NetworkState
    
    enum NetworkState {
        case `default`
        case failed(NetworkFailureReason)
    }
    
    enum NetworkFailureReason {
        case internalServerError(Error)
        case noInternet
    }
    
    // MARK: - FilterType
    
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
}

// MARK: - Private Properties

private extension MainViewModel {
    
    func daysBetweenNow(and date: Date?) -> Int {
        guard let dateParam = date else { return .zero }
        
        let calendar = Calendar.current
        let dateNow = Date()
        
        let dateComponentsNow = calendar.dateComponents([.year], from: dateNow)
        let dateComponentsParam = calendar.dateComponents([.month, .day], from: dateParam)
        
        var dateComponentsTemp = DateComponents()
        dateComponentsTemp.year = dateComponentsNow.year
        dateComponentsTemp.month = dateComponentsParam.month
        dateComponentsTemp.day = dateComponentsParam.day
        
        guard let dateTemp = calendar.date(from: dateComponentsTemp) else { return .zero }
        
        guard let daysBetween = calendar.dateComponents([.day], from: dateNow, to: dateTemp).day else { return .zero }
        
        return daysBetween
    }
}
