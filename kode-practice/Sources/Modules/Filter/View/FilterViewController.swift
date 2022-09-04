import UIKit

protocol FilterDelegate: AnyObject {
    func didChangeFilter(by filter: FilterType)
}

final class FilterViewController: BaseViewController<FilterView> {
    
    // MARK: - Delegate Properties
    
    weak var delegate: FilterDelegate?
    
    // MARK: - Internal Properties
    
    var viewModel: FilterViewModel?
    
    // MARK: - Private Properties
    
    private let radioController = RadioButtonController()
    
    // MARK: - Initilization
    
    convenience init(viewModel: FilterViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        setupTargets()
        configureRadioController()
    }
}

// MARK: - Private Methods

private extension FilterViewController {
    
    func configureRadioController() {
        guard let viewModel = viewModel else { return }
        radioController.buttonsArray = [selfView.byAlphabetRadioButton, selfView.byBirthdayRadioButton]
        
        switch viewModel.getFilterType() {
        case .byAlphabet:
            radioController.defaultButton = selfView.byAlphabetRadioButton
        case .byBirthday:
            radioController.defaultButton = selfView.byBirthdayRadioButton
        }
    }
    
    func setupTargets() {
        selfView.byAlphabetRadioButton.addTarget(self, action: #selector(didTapAlphabetRadioButton), for: .touchUpInside)
        selfView.byBirthdayRadioButton.addTarget(self, action: #selector(didTapBirthdayRadioButton), for: .touchUpInside)
    }
    
    func binding() {
        viewModel?.filterType.observe { [weak self] type in
            DispatchQueue.main.async {
                switch type {
                case .byAlphabet:
                    self?.radioController.buttonArrayUpdated(buttonSelected: self?.selfView.byAlphabetRadioButton)
                case .byBirthday:
                    self?.radioController.buttonArrayUpdated(buttonSelected: self?.selfView.byBirthdayRadioButton)
                }
            }
        }
    }
}

// MARK: - Actions

@objc
private extension FilterViewController {
    
    func didTapAlphabetRadioButton() {
        viewModel?.saveLastSelectedFilterType(.byAlphabet)
        delegate?.didChangeFilter(by: .byAlphabet)
        
    }
    
    func didTapBirthdayRadioButton() {
        viewModel?.saveLastSelectedFilterType(.byBirthday)
        delegate?.didChangeFilter(by: .byBirthday)
    }
}
