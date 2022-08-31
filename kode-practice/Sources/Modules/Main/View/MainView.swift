import UIKit
import SnapKit

final class MainView: BaseView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let tabsHeight: CGFloat = 44
        static let separatorHeight: CGFloat = 0.4
    }
    
    // MARK: - Views
    
    private lazy var separatorView = MainView.makeSeparatorView()
    
    lazy var searchBar = SearchBar()
    lazy var tabsCollectionView = TabsCollectionView()
    
    // MARK: - Appearance
    
    override func configureAppearance() {
        super.configureAppearance()
        backgroundColor = .white
    }
    
    // MARK: - UI
    
    override func configureUI() {
        super.configureUI()
        [tabsCollectionView, separatorView].forEach { addSubview($0) }
        
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
