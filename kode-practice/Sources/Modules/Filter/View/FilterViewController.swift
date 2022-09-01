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
        setupTargets()
        setupBindings()
        
        configureRadioController()
    }
}

// MARK: - Private Methods

private extension FilterViewController {
    
    func configureRadioController() {
        guard let viewModel = viewModel else { return }
        
        radioController.buttonsArray = [selfView.byAlphabetRadioButton, selfView.byBirthdayRadioButton]
        switch viewModel.selectedFiltered.value {
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
    
    func setupBindings() {
        viewModel?.selectedFiltered.observe { [weak self] filterBy in
            DispatchQueue.main.async {
                switch filterBy {
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
        viewModel?.selectedFiltered.value = .byAlphabet
        delegate?.didChangeFilter(by: .byAlphabet)
        
    }
    
    func didTapBirthdayRadioButton() {
        viewModel?.selectedFiltered.value = .byBirthday
        delegate?.didChangeFilter(by: .byBirthday)
    }
}
