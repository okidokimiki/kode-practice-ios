import UIKit

final class InfoTableView: UITableView {
    
    // MARK: - UITableView
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureAppearance()
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureAppearance()
        registerCells()
    }
}

// MARK: - Private Methods

private extension InfoTableView {
    
    func configureAppearance() {
        separatorStyle = .none
        backgroundColor = .white
        isScrollEnabled = false
        showsVerticalScrollIndicator = false
    }
    
    func registerCells() {
        register(DateInfoTableViewCell.self)
        register(PhoneInfoTableViewCell.self)
    }
}
