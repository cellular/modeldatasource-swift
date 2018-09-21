import Foundation

public struct ModelSection<V: ModelDataSourceView>: MutableCollection, RandomAccessCollection, RangeReplaceableCollection {

    public typealias DataSourceView = V
    public typealias Element = ModelItem<V>
    public typealias Index = Int

    private(set) public var items: [Element]
    private(set) public var decoratives: [DataSourceView.DecorativeKind: ModelDecorative<V>]

    public var startIndex: Index { return items.startIndex }
    public var endIndex: Index { return items.endIndex }

    public init() {
        items = []
        decoratives = [:]
    }

    public func index(after index: Int) -> Int {
        return items.index(after: index)
    }

    public subscript(index: Int) -> ModelItem<V> {
        get {
            return items[index]

        } set {
            items[index] = newValue
        }
    }
}
