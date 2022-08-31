import UIKit
import SnapKit

final class MainViewController: BaseViewController<MainView> {
    
    // MARK: - Constants
    
    private enum Constants {
        static let skeletonTableViewCellCount: Int = 12
        static let rowCellHeight: CGFloat = 84
    }
    
    // MARK: - Internal Properties
    
    private var viewModel: MainViewModel?
    
    // MARK: - Initilization
    
    convenience init(viewModel: MainViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTargets()
        setupBindings()
        setupDelegates()
        
        viewModel?.getTabs()
        viewModel?.getUsers()
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

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.saveLastUsedTab(indexPath.item)
        viewModel?.getDepartmentUsers(of: Department.allCases[indexPath.item])
    }
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return .zero }
        
        return viewModel.tabs.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tabCell = collectionView.dequeueCell(cellType: TabCollectionViewCell.self, for: indexPath)
        guard let viewModel = viewModel else { return tabCell }
        
        tabCell.configure(with: viewModel.tabs.value[indexPath.item].title)
        
        return tabCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: Find another solution, because this is a very expensive operation
        let label = UILabel(frame: CGRect.zero)
        label.text = viewModel?.tabs.value[indexPath.item].title
        label.sizeToFit()
        
        return CGSize(width: label.frame.width, height: selfView.tabsCollectionView.frame.height)
    }
}

// MARK: - UserTableViewTouchDelegate

extension MainViewController: UserTableViewTouchDelegate {
    
    func touchesBegunInTableview(_ touches: Set<UITouch>, with event: UIEvent?) {
        selfView.searchBar.endEditing(true)
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.rowCellHeight
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel, !viewModel.users.value.isEmpty else {
            return Constants.skeletonTableViewCellCount
        }
        
        return viewModel.departmentUsers.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueCell(cellType: UserTableViewCell.self)
        guard let viewModel = viewModel, !viewModel.users.value.isEmpty else { return userCell }
        
        userCell.shouldSkeletonViewsHide(true)
        userCell.configure(with: viewModel.departmentUsers.value[indexPath.row])
        
        return userCell
    }
}

// MARK: - Private Methods

private extension MainViewController {
    
    func configureNavigationBar() {
        navigationItem.titleView = selfView.searchBar
    }
    
    func setupTargets() {
        selfView.refreshControl.addTarget(self, action: #selector(refreshControlDidScroll), for: .valueChanged)
        selfView.searchBar.searchTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    
    func setupDelegates() {
        selfView.searchBar.delegate = self
        selfView.tabsCollectionView.delegate = self
        selfView.tabsCollectionView.dataSource = self
        selfView.userTableView.touchedDelegate = self
        selfView.userTableView.delegate = self
        selfView.userTableView.dataSource = self
    }
    
    func setupSelectedTab() {
        guard let viewModel = viewModel else { return }
        let indexPath = IndexPath(item: viewModel.selectedTabNumber, section: .zero)
        
        selfView.tabsCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func setupBindings() {
        viewModel?.users.observe { _ in
            DispatchQueue.main.async {
                self.viewModel?.getDepartmentUsers(of: Department.allCases[self.viewModel?.selectedTabNumber ?? .zero])
            }
        }
        
        viewModel?.departmentUsers.observe { [weak self] _ in
            DispatchQueue.main.async {
                self?.selfView.refreshControl.endRefreshing()
                self?.selfView.userTableView.reloadData()
                self?.setupSelectedTab()
            }
        }
    }
}

// MARK: - Actions

@objc
private extension MainViewController {
    
    func textChanged(_ sender: UITextField) {
        let image = sender.text?.count == .zero ? R.Images.SearchBar.leftImageNormal : R.Images.SearchBar.leftImageSelected
        sender.leftView = UIImageView.init(image: image)
    }
    
    func refreshControlDidScroll(_ refreshControl: UIRefreshControl) {
        viewModel?.getUsers()
    }
}
