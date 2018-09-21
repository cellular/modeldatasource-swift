import Foundation

public protocol ModelDataSourceView: class {

    /// The base cell class to be displayed within the data source driven view.
    associatedtype Cell // Must implicitly conform to ModelDataSourceViewDisplayable

    /// The variable/dynamic dimension of the cell for sizing calculations.
    associatedtype Dimension

    associatedtype DecorativeView

    /// The descriptor of the decorative view positioning (e.g. TableView Header or Footer)
    associatedtype DecorativeKind: Hashable
}
