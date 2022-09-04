import UIKit
import SnapKit

final class MainViewController: BaseViewController<MainView> {
    
    typealias UserCell = UserTableViewCell
    typealias TabCell = TabCollectionViewCell
    
    // MARK: - Views
    
    private lazy var noInternetView = NoInternetView()
    private lazy var filterViewController = FilterViewController()
    
    // MARK: - Gestures
    
    private lazy var hideNoInternetOnTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapNoInternerView))
    
    // MARK: - Internal Properties
    
    private var viewModel: MainViewModel
    
    // MARK: - Initilization
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        subscribeToNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        unsubscribeFromAllNotifications()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        setupTargets()
        setupDelegates()
        setupNoInternetView()
        setupGestureRecognizerDelegates()
        
        viewModel.getTabs()
        viewModel.getUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension MainViewController: UIGestureRecognizerDelegate {
    
    func setupGestureRecognizerDelegates() {
        hideNoInternetOnTapGesture.delegate = self
    }
}

// MARK: - FilterDelegate

extension MainViewController: FilterDelegate {
    
    func didChangeFilter(by filter: FilterType) {
        viewModel.filterType.value = filter
        
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
        viewModel.getSearchedUsers(by: searchText)
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
        filterViewController.viewModel = .init(filterType: viewModel.filterType)
        present(filterViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.saveLastUsedTab(indexPath.item)
        viewModel.getDepartmentUsers(of: Department.allCases[indexPath.item])
    }
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getTabItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tabCell = collectionView.dequeueCell(cellType: TabCell.self, for: indexPath)
        
        tabCell.configure(with: viewModel.getTabTitleForCell(with: indexPath))
        
        return tabCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: Find another solution, because this is a very expensive operation
        let label = UILabel(frame: CGRect.zero)
        label.text = viewModel.tabs.value[indexPath.item].title
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
        guard !viewModel.users.value.isEmpty else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailsViewModel = DetailsViewModel.init(viewModel.getUserCellModel(with: indexPath))
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
        guard let userCell = cell as? UserCell else { return }
        
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
        viewModel.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !viewModel.users.value.isEmpty else {
            return Constants.skeletonTableViewCellCount
        }
        
        return viewModel.getNumberOfRowsInSection(of: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueCell(cellType: UserCell.self)
        guard !viewModel.users.value.isEmpty else { return userCell }
        
        userCell.shouldSkeletonViewsHide(true)
        userCell.configure(with: viewModel.getUserCellModel(with: indexPath))
        
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
        noInternetView.addGestureRecognizer(hideNoInternetOnTapGesture)
        
        navigationController?.view.addSubview(noInternetView)
        noInternetView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(Constants.noInternetInitialHeight)
        }
    }
    
    func setupSelectedTab() {
        let indexPath = IndexPath(item: viewModel.selectedTabNumber, section: .zero)
        
        selfView.tabsCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func binding() {
        viewModel.users.observe { _ in
            DispatchQueue.main.async {
                self.viewModel.getDepartmentUsers(of: Department.allCases[self.viewModel.selectedTabNumber])
            }
        }
        
        viewModel.departmentUsers.observe { [weak self] _ in
            DispatchQueue.main.async {
                self?.selfView.refreshControl.endRefreshing()
                self?.viewModel.getSearchedUsers()
                self?.setupSelectedTab()
            }
        }
        
        viewModel.searchedUsers.observe { [weak self] _ in
            DispatchQueue.main.async {
                self?.selfView.userTableView.reloadData()
            }
        }
        
        viewModel.searchState.observe { [weak self] state in
            DispatchQueue.main.async {
                if case .none = state {
                    self?.selfView.noSearchResultView.shouldHideView(false)
                } else {
                    self?.selfView.noSearchResultView.shouldHideView(true)
                }
            }
        }
        
        viewModel.networkState.observe { [weak self] state in
            DispatchQueue.main.async {
                if case let .failed(failureReason) = state {
                    switch failureReason {
                    case .internalServerError(let internalError):
                        print("!__: ", internalError)
                        self?.issueInternalErrorAlert { self?.viewModel.getUsers() }
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
    
    func unsubscribeFromAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
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
        viewModel.getUsers()
    }
    
    func didChangeConnectivityStatus(_ notification: Notification) {
        if NetworkMonitor.shared.isConnected {
            viewModel.networkState.value = .default
        } else {
            viewModel.networkState.value = .failed(.noInternet)
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
