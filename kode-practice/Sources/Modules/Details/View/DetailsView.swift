import UIKit
import SnapKit

final class DetailsView: BaseView {
    
    // MARK: - Constants
    
    private enum Constants {
        enum AvatarImageView {
            static let height: CGFloat = 104
            static let negativeTopOffset: CGFloat = -20
        }
        
        enum FullNameLabel {
            static let textFont = R.Fonts.interBold(with: 24)
            static let topOffset: CGFloat = 24
        }
        
        enum TagLabel {
            static let textFont = R.Fonts.interMedium(with: 17)
            static let topOffset: CGFloat = 4
        }
        
        enum DepartmentLabel {
            static let textFont = R.Fonts.interRegular(with: 13)
            static let topOffset: CGFloat = 12
        }
        
        enum InfoTableView {
            static let topOffset: CGFloat = 32
        }
    }
    
    // MARK: - Views
    
    private lazy var fullNameLabel = DetailsView.makeLabel(
        textColor: R.Colors.Text.active,
        font: Constants.FullNameLabel.textFont
    )
    private lazy var tagLabel = DetailsView.makeLabel(
        textColor: R.Colors.Text.inActive,
        font: Constants.TagLabel.textFont
    )
    private lazy var departmentLabel = DetailsView.makeLabel(
        textColor: R.Colors.Text.secondary,
        font: Constants.DepartmentLabel.textFont
    )
    private lazy var avatarImageView = DetailsView.makeAvatarImageView()
    lazy var infoTableView = InfoTableView(frame: .zero, style: .plain)
    
    // MARK: - Configure
    
    func configure(with model: UserTableViewCellModel?) {
        guard let model = model else { return }
        
        fullNameLabel.text = model.fullName
        tagLabel.text = model.userTag
        departmentLabel.text = model.department.title
        avatarImageView.loadImage(from: model.logoUrl)
    }
    
    // MARK: - Appearance
    
    override func configureAppearance() {
        super.configureAppearance()
        backgroundColor = R.Colors.detailsBackground
    }
    
    // MARK: - UI
    
    override func configureUI() {
        super.configureUI()
        [avatarImageView, departmentLabel, fullNameLabel, tagLabel, infoTableView].forEach { addSubview($0) }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(Constants.AvatarImageView.negativeTopOffset)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(Constants.AvatarImageView.height)
        }
        
        fullNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarImageView.snp.bottom).offset(Constants.FullNameLabel.topOffset)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.left.equalTo(fullNameLabel.snp.right).offset(Constants.TagLabel.topOffset)
            make.centerY.equalTo(fullNameLabel.snp.centerY)
        }
        
        departmentLabel.snp.makeConstraints { make in
            make.top.equalTo(fullNameLabel.snp.bottom).offset(Constants.DepartmentLabel.topOffset)
            make.centerX.equalToSuperview()
        }
        
        infoTableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(departmentLabel.snp.bottom).offset(Constants.InfoTableView.topOffset)
        }
    }
}

// MARK: - Creating Subviews

extension DetailsView {
    
    static func makeLabel(textColor: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.numberOfLines = .zero
        label.textColor = textColor
        label.textAlignment = .center
        label.font = font
        
        return label
    }
    
    static func makeAvatarImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.AvatarImageView.height / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        
        return imageView
    }
}
