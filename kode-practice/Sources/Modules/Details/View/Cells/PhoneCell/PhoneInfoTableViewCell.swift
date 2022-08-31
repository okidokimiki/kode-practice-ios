import UIKit
import SnapKit

final class PhoneInfoTableViewCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        enum IconImageView {
            static let height: CGFloat = 20
            static let leftOffset: CGFloat = 16
        }
        
        enum PhoneNumberLabel {
            static let textFont = R.Fonts.interMedium(with: 16)
            static let leftOffset: CGFloat = 14
        }
        
        enum SeparatorView {
            static let leftOrRightInset: CGFloat = 14
            static let height: CGFloat = 0.5
        }
    }
    
    // MARK: - Views
    
    private lazy var separator = DateInfoTableViewCell.makeSeparator()
    private lazy var iconImageView = DateInfoTableViewCell.makeIconImageView(icon: R.Images.Details.phone)
    private lazy var phoneNumberLabel = PhoneInfoTableViewCell.makeLabel()
    
    // MARK: - UITableViewCell
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    // MARK: - ConfigurePerCell
    
    func configure(with model: PhoneInfoTableViewCellModel?) {
        guard let model = model else { return }
        phoneNumberLabel.text = model.phoneNumber
    }
}

// MARK: - Private Methods

private extension PhoneInfoTableViewCell {
    
    func configureUI() {
        [iconImageView, phoneNumberLabel, separator].forEach { contentView.addSubview($0) }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Constants.IconImageView.leftOffset)
            make.height.width.equalTo(Constants.IconImageView.height)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(Constants.PhoneNumberLabel.leftOffset)
            make.centerY.equalTo(iconImageView.snp.centerY)
        }
        
        separator.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.right.left.equalToSuperview().inset(Constants.SeparatorView.leftOrRightInset)
            make.height.equalTo(Constants.SeparatorView.height)
        }
    }
}

// MARK: - Creating Subviews

extension PhoneInfoTableViewCell {
    
    static func makeLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = R.Colors.Text.active
        label.font = Constants.PhoneNumberLabel.textFont
        
        return label
    }
}
