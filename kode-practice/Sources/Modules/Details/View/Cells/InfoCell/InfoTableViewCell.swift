import UIKit
import SnapKit

enum InfoCellType: CaseIterable {
    case date
    case phone
}

final class InfoTableViewCell: UITableViewCell {
    
    // MARK: - Views
    
    private lazy var separator = InfoTableViewCell.makeSeparator()
    private lazy var iconImageView = InfoTableViewCell.makeIconImageView()
    private lazy var contentLabel = InfoTableViewCell.makeLabel(
        textColor: R.Colors.Text.active,
        textAlignment: .left
    )
    private lazy var ageLabel = InfoTableViewCell.makeLabel(
        textColor: R.Colors.Text.inActive,
        textAlignment: .right
    )
    
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
    
    func configure(by type: InfoCellType, with model: InfoTableViewCellModel?) {
        guard let model = model, let age = model.age else { return }
        
        switch type {
        case .date:
            // TODO: Next time use `stringdict` for pluralization
            let wordAge = Locale.current.languageCode == "ru" ? age.ruWordAge() : "year"
            
            contentLabel.text = model.birthday
            ageLabel.text = String(describing: age) + " " + wordAge
            selectionStyle = .none
            iconImageView.image = R.Images.Details.start
        case .phone:
            contentLabel.text = model.phoneNumber
            iconImageView.image = R.Images.Details.phone
        }
    }
}

// MARK: - Private Methods

private extension InfoTableViewCell {
    
    func configureUI() {
        [iconImageView, contentLabel, ageLabel, separator].forEach { contentView.addSubview($0) }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Constants.IconImageView.leftOffset)
            make.height.width.equalTo(Constants.IconImageView.height)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(Constants.Labels.leftOrRightOffset)
            make.centerY.equalTo(iconImageView.snp.centerY)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constants.Labels.leftOrRightOffset)
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

extension InfoTableViewCell {
    
    static func makeIconImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        
        return imageView
    }
    
    static func makeLabel(textColor: UIColor, textAlignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.font = Constants.Labels.textFont
        
        return label
    }
    
    static func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = R.Colors.detailsBackground
        
        return view
    }
}

// MARK: - Constants

private enum Constants {
    enum IconImageView {
        static let height: CGFloat = 20
        static let leftOffset: CGFloat = 16
    }
    
    enum Labels {
        static let textFont = R.Fonts.interMedium(with: 16)
        static let leftOrRightOffset: CGFloat = 14
    }
    
    enum SeparatorView {
        static let leftOrRightInset: CGFloat = 14
        static let height: CGFloat = 0.5
    }
}
