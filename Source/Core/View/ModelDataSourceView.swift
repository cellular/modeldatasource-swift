import Foundation

/// View protocol to be implemented by classes that should support two dimensional model handling and is driven by a data source.
public protocol ModelDataSourceView: class {

    /// The base cell class to be displayed within the data source driven view.
    associatedtype Cell // Must implicitly conform to ModelDataSourceViewDisplayable

    /// The variable/dynamic dimension of the cell for sizing calculations.
    associatedtype Dimension

    /// The base decorative view class to be displayed within the data source driven view.
    associatedtype DecorativeView

    /// The descriptor of the decorative view positioning (e.g. TableView Header or Footer)
    associatedtype DecorativeKind: Hashable
}
