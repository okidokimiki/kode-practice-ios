import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureAppearance()
        configureUI()
    }
    
    /// Configure your baseview here.
    func configureAppearance() { }
    
    /// Add and Layout your subviews here.
    func configureUI() { }
}
