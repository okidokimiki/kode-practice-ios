import UIKit

final class TabsCollectionView: UICollectionView {
    
    typealias TabCell = TabCollectionViewCell
    
    // MARK: - UICollectionView
    
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Constants.spaceBetweenElements
        layout.scrollDirection = .horizontal
        layout.sectionInset = Constants.sectionInset
        self.init(frame: .zero, collectionViewLayout: layout)
        configureAppearance()
        registerCells()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Private Methods

private extension TabsCollectionView {
    
    func configureAppearance() {
        showsHorizontalScrollIndicator = false
    }
    
    func registerCells() {
        register(TabCell.self)
    }
}

// MARK: - Constants

private enum Constants {
    static let sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    static let spaceBetweenElements: CGFloat = 8
}
