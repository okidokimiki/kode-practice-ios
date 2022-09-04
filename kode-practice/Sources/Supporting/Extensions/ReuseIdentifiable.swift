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
    
    func dequeueCell<Cell: UICollectionViewCell>(cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Can't dequeue \(String(describing: Cell.self))")
        }
        
        return cell
    }
    
    func register<Cell: UICollectionViewCell>(_ cellType: Cell.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
}

// MARK: - UITableView

extension UITableViewCell: ReuseIdentifiable { }

extension UITableViewHeaderFooterView: ReuseIdentifiable { }

extension UITableView {
    
    func dequeueCell<Cell: UITableViewCell>(cellType: Cell.Type) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: Cell.reuseIdentifier) as? Cell else {
            fatalError("Can't dequeue \(String(describing: Cell.self))")
        }
        
        return cell
    }
    
    func register<Cell: UITableViewCell>(_ cellType: Cell.Type) {
        register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
}
