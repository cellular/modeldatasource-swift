import UIKit

open class CollectionViewDataSource: NSObject, ModelCollection {

    public typealias DataSourceView = UICollectionView
    public typealias Storage = [ModelSection<UICollectionView>]
    public var storage: [ModelSection<UICollectionView>] = []

    open weak var delegate: CollectionViewDataSourceDelegate?

    required override public init() {
        super.init()
    }
}

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

// MARK: - Delegate

@objc public protocol CollectionViewDataSourceDelegate: NSObjectProtocol {

    /**
     Forwards each cell within the data source to the delegate before displaying it in a particular location of the collection view.

     - parameter collectionView: The collection-view object that is about to present the specified cell.
     - parameter cell:           The cell to be used to position within the collection view and that may be prepared before being displayed.
     - parameter indexPath:      The index path at which the cell is about to be positioned within the specified collection view.
     */
    @objc optional func collectionView(_ collectionView: UICollectionView, prepareModelCell cell: UICollectionViewCell,
                                       atIndexPath indexPath: IndexPath)

    /**
     Forwards each decorative within the data source to the delegate before displaying it in a particular location of the collection view.

     - parameter collectionView: The collection-view object that is about to present the specified cell.
     - parameter view:           The view to be used to position within the collection view and that may be prepared before being displayed.
     - parameter indexPath:      The index path at which the cell is about to be positioned within the specified collection view.
     */
    @objc optional func collectionView(_ collectionView: UICollectionView, prepareDecorativeView view: UICollectionReusableView,
                                       atIndexPath indexPath: IndexPath)

    /**
     Asks your data source object whether the specified item can be moved to another location in the collection view.

     - parameter collectionView: The collection view requesting this information.
     - parameter indexPath:      The index path of the item that the collection view is trying to move.

     - returns: `true` if the item is allowed to move or `false` if it is not.
     */
    @objc optional func collectionView(_ collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: IndexPath) -> Bool

    /**
     Tells your data source object to move the specified item to its new location.

     When interactions with an item end, the collection view calls this method if the position of the item changed.
     Use this method to update your data structures with the new index path information.

     - parameter collectionView:       The collection view notifying you of the move.
     - parameter sourceIndexPath:      The item’s original index path.
     - parameter destinationIndexPath: The new index path of the item.
     */
    @objc optional func collectionView(_ collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: IndexPath,
                                       toIndexPath destinationIndexPath: IndexPath)
}
