import UIKit
import SnapKit

final class MainViewController: BaseViewController<MainView> {
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTargets()
        setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
}

// MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
        
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
}

// MARK: - Private Methods

private extension MainViewController {
    
    func configureNavigationBar() {
        navigationItem.titleView = selfView.searchBar
    }
    
    func setupTargets() {
        selfView.searchBar.searchTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    
    func setupDelegates() {
        selfView.searchBar.delegate = self
    }
}

// MARK: - Actions

@objc
private extension MainViewController {
    
    func textChanged(_ sender: UITextField) {
        let image = sender.text?.count == .zero ? R.Images.SearchBar.leftImageNormal : R.Images.SearchBar.leftImageSelected
        sender.leftView = UIImageView.init(image: image)
    }
}
