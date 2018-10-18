import UIKit

public enum UICollectionViewDecorativeKind: CustomStringConvertible {
    case header
    case footer

    /// Maps string value to decorative kind.
    /// Workaround because raw values of enum cases have to be literal.
    init?(string: String) {
        switch string {
        case UICollectionView.elementKindSectionHeader: self = .header
        case UICollectionView.elementKindSectionFooter: self = .footer
        default: return nil
        }
    }

    /// Returns string describing self.
    /// Workaround because raw values of enum cases have to be literal.
    public var description: String {
        switch self {
        case .header: return UICollectionView.elementKindSectionHeader
        case .footer: return UICollectionView.elementKindSectionFooter
        }
    }
}

extension UICollectionView: ModelDataSourceView {

    public typealias Cell = UICollectionViewCell
    public typealias Dimension = CGSize
    public typealias DecorativeKind = UICollectionViewDecorativeKind
    public typealias DecorativeView = UICollectionReusableView

    // MARK: Registry

    /**
     Allows to register classes of model data source view displayable views directly with their appropriate
     reuse identifier and their source file defintion (class or nib).

     - parameter view: The view type which should be registered to the data source view.
     */
    public func register<D>(_ view: D.Type) where D: UICollectionViewCell, D: ModelDataSourceViewDisplayable {
        switch view.source {
        case let .view(viewClass):
            self.register(viewClass, forCellWithReuseIdentifier: view.reuseIdentifier)
        case let .nib(nib):
            self.register(nib, forCellWithReuseIdentifier: view.reuseIdentifier)
        case .prototype:
            break // Skip, prototype cells are already registered within the storyboard
        }
    }

    /**
     Allows to register classes of model data source view decorative views directly with their appropriate
     reuse identifier and their source file defintion (class or nib).

     - parameter view: The view type which should be registered to the data source view.
     */
    public func register<D>(_ view: D.Type, as decorativeKind: DecorativeKind)
        where D: UICollectionReusableView, D: ModelDataSourceViewDisplayable {

            switch view.source {
            case let .view(viewClass):
                self.register(viewClass,
                              forSupplementaryViewOfKind: String(describing: decorativeKind),
                              withReuseIdentifier: view.reuseIdentifier)

            case let .nib(nib):
                self.register(nib,
                              forSupplementaryViewOfKind: String(describing: decorativeKind),
                              withReuseIdentifier: view.reuseIdentifier)

            case .prototype:
                break // Skip, prototype cells are already registered within the storyboard
            }
    }
}
