import Foundation

public struct ModelDecorative<V: ModelDataSourceView> {

    /// Model object stored within `self`.
    public var model: Any

    /// Cell class stored within `self`.
    public var view: AnyClass

    /// Cell reuse identifier stored within `self`.
    public var reuseIdentifier: String

    public var size: V.Dimension?

    public init<M, D: ModelDataSourceViewDisplayable>(model: M, view: D.Type)
        where D.Model == M, D.Size == V.Dimension {

        self.model = model
        self.view = view
        self.reuseIdentifier = view.reuseIdentifier
        self.size = view.staticSize
    }
}
