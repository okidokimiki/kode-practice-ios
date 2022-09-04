import UIKit
import SnapKit

final class UserTableViewCell: UITableViewCell {
    
    // MARK: - Views
    
    private lazy var skeletonAvatarView = UserTableViewCell.makeSkeletonView(
        width: Constants.AvatarImageView.height,
        height: Constants.AvatarImageView.height
    )
    private lazy var skeletonFullNameView = UserTableViewCell.makeSkeletonView(
        width: Constants.FullNameLabel.width,
        height: Constants.FullNameLabel.height
    )
    private lazy var skeletonDepartmentView = UserTableViewCell.makeSkeletonView(
        width: Constants.DepartmentLabel.width,
        height: Constants.DepartmentLabel.height
    )
    
    private lazy var fullNameLabel = UserTableViewCell.makeLabel(
        textColor: R.Colors.Text.active,
        font: Constants.FullNameLabel.textFont
    )
    private lazy var tagLabel = UserTableViewCell.makeLabel(
        textColor: R.Colors.Text.inActive,
        font: Constants.TagLabel.textFont
    )
    private lazy var departmentLabel = UserTableViewCell.makeLabel(
        textColor: R.Colors.Text.secondary,
        font: Constants.DepartmentLabel.textFont
    )
    private lazy var birthdayDateLabel = UserTableViewCell.makeLabel(
        textColor: R.Colors.Text.secondary,
        textAlignment: .right,
        font: Constants.BirthdayDateLabel.textFont
    )
    private lazy var avatarImageView = UserTableViewCell.makeAvatarImageView()
    
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
    
    override func prepareForReuse() {
        avatarImageView.image = nil
    }
    
    func configure(with model: UserTableViewCellModel) {
        birthdayDateLabel.text = model.shortFormatBirthday
        avatarImageView.loadImage(from: model.logoUrl)
        departmentLabel.text = model.department.title
        fullNameLabel.text = model.fullName
        tagLabel.text = model.userTag
    }
    
    func shouldSkeletonViewsHide(_ shouldHide: Bool) {
        [skeletonAvatarView, skeletonFullNameView, skeletonDepartmentView].forEach { $0.isHidden = shouldHide }
    }
    
    func shouldBirthdayDateHide(_ shouldHide: Bool) {
        birthdayDateLabel.isHidden = shouldHide
    }
}

// MARK: - Private Methods

private extension UserTableViewCell {
    
    func configureUI() {
        [skeletonAvatarView, skeletonFullNameView, skeletonDepartmentView,
         avatarImageView, fullNameLabel, tagLabel, departmentLabel, birthdayDateLabel]
            .forEach{ contentView.addSubview($0) }
        
        skeletonAvatarView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(Constants.AvatarImageView.leftOrRightInset)
            make.top.equalToSuperview().inset(Constants.AvatarImageView.topOrBottomInset)
            make.width.height.equalTo(Constants.AvatarImageView.height)
        }
        
        skeletonFullNameView.snp.makeConstraints { make in
            make.left.equalTo(skeletonAvatarView.snp.right).offset(Constants.AvatarImageView.leftOrRightInset)
            make.top.equalToSuperview().inset(Constants.FullNameLabel.topInset)
            make.width.equalTo(Constants.FullNameLabel.width)
            make.height.equalTo(Constants.FullNameLabel.height)
        }
        
        skeletonDepartmentView.snp.makeConstraints { make in
            make.left.equalTo(skeletonAvatarView.snp.right).offset(Constants.AvatarImageView.leftOrRightInset)
            make.top.equalTo(skeletonFullNameView.snp.bottom).offset(Constants.DepartmentLabel.topOffset)
            make.width.equalTo(Constants.DepartmentLabel.width)
            make.height.equalTo(Constants.DepartmentLabel.height)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(Constants.AvatarImageView.leftOrRightInset)
            make.top.bottom.equalToSuperview().inset(Constants.AvatarImageView.topOrBottomInset)
            make.width.height.equalTo(Constants.AvatarImageView.height)
        }
        
        fullNameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(Constants.AvatarImageView.leftOrRightInset)
            make.top.equalToSuperview().inset(Constants.FullNameLabel.topInset)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.left.equalTo(fullNameLabel.snp.right).offset(Constants.TagLabel.leftOffset)
            make.centerY.equalTo(fullNameLabel.snp.centerY)
        }
        
        departmentLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(Constants.AvatarImageView.leftOrRightInset)
            make.top.equalTo(fullNameLabel.snp.bottom).offset(Constants.DepartmentLabel.topOffset)
        }
        
        birthdayDateLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constants.BirthdayDateLabel.rightInset)
            make.centerY.equalTo(avatarImageView.snp.centerY)
        }
    }
}

// MARK: - Creating Subviews

extension UserTableViewCell {
    
    static func makeSkeletonView(width: CGFloat, height: CGFloat) -> UIView {
        let view = UIView()
        view.frame = .init(
            x: .zero,
            y: .zero,
            width: width,
            height: height
        )
        view.layerGradient(
            startPoint: .centerLeft,
            endPoint: .centerRight,
            colorArray: Constants.gradientColors,
            type: .axial
        )
        view.layer.masksToBounds = true
        view.layer.cornerRadius = height / 2
        
        return view
    }
    
    static func makeAvatarImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.frame = Constants.AvatarImageView.frame
        imageView.layer.cornerRadius = Constants.AvatarImageView.height / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        
        return imageView
    }
    
    static func makeLabel(textColor: UIColor, textAlignment: NSTextAlignment = .left, font: UIFont) -> UILabel {
        let label = UILabel()
        label.numberOfLines = .zero
        label.layer.masksToBounds = true
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.font = font
        
        return label
    }
}

// MARK: - Constants

private enum Constants {
    static let gradientColors: [CGColor] = [
        R.Colors.Gradient.loadingSkeletonStart.cgColor,
        R.Colors.Gradient.loadingSkeletonEnd.cgColor
    ]
    
    enum AvatarImageView {
        static let topOrBottomInset: CGFloat = 6
        static let leftOrRightInset: CGFloat = 16
        static let height: CGFloat = 72
        static let frame: CGRect = .init(
            x: .zero,
            y: .zero,
            width: Constants.AvatarImageView.height,
            height: Constants.AvatarImageView.height
        )
    }
    
    enum FullNameLabel {
        static let textFont = R.Fonts.interMedium(with: 16)
        static let topInset: CGFloat = 25
        static let height: CGFloat = 16
        static let width: CGFloat = 144
    }
    
    enum TagLabel {
        static let textFont = R.Fonts.interMedium(with: 14)
        static let leftOffset: CGFloat = 4
    }
    
    enum DepartmentLabel {
        static let textFont = R.Fonts.interRegular(with: 13)
        static let topOffset: CGFloat = 6
        static let height: CGFloat = 12
        static let width: CGFloat = 80
    }
    
    enum BirthdayDateLabel {
        static let rightInset: CGFloat = 19.5
        static let textFont = R.Fonts.interRegular(with: 15)
    }
}
