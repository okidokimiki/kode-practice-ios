import UIKit
import SnapKit

final class FilterView: BaseView {
    
    // MARK: - Constants
    
    private enum Constants {
        enum Separator {
            static let frame: CGRect = .init(x: .zero, y: .zero, width: 56, height: 4)
            static let topInset: CGFloat = 8
            static let height: CGFloat = 4
            static let width: CGFloat = 56
        }
        
        enum TitleLabel {
            static let textFont = R.Fonts.interSemiBold(with: 20)
            static let topOffset: CGFloat = 24
        }
        
        enum FilterTypeLabel {
            static let textFont = R.Fonts.interMedium(with: 16)
        }
        
        enum RadioButton {
            static let width: CGFloat = 21
            static let leftOffset: CGFloat = 18
            static let labelLeftOffset: CGFloat = 14
            static let byAlphabetTopOffset: CGFloat = 35
            static let byBirthdayTopOffset: CGFloat = 40
        }
        
    }
    
    // MARK: - Views
    
    private lazy var separator = FilterView.makeSeparator()
    private lazy var title = FilterView.makeTitleLabel()
    private lazy var byAlphabetLabel = FilterView.makeFilterTypeLabel(text: R.Strings.Filter.filterByAlphabet.localizedString)
    private lazy var byBirthdayLabel = FilterView.makeFilterTypeLabel(text: R.Strings.Filter.filterByBirthday.localizedString)
    lazy var byAlphabetRadioButton = RadioButton()
    lazy var byBirthdayRadioButton = RadioButton()
    
    // MARK: - Appearance
    
    override func configureAppearance() {
        super.configureAppearance()
        backgroundColor = .white
    }
    
    // MARK: - UI
    
    override func configureUI() {
        super.configureUI()
        [separator, title, byAlphabetRadioButton, byBirthdayRadioButton, byAlphabetLabel, byBirthdayLabel].forEach { addSubview($0) }
        
        separator.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.Separator.topInset)
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.Separator.height)
            make.width.equalTo(Constants.Separator.width)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(Constants.TitleLabel.topOffset)
            make.centerX.equalToSuperview()
        }
        
        byAlphabetRadioButton.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.RadioButton.width)
            make.left.equalToSuperview().offset(Constants.RadioButton.leftOffset)
            make.top.equalTo(title.snp.bottom).offset(Constants.RadioButton.byAlphabetTopOffset)
        }
        
        byBirthdayRadioButton.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.RadioButton.width)
            make.left.equalToSuperview().offset(Constants.RadioButton.leftOffset)
            make.top.equalTo(byAlphabetRadioButton.snp.bottom).offset(Constants.RadioButton.byBirthdayTopOffset)
        }
        
        byAlphabetLabel.snp.makeConstraints { make in
            make.left.equalTo(byAlphabetRadioButton.snp.right).offset(Constants.RadioButton.labelLeftOffset)
            make.centerY.equalTo(byAlphabetRadioButton.snp.centerY)
        }
        
        byBirthdayLabel.snp.makeConstraints { make in
            make.left.equalTo(byBirthdayRadioButton.snp.right).offset(Constants.RadioButton.labelLeftOffset)
            make.centerY.equalTo(byBirthdayRadioButton.snp.centerY)
        }
    }
}

// MARK: - Creating Subviews

extension FilterView {
    
    static func makeSeparator() -> UIView {
        let view = UIView()
        view.frame = Constants.Separator.frame
        view.backgroundColor = R.Colors.separator
        view.layer.cornerRadius = view.bounds.height / 2
        view.layer.masksToBounds = true
        
        return view
    }
    
    static func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = R.Strings.Filter.title.localizedString
        label.textColor = R.Colors.Text.active
        label.font = Constants.TitleLabel.textFont
        
        return label
    }
    
    static func makeFilterTypeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = R.Colors.Text.active
        label.font = Constants.FilterTypeLabel.textFont
        
        return label
    }
}
