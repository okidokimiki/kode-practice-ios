import UIKit

final class DetailsViewController: BaseViewController<DetailsView> {
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        InfoCellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let infoCell = tableView.dequeueCell(cellType: InfoTableViewCell.self)
        guard let viewModel = viewModel else { return infoCell }
        
        infoCell.configure(with: viewModel.getInfoCellModel(with: indexPath))
        
        return infoCell
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
}

// MARK: - Constants

private enum Constants {
    static let rowCellHeight: CGFloat = 60
}
