import Foundation

public struct ModelSection<V: ModelDataSourceView>: MutableCollection, RandomAccessCollection, RangeReplaceableCollection {

    public typealias DataSourceView = V
    public typealias Element = ModelItem<DataSourceView>
    public typealias Index = Int

    // MARK: Storage

    private var items: [Element]
    private var decoratives: [DataSourceView.DecorativeKind: ModelDecorative<DataSourceView>]

    // MARK: Init

    public init(decoratives: [DataSourceView.DecorativeKind: ModelDecorative<DataSourceView>], items: [Element]) {
        self.decoratives = decoratives
        self.items = items
    }

    public init(decorative: ModelDecorative<DataSourceView>, kind: DataSourceView.DecorativeKind) {
        self.init(decoratives: [kind: decorative], items: [])
    }
}

// MARK: - Collection conformance (MutableCollection, RandomAccessCollection, RangeReplaceableCollection)

extension ModelSection {

    /// Empty initializer required by RangeReplaceableCollection
    public init() {
        self.init(decoratives: [:], items: [])
    }

    /// The position of the first element in a nonempty collection.
    ///
    /// If the collection is empty, `startIndex` is equal to `endIndex`.
    public var startIndex: Index {
        return items.startIndex
    }

    /// The collection's "past the end" position---that is, the position one
    /// greater than the last valid subscript argument.
    ///
    /// When you need a range that includes the last element of a collection, use
    /// the half-open range operator (`..<`) with `endIndex`. The `..<` operator
    /// creates a range that doesn't include the upper bound, so it's always
    /// safe to use with `endIndex`. For example:
    ///
    /// If the collection is empty, `endIndex` is equal to `startIndex`.
    public var endIndex: Index {
        return items.endIndex
    }

    /// Accesses the element at the specified position.
    ///
    /// You can subscript a collection with any valid index other than the
    /// collection's end index. The end index refers to the position one
    /// past the last element of a collection, so it doesn't correspond with an
    /// element.
    ///
    /// - Parameter position: The position of the element to access. `position`
    ///   must be a valid index of the collection that is not equal to the
    ///   `endIndex` property.
    ///
    /// - Complexity: O(1)
    public subscript(index: Int) -> ModelItem<V> {
        get {
            return items[index]
        }
        set {
            items[index] = newValue
        }
    }
}

// MARK: - Convenience

public extension ModelSection {

    /// Access a specific decirative view.
    ///
    /// - Parameter kind: The kind of the decorative view to access.
    public subscript(kind: DataSourceView.DecorativeKind) -> ModelDecorative<DataSourceView>? {
        get {
            return decoratives[kind]
        }
        set {
            decoratives[kind] = newValue
        }
    }

    /// Searches for cells matching the given cell type.
    ///
    /// - Parameter cell: Type of the cell to find.
    /// - Returns: Returns positions of the found cells.
    func find(_ cell: DataSourceView.Cell.Type) -> [Index] {
        return enumerated().compactMap { item in
            return item.element.cell == cell ? item.offset : nil
        }
    }

    /// Rmeoves decorative of the given lind
    ///
    /// - Parameters:
    ///   - ofKind: The type of the decorative view to remove
    /// - Returns: Removed Decorative or nil
    mutating func remove(decorative ofKind: DataSourceView.DecorativeKind) -> ModelDecorative<DataSourceView>? {
        let decorativeToRemove = self[ofKind]
        self[ofKind] = nil
        return decorativeToRemove
    }
}
