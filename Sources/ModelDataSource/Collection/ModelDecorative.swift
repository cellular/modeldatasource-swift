import Foundation

public struct ModelDecorative<V: ModelDataSourceView> {

    /// Model object stored within `self`.
    public let model: Any

    /// Cell class stored within `self`.
    public let view: AnyClass

    /// Cell reuse identifier stored within `self`.
    public let reuseIdentifier: String

    /// The variable/dynamic dimension of the cell for sizing calculations.
    public let size: V.Dimension?

    /// Assigns the model to the given decorative. Returns true if the model was assigned successfully.
    public let assignModel: (V.DecorativeView) -> Bool

    public init<M, D: ModelDataSourceViewDisplayable>(model: M, view: D.Type) where D.Model == M, D.Size == V.Dimension {
        self.model = model
        self.view = view
        self.reuseIdentifier = view.reuseIdentifier
        self.size = view.staticSize
        self.assignModel = { decorative in
            guard let modelDecorative = decorative as? D else { return false }
            modelDecorative.model = model
            return true
        }
    }
}
