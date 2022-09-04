import UIKit
import SnapKit

final class MainView: BaseView {
    
    // MARK: - Views
    
    private lazy var separatorView = MainView.makeSeparatorView()
    
    lazy var searchBar = SearchBar()
    lazy var tabsCollectionView = TabsCollectionView()
    lazy var userTableView = UserTableView(refreshController: refreshControl)
    lazy var refreshControl = UIRefreshControl()
    lazy var noSearchResultView = NoSearchResultView()
    
    // MARK: - Appearance
    
    override func configureAppearance() {
        super.configureAppearance()
        backgroundColor = .white
    }
    
    // MARK: - UI
    
    override func configureUI() {
        super.configureUI()
        [tabsCollectionView, separatorView, userTableView, noSearchResultView].forEach { addSubview($0) }
        
        tabsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.tabsHeight)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(tabsCollectionView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.separatorHeight)
        }
        
        userTableView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        noSearchResultView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - Creating Subviews

extension MainView {
    
    static func makeSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = R.Colors.separator
        
        return view
    }
    
}

// MARK: - Constants

private enum Constants {
    static let tabsHeight: CGFloat = 44
    static let separatorHeight: CGFloat = 0.4
}
