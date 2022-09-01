import UIKit
import SnapKit

final class InternalErrorView: BaseView {
    
    // MARK: - Views
    
    private lazy var titleLabel = InternalErrorView.makeLabel(
        text: R.Strings.Alert.title.localizedString,
        font: Constants.titleTextFont,
        textColor: R.Colors.Text.active
    )
    private lazy var messageLabel = InternalErrorView.makeLabel(
        text: R.Strings.Alert.message.localizedString,
        font: Constants.messageTextFont,
        textColor: R.Colors.Text.inActive
    )
    private lazy var errorEmojiLabel = InternalErrorView.makeErrorEmojiLabel()
    
    lazy var tryAgainButton = InternalErrorView.makeTryAgainButton()
    
    // MARK: - Appearance
    
    override func configureAppearance() {
        super.configureAppearance()
        backgroundColor = .white
    }
    
    // MARK: - UI
    
    override func configureUI() {
        super.configureUI()
        [errorEmojiLabel, titleLabel, messageLabel, tryAgainButton].forEach{ addSubview($0) }
        
        errorEmojiLabel.snp.makeConstraints { $0.center.equalTo(self.snp.center) }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(errorEmojiLabel.snp.bottom)
            make.left.right.equalTo(self).inset(Constants.Labels.leftOrRightInset)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.Labels.topOffset)
            make.left.right.equalTo(self).inset(Constants.Labels.leftOrRightInset)
        }
        
        tryAgainButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(Constants.Labels.topOffset)
            make.left.right.equalTo(self).inset(Constants.Labels.leftOrRightInset)
        }
    }
}

// MARK: - Creating Subviews

extension InternalErrorView {
    
    static func makeErrorEmojiLabel() -> UILabel {
        let label = UILabel()
        label.text = R.USymlos.ufo.rawValue
        label.font = Constants.emojiTextFont
        
        return label
    }

    static func makeLabel(text: String, font: UIFont, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = .center
        
        return label
    }
    
    static func makeTryAgainButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setAttributedTitle(Constants.tryAgainButtonAttributedString, for: .normal)
        
        return button
    }
}

// MARK: - Constants

private enum Constants {
    static let emojiTextFont: UIFont = .systemFont(ofSize: 50)
    static let titleTextFont = R.Fonts.interSemiBold(with: 17)
    static let messageTextFont = R.Fonts.interRegular(with: 16)
    static let tryAgainButtonAttributes: [NSAttributedString.Key: Any] = [
        .font: R.Fonts.interSemiBold(with: 16),
        .foregroundColor: R.Colors.activePrimary,
    ]
    static let tryAgainButtonAttributedString = NSAttributedString(
        string: R.Strings.Alert.tryAgain.localizedString,
        attributes: tryAgainButtonAttributes
    )
    
    enum Labels {
        static let leftOrRightInset: CGFloat = 16
        static let topOffset: CGFloat = 12
    }
}
