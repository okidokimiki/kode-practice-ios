import UIKit
import SnapKit

final class DateInfoTableViewCell: UITableViewCell {
    
    // MARK: - Views
    
    private lazy var separator = DateInfoTableViewCell.makeSeparator()
    private lazy var iconImageView = DateInfoTableViewCell.makeIconImageView(icon: R.Images.Details.start)
    private lazy var dateLabel = DateInfoTableViewCell.makeLabel(
        textColor: R.Colors.Text.active,
        textAlignment: .left
    )
    private lazy var ageLabel = DateInfoTableViewCell.makeLabel(
        textColor: R.Colors.Text.inActive,
        textAlignment: .right
    )
    
    // MARK: - UITableViewCell
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearance()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureAppearance()
        configureUI()
    }
    
    // MARK: - ConfigurePerCell
    
    func configure(with model: DateInfoTableViewCellModel?) {
        guard let model = model, let age = model.age else { return }
        let wordAge = Locale.current.languageCode == "ru" ? age.ruWordAge() : "year"
        dateLabel.text = model.birthday
        ageLabel.text = String(describing: age) + " " + wordAge
    }
}

// MARK: - Private Methods

private extension DateInfoTableViewCell {
    
    func configureAppearance() {
        selectionStyle = .none
    }
    
    func configureUI() {
        [iconImageView, dateLabel, ageLabel, separator].forEach { contentView.addSubview($0) }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Constants.IconImageView.leftOffset)
            make.height.width.equalTo(Constants.IconImageView.height)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(Constants.DateLabel.leftOffset)
            make.centerY.equalTo(iconImageView.snp.centerY)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constants.AgeLabelLabel.rightInset)
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

extension DateInfoTableViewCell {
    
    static func makeIconImageView(icon: UIImage?) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = icon
        
        return imageView
    }
    
    static func makeLabel(textColor: UIColor, textAlignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.font = R.Fonts.interMedium(with: 16)
        
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
    
    enum DateLabel {
        static let leftOffset: CGFloat = 14
    }
    
    enum AgeLabelLabel {
        static let rightInset: CGFloat = 14
    }
    
    enum SeparatorView {
        static let leftOrRightInset: CGFloat = 14
        static let height: CGFloat = 0.5
    }
}
