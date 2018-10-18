import Foundation
import UIKit

public protocol ModelCollection: MutableCollection, RandomAccessCollection, RangeReplaceableCollection
    where Self.Element == ModelSection<Self.DataSourceView>, Self.Index == Int {

    associatedtype DataSourceView: ModelDataSourceView
    associatedtype Buffer: MutableCollection, RandomAccessCollection, RangeReplaceableCollection
        where Buffer.Element == Self.Element, Buffer.Index == Self.Index

    var buffer: Buffer { get set }
}

// MARK: - MutableCollection, RandomAccessCollection, RangeReplaceableCollection

public extension ModelCollection {

    public var startIndex: Index {
        return buffer.startIndex
    }

    public var endIndex: Index {
        return buffer.endIndex
    }

    public subscript(index: Index) -> ModelSection<DataSourceView> {
        get {
            return buffer[index]
        }
        set {
            buffer[index] = newValue
        }
    }

    public func index(after index: Index) -> Int {
        return buffer.index(after: index)
    }

    public mutating func replaceSubrange<C>(_ subrange: Range<Index>, with newElements: C) where C: Collection, Self.Element == C.Element {
        buffer.replaceSubrange(subrange, with: newElements)
    }
}

// MARK: - Convenience

public extension ModelCollection {

    subscript(indexPath: IndexPath) -> ModelItem<DataSourceView> {
        get {
            return buffer[indexPath.section][indexPath.item]
        }
        set {
            buffer[indexPath.section][indexPath.item] = newValue
        }
    }

    subscript(section: Index, kind: DataSourceView.DecorativeKind) -> ModelDecorative<DataSourceView>? {
        get {
            return self[section][kind]
        }
        set {
            guard let newValue = newValue else { return }
            self[section][kind] = newValue
        }
    }

    /// Appends a section to self.
    ///
    /// - Returns: The index of the newly created section.
    @discardableResult
    mutating func append(section: ModelSection<DataSourceView>) -> Index {
        let index = buffer.count
        append(section)
        return index
    }

    @discardableResult
    mutating func append(decorative: ModelDecorative<DataSourceView>,
                         ofKind: DataSourceView.DecorativeKind,
                         inSection: Index? = nil) -> Index {

        if isEmpty { append(.init()) } // Creates a first section on empty data sources
        let sectionToAppend = inSection ?? endIndex - 1 // Either given section or the last section if none givens
        self[sectionToAppend][ofKind] = decorative
        return sectionToAppend
    }

    @discardableResult
    mutating func append(item: ModelItem<DataSourceView>, inSection: Index? = nil) -> IndexPath {

        if isEmpty { append(.init()) } // Creates a first section on empty data sources
        let sectionToAppend = inSection ?? endIndex - 1  // Either given section or the last section if none given
        self[sectionToAppend].append(item)
        let itemIndex = self[sectionToAppend].endIndex - 1
        return IndexPath(item: itemIndex, section: sectionToAppend)
    }

    @discardableResult
    mutating func append<M, C: ModelDataSourceViewDisplayable>(contentsOf models: [M], cell: C.Type) -> [IndexPath] where C.Model == M,
        C.Size == DataSourceView.Dimension {

        return models.map { append(item: .init(model: $0, cell: cell)) }
    }

    mutating func insert(_ item: ModelItem<DataSourceView>, indexPath: IndexPath) {
        self[indexPath.section].insert(item, at: indexPath.item)
    }

    func find(_ cell: DataSourceView.Cell.Type) -> [IndexPath] {
        return enumerated().reduce(into: [IndexPath]()) { (result, sectionItem)  in
            let section = sectionItem.offset
            let paths = self[section].find(cell).map { IndexPath.init(item: $0, section: section) }
            result.append(contentsOf: paths)
        }
    }
}

// MARK: - Deprecated API

public extension ModelCollection {

    @available(*, deprecated: 5.0, message: "use subscript[section].isEmpty instead")
    func isEmptySection(_ section: Index) -> Bool {
        return self[section].isEmpty
    }

    @available(*, deprecated: 5.0, message: "use subscript[section].count instead")
    func countInSection(_ section: Int) -> Int {
        return self[section].count
    }

    @available(*, deprecated: 5.0, renamed: "append(section:)")
    @discardableResult
    mutating func appendSection(_ section: ModelSection<DataSourceView> = ModelSection()) -> Index {
        return append(section: section)
    }

    @available(*, deprecated: 5.0, message: "Create a ModelSection and append it instead.")
    @discardableResult
    mutating func appendSection<M, D: ModelDataSourceViewDisplayable>(_ model: M, view: D.Type, ofKind kind: DataSourceView.DecorativeKind)
        -> Int where D.Model == M, D.Size == DataSourceView.Dimension {

        return appendSection(.init(decorative: .init(model: model, view: view), kind: kind))
    }

    @available(*, deprecated: 5.0, renamed: "append(decorative:ofKind:)")
    @discardableResult
    mutating func append<M, D: ModelDataSourceViewDisplayable>(_ model: M,
                                                               view: D.Type,
                                                               ofKind: DataSourceView.DecorativeKind,
                                                               inSection: Index? = nil)
                                                               -> Index where D.Model == M, D.Size == DataSourceView.Dimension {

        return append(decorative: .init(model: model, view: view), ofKind: ofKind)
    }

    @discardableResult
    @available(*, deprecated: 5.0, renamed: "append(item:inSection:)")
    mutating func append<M, C: ModelDataSourceViewDisplayable>(_ model: M, cell: C.Type, inSection: Index? = nil)
        -> IndexPath where C.Model == M, C.Size == DataSourceView.Dimension {

        return append(item: .init(model: model, cell: cell), inSection: inSection)
    }

    @available(*, deprecated: 5.0, renamed: "append(contentsOf:cell:)")
    @discardableResult
    mutating func appendContentsOf<M, C: ModelDataSourceViewDisplayable>(_ models: [M], cell: C.Type) -> [IndexPath] where C.Model == M,
        C.Size == DataSourceView.Dimension {
        return append(contentsOf: models, cell: cell)
    }

    @available(*, deprecated: 5.0, renamed: "insert(_:index:)")
    mutating func insert<M, C: ModelDataSourceViewDisplayable>(_ model: M, cell: C.Type, index: IndexPath) where C.Model == M,
        C.Size == DataSourceView.Dimension {

        insert(.init(model: model, cell: cell), indexPath: index)
    }

    mutating func bla<M, D: ModelDataSourceViewDisplayable>(_ model: M, view: D.Type)
        -> Int where D.Model == M, D.Size == DataSourceView.Dimension {
        return 0
    }
}
