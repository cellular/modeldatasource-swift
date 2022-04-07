import Foundation

public struct ModelItem<V: ModelDataSourceView> {

    /// Model object stored within `self`.
    public let model: Any

    /// Cell class stored within `self`.
    public let cell: AnyClass

    /// Cell reuse identifier stored within `self`.
    public let reuseIdentifier: String

    /// The variable/dynamic dimension of the cell for sizing calculations.
    public let size: V.Dimension?

    /// Assigns the model to the given decorative. Returns true if the model was assigned successfully.
    public let assignModel: (V.Cell) -> Bool

    public init<M, C: ModelDataSourceViewDisplayable>(model: M, cell: C.Type) where C.Model == M, C.ModelDataSourceViewDisplayableDimension == V.Dimension {
        self.model = model
        self.cell = cell
        self.reuseIdentifier = cell.reuseIdentifier
        self.size = cell.staticSize
        self.assignModel = { cell in
            guard let modelcell = cell as? C else { return false }
            modelcell.model = model
            return true
        }
    }
}
