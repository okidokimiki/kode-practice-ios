import Foundation

struct FilterViewModel {
    
    // MARK: - Internal Properties
    
    var filterType: Observable<FilterType>
    
    // MARK: - Public Methods
    
    func getFilterType() -> FilterType {
        filterType.value
    }
    
    func saveLastSelectedFilterType(_ type: FilterType) {
        filterType.value = type
    }
}
