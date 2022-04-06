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

/// We need to add a typealias for each class that implements ModelDataSourceViewDisplayable
/// to make Xcode13.3 / Swift 5.6 happy. Otherwise we would have to implement
/// public static var staticSize: Size for every class separatelly.
/// https://stackoverflow.com/questions/71563154/how-to-implement-static-variables-of-associated-types-in-protocol-extensions-in

extension UITableViewCell {
    public typealias Size = CGFloat
}

extension UITableViewHeaderFooterView {
    public typealias Size = CGFloat
}

extension ModelDataSourceViewDisplayable where Self: UITableViewCell {

    /// Optional fixed size definition to override dynamic height calculations.
    public static var staticSize: Size? {
        return nil
    }
}

extension ModelDataSourceViewDisplayable where Self: UITableViewHeaderFooterView {

    /// Optional fixed size definition to override dynamic height calculations.
    public static var staticSize: Size? {
        return nil
    }
}
