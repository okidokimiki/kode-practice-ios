import UIKit

final class SearchBar: UISearchBar {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let activeTextFont: UIFont = R.Fonts.interRegular(with: 15)
        static let adjustingTextOffset: UIOffset = .init(horizontal: 10, vertical: .zero)
        static let adjustingRightIconOffset: UIOffset = .init(horizontal: -10, vertical: .zero)
        static let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: R.Fonts.interMedium(with: 15),
            .foregroundColor: R.Colors.SearchBar.placeholder,
        ]
        static let cancelBarButtonAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor: R.Colors.activePrimary,
        ]
        static let placeholderAttributedString: NSAttributedString = .init(
            string: R.Strings.SearchBar.placeholder.localizedString,
            attributes: placeholderAttributes
        )
    }
    
    // MARK: - UISearchBar
    
    convenience init() {
        self.init(frame: .zero)
        configureAppearance()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Private Methods

private extension SearchBar {
    
    func configureAppearance() {
        showsBookmarkButton = true
        searchBarStyle = .minimal
        
        setImage(R.Images.SearchBar.xClear, for: .clear, state: .normal)
        setImage(R.Images.SearchBar.rightImageNormal, for: .bookmark, state: .normal)
        
        setValue(R.Strings.SearchBar.cancel.localizedString, forKey: R.Keys.NSObjectValue.cancelButtonText.rawValue)
        
        setSearchFieldBackgroundImage(UIImage.image(color: R.Colors.SearchBar.secondary), for: .normal)
        setPositionAdjustment(Constants.adjustingTextOffset, for: .search)
        setPositionAdjustment(Constants.adjustingRightIconOffset, for: .bookmark)
        setPositionAdjustment(Constants.adjustingRightIconOffset, for: .clear)
        searchTextPositionAdjustment = Constants.adjustingTextOffset
        
        searchTextField.spellCheckingType = .no
        searchTextField.autocorrectionType = .no
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.rightViewMode = .unlessEditing
        searchTextField.textAlignment = .left
        searchTextField.font = Constants.activeTextFont
        searchTextField.tintColor = R.Colors.activePrimary
        searchTextField.attributedPlaceholder = Constants.placeholderAttributedString
        searchTextField.leftView = UIImageView.init(image: R.Images.SearchBar.leftImageNormal)
        searchTextField.layer.cornerRadius = Constants.cornerRadius
        searchTextField.layer.masksToBounds = true
        
        let barButtonAppearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        barButtonAppearance.setTitleTextAttributes(Constants.cancelBarButtonAttributes, for: .normal)
    }
}
