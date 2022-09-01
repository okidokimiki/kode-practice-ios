import UIKit

protocol UserTableViewTouchDelegate {
    func touchesBegunInTableview(_ touches: Set<UITouch>, with event: UIEvent?)
}

final class UserTableView: UITableView {
    
    // MARK: - Internal Properties
    
    private var refreshController: UIRefreshControl?
    
    // MARK: - Delegate Properties
    
     var touchedDelegate: UserTableViewTouchDelegate?
    
    // MARK: - UITableView
    
    convenience init(refreshController: UIRefreshControl) {
        self.init(frame: .zero, style: .grouped)
        self.refreshController = refreshController
        confugureAppearance()
        registerCells()
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UITouch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchedDelegate?.touchesBegunInTableview(touches, with: event)
    }
}

// MARK: - Private Methods

private extension UserTableView {
    
    func confugureAppearance() {
        backgroundColor = .none
        separatorStyle = .none
        refreshControl = refreshController
        contentInset = Constants.contentInset
        showsVerticalScrollIndicator = false
    }
    
    func registerCells() {
        register(UserTableViewCell.self)
    }
}

// MARK: - Constants

private enum Constants {
    static let contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: -16)
}
