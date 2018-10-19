import Foundation

public struct ModelItem<V: ModelDataSourceView> {

    /// Model object stored within `self`.
    public var model: Any

    /// Cell class stored within `self`.
    public var cell: AnyClass

    /// Cell reuse identifier stored within `self`.
    public var reuseIdentifier: String

    /// The variable/dynamic dimension of the cell for sizing calculations.
    public var size: V.Dimension?

    public init<M, C: ModelDataSourceViewDisplayable>(model: M, cell: C.Type) where C.Model == M, C.Size == V.Dimension {
        self.model = model
        self.cell = cell
        self.reuseIdentifier = cell.reuseIdentifier
        self.size = cell.staticSize
    }
}
