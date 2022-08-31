/*
 users --
     departamentUsers --
        filteredByAlphabetUsers
 */

import Foundation

struct MainViewModel {
    
    // MARK: - Observable Properties
    
    var tabs: Observable<[TabCollectionViewCellModel]> = Observable([])
    
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
}
