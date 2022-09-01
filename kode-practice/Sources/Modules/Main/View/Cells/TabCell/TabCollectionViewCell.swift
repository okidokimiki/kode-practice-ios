import UIKit
import SnapKit

final class TabCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views
    
    private lazy var tabTitleLabel = TabCollectionViewCell.makeTabTitleLabel()
    private lazy var selectedTabIndicatorView = UIView()
    
    // MARK: - Override Properties
    
    override var isSelected: Bool {
        didSet { updateAppearance() }
    }
    
    // MARK: - UICollectionViewCell
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    // MARK: - ConfigurePerCell
    
    func configure(with string: String) {
        tabTitleLabel.text = string
    }
}

// MARK: - Private Methods

private extension TabCollectionViewCell {
    
    func configureUI() {
        [tabTitleLabel, selectedTabIndicatorView].forEach{ addSubview($0) }
        
        tabTitleLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        
        selectedTabIndicatorView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(Constants.selectedTabIndicatorHeight)
        }
    }
    
    func updateAppearance() {
        tabTitleLabel.textColor = isSelected ? R.Colors.Text.active : R.Colors.Text.inActive
        selectedTabIndicatorView.backgroundColor = isSelected ? R.Colors.activePrimary : .none
    }
}

// MARK: - Creating Subviews

extension TabCollectionViewCell {
    
    static func makeTabTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = Constants.tabTitleTextFont
        label.textColor = R.Colors.Text.inActive
        
        return label
    }
}

// MARK: - Constants

private enum Constants {
    static let tabTitleTextFont = R.Fonts.interSemiBold(with: 15)
    static let selectedTabIndicatorHeight: CGFloat = 2
}
