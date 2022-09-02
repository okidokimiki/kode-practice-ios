import UIKit
import SnapKit

final class UserHeaderView: BaseView {
    
    // MARK: - Views
    
    private lazy var yearLabel = UserHeaderView.makeYearLabel()
    private lazy var leftLineView = UserHeaderView.makeLineView()
    private lazy var rightLineView = UserHeaderView.makeLineView()
    
    // MARK: - UI
    
    override func configureUI() {
        super.configureUI()
        [yearLabel, leftLineView, rightLineView].forEach{ addSubview($0) }
        
        yearLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(Constants.YearLabel.width)
        }
        
        leftLineView.snp.makeConstraints { make in
            make.centerY.equalTo(yearLabel.snp.centerY)
            make.height.equalTo(Constants.lineHeight)
            make.left.equalToSuperview().inset(Constants.YearLabel.leftOrRightInset)
            make.right.equalTo(yearLabel.snp.left)
        }
        
        rightLineView.snp.makeConstraints { make in
            make.centerY.equalTo(yearLabel.snp.centerY)
            make.height.equalTo(Constants.lineHeight)
            make.right.equalToSuperview().inset(Constants.YearLabel.leftOrRightInset)
            make.left.equalTo(yearLabel.snp.right)
        }
    }
}

// MARK: - Creating Subviews

extension UserHeaderView {
    
    static func makeYearLabel() -> UILabel {
        let label = UILabel()
        label.text = Constants.YearLabel.nextYearText
        label.font = Constants.YearLabel.yearTextFont
        label.textColor = R.Colors.separator
        label.textAlignment = .center
        
        return label
    }
    
    static func makeLineView() -> UIView {
        let view = UIView()
        view.backgroundColor = R.Colors.separator
        
        return view
    }
}

// MARK: - Constants

private enum Constants {
    static let lineHeight: CGFloat = 1
    enum YearLabel {
        static let yearTextFont = R.Fonts.interMedium(with: 16)
        static let leftOrRightInset: CGFloat = 24
        static let width: CGFloat = 160
        static let nextYearText = "\(Calendar(identifier: .gregorian).dateComponents([.year], from: Date()).year! + 1)"
    }
}
