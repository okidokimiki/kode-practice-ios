import UIKit

final class BackBarButtonItem: UIBarButtonItem {
    
    // MARK: - UIBarButtonItem
    
    convenience init(target: UINavigationController) {
        self.init()
        self.target = target
        configureAppearance()
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Private Methods

private extension BackBarButtonItem {
    
    func configureAppearance() {
        style = .plain
        image = R.Images.backArrow
        tintColor = R.Colors.Text.active
        action = #selector(UINavigationController.popViewController(animated:))
    }
}
