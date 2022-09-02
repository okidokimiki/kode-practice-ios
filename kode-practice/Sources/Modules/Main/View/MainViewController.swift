import UIKit
import SnapKit

final class MainViewController: BaseViewController<MainView> {
    
    // MARK: - Views
    
    private lazy var noInternetView = NoInternetView()
    private lazy var filterViewController = FilterViewController()
    
    // MARK: - Gestures
    
    private lazy var noInternetTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapNoInternerView))
    
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
        setupNoInternetView()
        setupGestureRecognizerDelegates()
        
        subscribeToNotifications()
        
        viewModel?.getTabs()
        viewModel?.getUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension MainViewController: UIGestureRecognizerDelegate {
    
    func setupGestureRecognizerDelegates() {
        noInternetTapGesture.delegate = self
    }
}

// MARK: - FilterDelegate

extension MainViewController: FilterDelegate {
    
    func didChangeFilter(by filter: FilterType) {
        viewModel?.filterType.value = filter
        
        selfView.userTableView.reloadData()
        selfView.searchBar.text = ""
        searchBar(selfView.searchBar, textDidChange: "")
        switch filter {
        case .byAlphabet:
            selfView.searchBar.setImage(R.Images.SearchBar.rightImageNormal, for: .bookmark, state: .normal)
        case .byBirthday:
            selfView.searchBar.setImage(R.Images.SearchBar.rightImageSelected, for: .bookmark, state: .normal)
        }
    }
}

// MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.getSearchedUsers(by: searchText)
    }
    
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
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        guard let viewModel = viewModel else { return }
        filterViewController.viewModel = .init(selectedFiltered: viewModel.filterType)
        present(filterViewController, animated: true)
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
        guard let viewModel = viewModel, !viewModel.users.value.isEmpty else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailsViewModel: DetailsViewModel
        switch viewModel.filterType.value {
        case .byAlphabet:
            detailsViewModel = .init(viewModel.filteredByAlphabetUsers[indexPath.item])
        case .byBirthday:
            if indexPath.section == .zero {
                detailsViewModel = .init(viewModel.filteredByHappyBirthdayThisYearUsers[indexPath.item])
            } else {
                detailsViewModel = .init(viewModel.filteredByHappyBirthdayNextYearUsers[indexPath.item])
            }
        }
        
        navigationController?.pushViewController(DetailsViewController(viewModel: detailsViewModel), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.rowCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        section != .zero ? UserHeaderView() : nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section != .zero ? Constants.headerViewHeight : .zero
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel, let userCell = cell as? UserTableViewCell else { return }
        
        switch viewModel.filterType.value {
        case .byAlphabet:
            userCell.shouldBirthdayDateHide(true)
        case .byBirthday:
            userCell.shouldBirthdayDateHide(false)
        }
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else { return .zero }
        
        switch viewModel.filterType.value {
        case .byAlphabet:
            return .one
        case .byBirthday:
            return .two
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel, !viewModel.users.value.isEmpty else {
            return Constants.skeletonTableViewCellCount
        }
        
        switch viewModel.filterType.value {
        case .byAlphabet:
            return viewModel.filteredByAlphabetUsers.count
        case .byBirthday:
            return section == .zero ? viewModel.filteredByHappyBirthdayThisYearUsers.count : viewModel.filteredByHappyBirthdayNextYearUsers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueCell(cellType: UserTableViewCell.self)
        guard let viewModel = viewModel, !viewModel.users.value.isEmpty else { return userCell }
        
        userCell.shouldSkeletonViewsHide(true)
        switch viewModel.filterType.value {
        case .byAlphabet:
            userCell.configure(with: viewModel.filteredByAlphabetUsers[indexPath.item])
        case .byBirthday:
            let models = indexPath.section == .zero ? viewModel.filteredByHappyBirthdayThisYearUsers : viewModel.filteredByHappyBirthdayNextYearUsers
            userCell.configure(with: models[indexPath.item])
        }
        
        return userCell
    }
}

// MARK: - Private Methods

private extension MainViewController {
    
    func configureNavigationBar() {
        navigationItem.titleView = selfView.searchBar
    }
    
    func setupTargets() {
        selfView.refreshControl.addTarget(self, action: #selector(didScrollRefreshControl), for: .valueChanged)
        selfView.searchBar.searchTextField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
    }
    
    func setupDelegates() {
        filterViewController.delegate = self
        
        selfView.searchBar.delegate = self
        selfView.tabsCollectionView.delegate = self
        selfView.tabsCollectionView.dataSource = self
        selfView.userTableView.touchedDelegate = self
        selfView.userTableView.delegate = self
        selfView.userTableView.dataSource = self
    }
    
    func setupNoInternetView() {
        noInternetView.addGestureRecognizer(noInternetTapGesture)
        
        navigationController?.view.addSubview(noInternetView)
        noInternetView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(Constants.noInternetInitialHeight)
        }
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
                self?.viewModel?.getSearchedUsers()
                self?.setupSelectedTab()
            }
        }
        
        viewModel?.searchedUsers.observe { [weak self] _ in
            DispatchQueue.main.async {
                self?.selfView.userTableView.reloadData()
            }
        }
        
        viewModel?.searchState.observe { [weak self] state in
            DispatchQueue.main.async {
                if case .none = state {
                    self?.selfView.noSearchResultView.shouldHideView(false)
                } else {
                    self?.selfView.noSearchResultView.shouldHideView(true)
                }
            }
        }
        
        viewModel?.networkState.observe { [weak self] state in
            DispatchQueue.main.async {
                if case let .failed(failureReason) = state {
                    switch failureReason {
                    case .internalServerError(let internalError):
                        print("!__: ", internalError)
                        self?.issueInternalErrorAlert { self?.viewModel?.getUsers() }
                        print(internalError)
                    case .noInternet:
                        self?.shouldNoInternetViewBePresented(true)
                    }
                }
            }
        }
    }
    
    func shouldNoInternetViewBePresented(_ shouldPresenet: Bool) {
        noInternetView.snp.updateConstraints { $0.height.equalTo(shouldPresenet ? navigationBarbarContentStart : .zero) }
        
        noInternetView.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.5) { self.noInternetView.layoutIfNeeded() } completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    guard self.noInternetView.frame.height != self.navigationBarbarContentStart else {
                        self.shouldNoInternetViewBePresented(false)
                        return
                    }
                }
            }
        }
    }
    
    func issueInternalErrorAlert(completionHandler: @escaping () -> Void) {
        lazy var alertViewController = InternalErrorViewController(dismissCompletionHandler: completionHandler)
        alertViewController.modalPresentationStyle = .fullScreen
        present(alertViewController, animated: true)
    }
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangeConnectivityStatus),
            name: NSNotification.Name.connectivityStatus,
            object: nil
        )
    }
}

// MARK: - Actions

@objc
private extension MainViewController {
    
    func didChangeText(_ sender: UITextField) {
        let image = sender.text?.count == .zero ? R.Images.SearchBar.leftImageNormal : R.Images.SearchBar.leftImageSelected
        sender.leftView = UIImageView.init(image: image)
    }
    
    func didScrollRefreshControl(_ refreshControl: UIRefreshControl) {
        viewModel?.getUsers()
    }
    
    func didChangeConnectivityStatus(_ notification: Notification) {
        if NetworkMonitor.shared.isConnected {
            viewModel?.networkState.value = .default
        } else {
            viewModel?.networkState.value = .failed(.noInternet)
        }
    }
    
    func didTapNoInternerView(_ sender: UITapGestureRecognizer) {
        shouldNoInternetViewBePresented(false)
    }
}

// MARK: - Constants

private enum Constants {
    static let skeletonTableViewCellCount: Int = 12
    static let rowCellHeight: CGFloat = 84
    static let headerViewHeight: CGFloat = 68
    static let noInternetInitialHeight: CGFloat = 0
}
