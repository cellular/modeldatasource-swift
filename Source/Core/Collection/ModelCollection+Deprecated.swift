import Foundation

// MARK: - Deprecated API

public extension ModelCollection {

    @available(*, deprecated, message: "use subscript[section].isEmpty instead")
    func isEmptySection(_ section: Index) -> Bool {
        return self[section].isEmpty
    }

    @available(*, deprecated, message: "use subscript[section].count instead")
    func countInSection(_ section: Int) -> Int {
        return self[section].count
    }

    @available(*, deprecated, message: "Create empty  ModelSection and append it instead.")
    @discardableResult
    mutating func appendSection() -> Index {
        return append(section: .init())
    }

    @available(*, deprecated, message: "Create a ModelSection and append it instead.")
    @discardableResult
    mutating func appendSection<M, D: ModelDataSourceViewDisplayable>(_ model: M, view: D.Type, ofKind kind: DataSourceView.DecorativeKind)
        -> Int where D.Model == M, D.Size == DataSourceView.Dimension {
            return append(section: .init(decorative: .init(model: model, view: view), kind: kind))
    }

    @available(*, deprecated, renamed: "append(decorative:ofKind:)")
    @discardableResult
    mutating func append<M, D: ModelDataSourceViewDisplayable>(_ model: M,
                                                               view: D.Type,
                                                               ofKind: DataSourceView.DecorativeKind,
                                                               inSection: Index? = nil)
        -> Index where D.Model == M, D.Size == DataSourceView.Dimension {

         return append(decorative: .init(model: model, view: view), ofKind: ofKind)
    }

    @available(*, deprecated, renamed: "append(item:inSection:)")
    @discardableResult
    mutating func append<M, C: ModelDataSourceViewDisplayable>(_ model: M, cell: C.Type, inSection: Index? = nil)
        -> IndexPath where C.Model == M, C.Size == DataSourceView.Dimension {

            return append(item: .init(model: model, cell: cell), inSection: inSection)
    }

    @available(*, deprecated, renamed: "append(contentsOf:cell:inSection:)")
    @discardableResult
    mutating func appendContentsOf<M, C: ModelDataSourceViewDisplayable>(_ models: [M],
                                                                         cell: C.Type,
                                                                         inSection: Index? = nil) -> [IndexPath]
                                                                         where C.Model == M, C.Size == DataSourceView.Dimension {

            return append(contentsOf: models, cell: cell, inSection: inSection)
    }

    @available(*, deprecated, renamed: "insert(item:index:)")
    mutating func insert<M, C: ModelDataSourceViewDisplayable>(_ model: M, cell: C.Type, index: IndexPath) where C.Model == M,
        C.Size == DataSourceView.Dimension {

        insert(item: .init(model: model, cell: cell), indexPath: index)
    }

    @available(*, deprecated, renamed: "remove(at:)")
    @discardableResult
    mutating func removeAtIndex(_ index: IndexPath) -> ModelItem<DataSourceView> {
        return remove(at: index)
    }

    @available(*, deprecated, renamed: "remove(at:)")
    @discardableResult
    mutating func removeAtIndex(_ indices: [IndexPath]) -> [ModelItem<DataSourceView>] {
        return remove(at: Set(indices))
    }

    @available(*, deprecated, renamed: "remove(at:)")
    @discardableResult
    mutating func removeAtIndex(_ indices: [Index]) -> [ModelSection<DataSourceView>] {
        return remove(at: Set(indices))
    }
}
