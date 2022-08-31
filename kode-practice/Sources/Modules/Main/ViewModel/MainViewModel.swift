import Foundation

struct MainViewModel {
    
    // MARK: - Observable Properties
    
    var tabs: Observable<[TabCollectionViewCellModel]> = Observable([])
    
    // MARK: - Computed Properties
    
    var selectedTabNumber: Int {
        UserDefaults.standard.integer(forKey: R.Keys.UserDefaults.selectedTab.rawValue)
    }
    
    // MARK: - Public Methods
    
    func getTabs() {
        tabs.value = Department.allCases.map { TabCollectionViewCellModel(title: $0.title) }
    }
    
    func saveLastUsedTab(_ tabNumber: Int) {
        UserDefaults.standard.set(tabNumber, forKey: R.Keys.UserDefaults.selectedTab.rawValue)
    }
}
