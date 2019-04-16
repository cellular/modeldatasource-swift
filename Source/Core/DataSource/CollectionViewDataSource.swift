import UIKit

open class CollectionViewDataSource: NSObject {

    public typealias DataSourceView = UICollectionView
    public typealias Buffer = [ModelSection<UICollectionView>]
    public typealias Index = Buffer.Index

    private var buffer: Buffer

    open weak var delegate: CollectionViewDataSourceDelegate?

    /// Creates a new, empty collection (required by RangeReplaceableCollection)
    override required public init() {
        buffer = []
        super.init()
    }

    /// The total number of elements that the collection can contain without
    /// allocating new storage.
    public var capacity: Int {
        return buffer.capacity
    }
}

// MARK: - ModelCollection conformance (MutableCollection, RandomAccessCollection, RangeReplaceableCollection)

extension CollectionViewDataSource: ModelCollection {

    /// The position of the first element in a nonempty collection.
    ///
    /// If the collection is empty, `startIndex` is equal to `endIndex`.
    public var startIndex: Buffer.Index {
        return buffer.startIndex
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
    public var endIndex: Buffer.Index {
        return buffer.endIndex
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
    public subscript(index: Buffer.Index) -> ModelSection<DataSourceView> {
        get {
            return buffer[index]
        }
        set {
            buffer[index] = newValue
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
    public func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C: Collection, R: RangeExpression,
        ModelSection<CollectionViewDataSource.DataSourceView> == C.Element, CollectionViewDataSource.Index == R.Bound {

        buffer.replaceSubrange(subrange, with: newElements)
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewDataSource: UICollectionViewDataSource {

    open func sizeForDecorativeView(inSection section: Int, ofKind kind: UICollectionViewDecorativeKind) -> CGSize? {
        return self[section, kind]?.size
    }

    open func sizeForCellAtIndexPath(_ index: IndexPath) -> CGSize? {
        return self[index].size
    }

    // MARK: UICollectionView DataSource Support

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return count
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self[section].count
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self[indexPath].reuseIdentifier, for: indexPath)
        _ = self[indexPath].assignModel(cell)
        delegate?.collectionView?(collectionView, prepareModelCell: cell, atIndexPath: indexPath)
        return cell
    }

    open func collectionView(_ collectionView: UICollectionView,
                             viewForSupplementaryElementOfKind kind: String,
                             at indexPath: IndexPath) -> UICollectionReusableView {

        guard let decorativeKind = UICollectionViewDecorativeKind(string: kind),
            let modelDecorative = self[indexPath.section, decorativeKind] else {
            fatalError("CollectionViewDataSource - could not dequeue collection decorative view of kind: \(kind) at: \(indexPath)")
        }

        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: modelDecorative.reuseIdentifier,
                                                                   for: indexPath)
        _ = modelDecorative.assignModel(view)
        delegate?.collectionView?(collectionView, prepareDecorativeView: view, atIndexPath: indexPath)
        return view
    }

    open func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return delegate?.collectionView?(collectionView, canMoveItemAtIndexPath: indexPath) ?? false
    }

    open func collectionView(_ collectionView: UICollectionView, moveItemAt moveItemAtIndexPath: IndexPath, to toIndexPath: IndexPath) {
        delegate?.collectionView?(collectionView, moveItemAtIndexPath: moveItemAtIndexPath, toIndexPath: toIndexPath)
    }

}
