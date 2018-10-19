import Foundation

public struct ModelSection<V: ModelDataSourceView>: MutableCollection, RandomAccessCollection, RangeReplaceableCollection {

    public typealias DataSourceView = V
    public typealias Element = ModelItem<DataSourceView>
    public typealias Index = Int

    private var items: [Element]
    private var decoratives: [DataSourceView.DecorativeKind: ModelDecorative<DataSourceView>]

    public var startIndex: Index { return items.startIndex }
    public var endIndex: Index { return items.endIndex }

    /// Empty initializer required by RangeReplaceableCollection
    public init() {
        self.init(decoratives: [:], items: [])
    }

    public init(decoratives: [DataSourceView.DecorativeKind: ModelDecorative<DataSourceView>], items: [Element]) {
        self.decoratives = decoratives
        self.items = items
    }

    public init(decorative: ModelDecorative<DataSourceView>, kind: DataSourceView.DecorativeKind) {
        self.init(decoratives: [kind: decorative], items: [])
    }

    public func index(after index: Int) -> Int {
        return items.index(after: index)
    }

    public subscript(index: Int) -> ModelItem<V> {
        get {
            return items[index]

        }
        set {
            items[index] = newValue
        }
    }

    public subscript(kind: DataSourceView.DecorativeKind) -> ModelDecorative<DataSourceView>? {
        get {
            return decoratives[kind]
        }
        set {
            decoratives[kind] = newValue
        }
    }
}

// MARK: - Convenience

public extension ModelSection {

    func find(_ cell: DataSourceView.Cell.Type) -> [Index] {
        return enumerated().compactMap { item in
            return item.element.cell == cell ? item.offset : nil
        }
    }

    mutating func remove(decorative kind: DataSourceView.DecorativeKind) -> ModelDecorative<DataSourceView>? {
        let decorativeToRemove = self[kind]
        self[kind] = nil
        return decorativeToRemove
    }
}
