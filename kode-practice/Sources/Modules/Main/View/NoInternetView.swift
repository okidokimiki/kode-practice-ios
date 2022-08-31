import UIKit
import SnapKit

final class NoInternetView: BaseView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let textFont = R.Fonts.interMedium(with: 13)
        static let leftOrRightOffset: CGFloat = 24
        static let bottomInset: CGFloat = 12
    }
    
    // MARK: - Views
    
    private lazy var messageErrorLabel = NoInternetView.makeMessageErrorLabel()
    
    // MARK: - Appearance
    
    override func configureAppearance() {
        super.configureAppearance()
        backgroundColor = R.Colors.networkError
    }
    
    // MARK: - UI
    
    override func configureUI() {
        super.configureUI()
        addSubview(messageErrorLabel)
        
        messageErrorLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().offset(Constants.leftOrRightOffset)
            make.bottom.equalToSuperview().inset(Constants.bottomInset)
        }
    }
}

// MARK: - Creating Subviews

extension NoInternetView {
    
    static func makeMessageErrorLabel() -> UILabel {
        let label = UILabel()
        label.text = R.Strings.NoInternet.connectionError.localizedString
        label.font = Constants.textFont
        label.textColor = .white
        label.numberOfLines = .zero
        
        return label
    }
}
