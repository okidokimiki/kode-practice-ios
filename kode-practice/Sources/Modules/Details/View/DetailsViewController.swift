import UIKit

final class DetailsViewController: BaseViewController<DetailsView> {
    
    // MARK: - Constants
    
    private enum Constants {
        static let rowCellHeight: CGFloat = 60
    }
    
    // MARK: - Views
    
    lazy var backBarButton = BackBarButtonItem(target: navigationController ?? UINavigationController())
    
    // MARK: - Internal Properties
    
    private var viewModel: DetailsViewModel?
    
    // MARK: - Initilization
    
    convenience init(viewModel: DetailsViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.selfView.configure(with: viewModel.user)
    }
    
    deinit {
        self.swipeToPop(enable: false)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupBindings()
        
        selfView.configure(with: viewModel?.user)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.swipeToPop(enable: true)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension DetailsViewController: UIGestureRecognizerDelegate {
    
    func swipeToPop(enable: Bool) {
        if enable && (navigationController?.viewControllers.count ?? .zero > .one) {
            navigationController?.interactivePopGestureRecognizer?.delegate = self
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}

// MARK: - UITableViewDelegate

extension DetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if case .one = indexPath.item {
            callNumber(phoneNumber: viewModel?.user.phone)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.rowCellHeight
    }
}

// MARK: - UITableViewDataSource

extension DetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { .two }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noneCell = UITableViewCell(style: .default, reuseIdentifier: String(describing: UITableViewCell.self))
        let dateCell = tableView.dequeueCell(cellType: DateInfoTableViewCell.self)
        let phoneCell = tableView.dequeueCell(cellType: PhoneInfoTableViewCell.self)
        guard let viewModel = viewModel else { return noneCell }
        
        switch indexPath.item {
        case .zero:
            dateCell.configure(with: viewModel.dateInfo.value)
            return dateCell
        case .one:
            phoneCell.configure(with: viewModel.phoneInfo.value)
            return phoneCell
        default: return noneCell
        }
    }
}

// MARK: - Private Methods

private extension DetailsViewController {
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    func setupDelegates() {
        selfView.infoTableView.delegate = self
        selfView.infoTableView.dataSource = self
    }
    
    func callNumber(phoneNumber: String?) {
        guard let phoneNumber = phoneNumber,
              let url = URL(string: "telprompt://+7\(phoneNumber)"),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func setupBindings() {
        guard let viewModel = viewModel else { return }
        
        viewModel.dateInfo.observe { [weak self] _ in
            DispatchQueue.main.async {
                self?.selfView.infoTableView.reloadRows(at: [IndexPath(item: .one, section: .zero)], with: .none)
            }
        }
        
        viewModel.phoneInfo.observe { [weak self] _ in
            DispatchQueue.main.async {
                self?.selfView.infoTableView.reloadRows(at: [IndexPath(item: .two, section: .zero)], with: .none)
            }
        }
    }
}
