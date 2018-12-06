import UIKit

/// UITableViews do not support decorations other than section header or footer.
///
/// - header: Section header kind identifier
/// - footer: Section footer kind identifier
public enum UITableViewDecorativeKind: String {
    case header
    case footer
}

extension UITableView: ModelDataSourceView {

    public typealias Cell = UITableViewCell
    public typealias Dimension = CGFloat
    public typealias DecorativeView = UITableViewHeaderFooterView
    public typealias DecorativeKind = UITableViewDecorativeKind

    /// Allows to register classes of model data source view cells directly with their
    /// appropriate reuse identifier and their source file defintion (class or nib).
    ///
    /// - Parameter cell: The cell type which should be registered to the table view.
    public func register<C>(_ cell: C.Type) where C: UITableViewCell, C: ModelDataSourceViewDisplayable {
        switch cell.source {
        case let .view(viewClass):
            self.register(viewClass, forCellReuseIdentifier: cell.reuseIdentifier)
        case let .nib(nib):
            self.register(nib, forCellReuseIdentifier: cell.reuseIdentifier)
        case .prototype:
            break // Skip, prototype cells are already registered within the storyboard
        }
    }

    /// Allows to register classes of model data source decorative views directly with
    /// their appropriate reuse identifier and their source file defintion (class or nib).
    ///
    /// - Parameter view: The view type which should be registered to the table view.
    public func register<D>(_ view: D.Type) where D: UITableViewHeaderFooterView, D: ModelDataSourceViewDisplayable {
        switch view.source {
        case let .view(viewClass):
            self.register(viewClass, forHeaderFooterViewReuseIdentifier: view.reuseIdentifier)
        case let .nib(nib):
            self.register(nib, forHeaderFooterViewReuseIdentifier: view.reuseIdentifier)
        case .prototype:
            break // Skip, prototype cells are already registered within the storyboard
        }
    }
}

// MARK: - ModelDataSourceViewDisplayable

public extension ModelDataSourceViewDisplayable where Self: UITableViewCell {

    /// Optional fixed size definition to override dynamic height calculations.
    public static var staticSize: CGFloat? {
        return nil
    }
}

public extension ModelDataSourceViewDisplayable where Self: UITableViewHeaderFooterView {

    /// Optional fixed size definition to override dynamic height calculations.
    public static var staticSize: CGFloat? {
        return nil
    }
}
