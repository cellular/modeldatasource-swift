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
    public subscript(index: Index) -> ModelItem<V> {
        get {
            return items[index]
        }
        set {
            items[index] = newValue
        }
    }

    /// Replaces the specified subrange of elements with the given collection.
    ///
    /// This method has the effect of removing the specified range of elements
    /// from the collection and inserting the new elements at the same location.
    /// The number of new elements need not match the number of elements being
    /// removed.
    ///
    /// If you pass a zero-length range as the `subrange` parameter, this method
    /// inserts the elements of `newElements` at `subrange.startIndex`. Calling
    /// the `insert(contentsOf:at:)` method instead is preferred.
    ///
    /// Likewise, if you pass a zero-length collection as the `newElements`
    /// parameter, this method removes the elements in the given subrange
    /// without replacement. Calling the `removeSubrange(_:)` method instead is
    /// preferred.
    ///
    /// Calling this method may invalidate any existing indices for use with this
    /// collection.
    ///
    /// - Parameters:
    ///   - subrange: The subrange of the collection to replace. The bounds of
    ///     the range must be valid indices of the collection.
    ///   - newElements: The new elements to add to the collection.
    ///
    /// - Complexity: O(*n* + *m*), where *n* is length of this collection and
    ///   *m* is the length of `newElements`. If the call to this method simply
    ///   appends the contents of `newElements` to the collection, the complexity
    ///   is O(*m*).
    public mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C)
        where C: Collection, R: RangeExpression, ModelItem<V> == C.Element, ModelSection<V>.Index == R.Bound {

        items.replaceSubrange(subrange, with: newElements)
    }
}

// MARK: - Convenience

public extension ModelSection {

    /// Access a specific decirative view.
    ///
    /// - Parameter kind: The kind of the decorative view to access.
    subscript(kind: DataSourceView.DecorativeKind) -> ModelDecorative<DataSourceView>? {
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
