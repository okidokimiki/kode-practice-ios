import SnapKit

final class NoSearchResultView: BaseView {
    
    // MARK: - Views
    
    private lazy var titleLabel = NoSearchResultView.makeLabel(
        text: R.Strings.NoResult.title.localizedString,
        font: Constants.TitleLabel.titleTextFont,
        textColor: R.Colors.Text.active
    )
    private lazy var messageLabel = NoSearchResultView.makeLabel(
        text: R.Strings.NoResult.message.localizedString,
        font: Constants.MessageLabel.messageTextFont,
        textColor: R.Colors.Text.inActive
    )
    private lazy var errorEmojiLabel = NoSearchResultView.makeErrorEmojiLabel()
    
    // MARK: - Public Methods
    
    func shouldHideView(_ shouldHide: Bool) {
        isHidden = shouldHide
    }
    
    // MARK: - Appearance
    
    override func configureAppearance() {
        super.configureAppearance()
        backgroundColor = .white
        isHidden = true
    }
    
    // MARK: - UI
    
    override func configureUI() {
        super.configureUI()
        [errorEmojiLabel, titleLabel, messageLabel].forEach{ addSubview($0) }
        
        errorEmojiLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Constants.ErrorEmojiLabel.topOffset)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(errorEmojiLabel.snp.bottom).offset(Constants.TitleLabel.topOffset)
            make.left.right.equalTo(self).inset(Constants.leftOrRightInset)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.MessageLabel.topOffset)
            make.left.right.equalTo(self).inset(Constants.leftOrRightInset)
        }
    }
    
}

// MARK: - Creating Subviews

extension NoSearchResultView {
    
    static func makeErrorEmojiLabel() -> UILabel {
        let label = UILabel()
        label.text = R.USymlos.magnifyingGlass.rawValue
        label.font = Constants.ErrorEmojiLabel.emojiTextFont
        
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
}

// MARK: - Constants

private enum Constants {
    static let leftOrRightInset: CGFloat = 16
    
    enum ErrorEmojiLabel {
        static let emojiTextFont: UIFont = .systemFont(ofSize: 60)
        static let topOffset: CGFloat = 80
    }
    
    enum TitleLabel {
        static let titleTextFont = R.Fonts.interSemiBold(with: 17)
        static let topOffset: CGFloat = 8
    }
    
    enum MessageLabel {
        static let messageTextFont = R.Fonts.interRegular(with: 16)
        static let topOffset: CGFloat = 12
    }
}
