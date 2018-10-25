import UIKit

open class CollectionViewDataSource: NSObject {

    public typealias DataSourceView = UICollectionView
    public typealias Buffer = [ModelSection<UICollectionView>]
    public typealias Index = Buffer.Index

    private var buffer: Buffer

    open weak var delegate: CollectionViewDataSourceDelegate?

    /// Creates a new, empty collection (required by RangeReplaceableCollection)
    required override public init() {
        buffer = []
        super.init()
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
        delegate?.collectionView?(collectionView, prepareModelCell: cell, atIndexPath: indexPath)
        return cell
    }

    open func collectionView(_ collectionView: UICollectionView,
                             viewForSupplementaryElementOfKind kind: String,
                             at indexPath: IndexPath) -> UICollectionReusableView {

        guard let decorativeKind = UICollectionViewDecorativeKind(string: kind),
            let reuseIdentifier = self[indexPath.section, decorativeKind]?.reuseIdentifier else {
                fatalError("CollectionViewDataSource - could not dequeue collection decorative view of kind: \(kind) at: \(indexPath)")
        }

        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath)
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
