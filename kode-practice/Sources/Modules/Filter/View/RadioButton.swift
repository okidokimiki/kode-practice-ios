import UIKit

final class RadioButton: UIButton {
    
    // MARK: - Constants
    
    private enum Constants {
        static let frame: CGRect = .init(x: .zero, y: .zero, width: 21, height: 21)
        static let defaultBorderWidth: CGFloat = 2
        static let selectedBorderWidth: CGFloat = 6.5
    }
    
    // MARK: - Override Properties
    
    override var isSelected: Bool {
        didSet { updateAppearance() }
    }
    
    // MARK: - UIButton
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureAppearance()
    }
}

// MARK: - Private Methods

private extension RadioButton {
    
    func configureAppearance() {
        frame = Constants.frame
        backgroundColor = .none
        layer.borderColor = R.Colors.activePrimary.cgColor
        layer.borderWidth = Constants.defaultBorderWidth
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
    }
    
    func updateAppearance() {
        layer.borderWidth = isSelected ? Constants.selectedBorderWidth : Constants.defaultBorderWidth
    }
}
