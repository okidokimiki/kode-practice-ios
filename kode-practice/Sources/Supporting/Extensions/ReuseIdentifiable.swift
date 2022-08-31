// Source: https://github.com/DmitriiChikovinskii/simpleviper/blob/master/ViperModule/Extensions/ReuseIdentifier.swift

import UIKit

// MARK: - ReuseIdentifiable

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String { .init(describing: self) }
}

// MARK: - UICollectionView

extension UICollectionReusableView: ReuseIdentifiable { }

extension UICollectionView {
    
    func dequeueCell<T: UICollectionViewCell>(cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Can't dequeue \(String(describing: T.self))")
        }
        
        return cell
    }
    
    func register<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
}

// MARK: - UITableView

extension UITableViewCell: ReuseIdentifiable { }

extension UITableViewHeaderFooterView: ReuseIdentifiable { }

extension UITableView {
    
    func dequeueCell<T: UITableViewCell>(cellType: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Can't dequeue \(String(describing: T.self))")
        }
        
        return cell
    }
    
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
}
