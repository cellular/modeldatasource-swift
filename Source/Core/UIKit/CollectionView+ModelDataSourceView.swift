import UIKit

/// UICollectionViews do not support decorations other than section header or footer.
///
/// - header: Section header kind identifier
/// - footer: Section footer kind identifier
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

    /// Allows to register classes of model data source view cells directly with their
    /// appropriate reuse identifier and their source file defintion (class or nib).
    ///
    /// - Parameter cell: The cell type which should be registered to the table view.
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

    /// Allows to register classes of model data source decorative views directly with
    /// their appropriate reuse identifier and their source file defintion (class or nib).
    ///
    /// - Parameters:
    ///   - view: The view type which should be registered to the data source view.
    ///   - decorativeKind: Tge decorative kind of the view to register.
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

// MARK: - ModelDataSourceViewDisplayable

public extension ModelDataSourceViewDisplayable where Self: UICollectionView {

    /// Optional fixed size definition to override dynamic height calculations.
    public static var staticSize: CGSize? {
        return nil
    }
}

public extension ModelDataSourceViewDisplayable where Self: UICollectionReusableView {

    /// Optional fixed size definition to override dynamic height calculations.
    public static var staticSize: CGSize? {
        return nil
    }
}
