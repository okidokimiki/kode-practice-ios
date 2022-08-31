import UIKit

final class InternalErrorViewController: BaseViewController<InternalErrorView> {
    
    // MARK: - Internal Properties
    
    private var dismissCompletionHandler: (() -> Void)?
    
    // MARK: - UIViewController
    
    convenience init(dismissCompletionHandler: @escaping () -> Void) {
        self.init(nibName: nil, bundle: nil)
        self.dismissCompletionHandler = dismissCompletionHandler
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTargets()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissCompletionHandler?()
    }
}

// MARK: - Private Methods

private extension InternalErrorViewController {
    
    func setTargets() {
        selfView.tryAgainButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
    }
}

// MARK: - Actions

@objc
private extension InternalErrorViewController {
    
    func dismissAlert() {
        dismiss(animated: true)
    }
}
