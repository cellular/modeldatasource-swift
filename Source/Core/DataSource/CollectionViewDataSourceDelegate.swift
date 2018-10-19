import Foundation

@objc public protocol CollectionViewDataSourceDelegate: NSObjectProtocol {

    /// Forwards each cell within the data source to the delegate before displaying it in a particular location of the collection view.
    ///
    /// - Parameters:
    ///   - collectionView: The collection-view object that is about to present the specified cell.
    ///   - cell: The cell to be used to position within the collection view and that may be prepared before being displayed.
    ///   - indexPath: The index path at which the cell is about to be positioned within the specified collection view.
    @objc optional func collectionView(_ collectionView: UICollectionView, prepareModelCell cell: UICollectionViewCell,
                                       atIndexPath indexPath: IndexPath)

    /// Forwards each decorative within the data source to the delegate before displaying it
    /// in a particular location of the collection view.
    ///
    /// - Parameters:
    ///   - collectionView: The collection-view object that is about to present the specified cell.
    ///   - view: The view to be used to position within the collection view and that may be prepared before being displayed.
    ///   - indexPath: The index path at which the cell is about to be positioned within the specified collection view.
    @objc optional func collectionView(_ collectionView: UICollectionView, prepareDecorativeView view: UICollectionReusableView,
                                       atIndexPath indexPath: IndexPath)

    /// Asks your data source object whether the specified item can be moved to another location in the collection view.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - indexPath: The index path of the item that the collection view is trying to move.
    /// - Returns: `true` if the item is allowed to move or `false` if it is not.
    @objc optional func collectionView(_ collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: IndexPath) -> Bool

    /// Tells your data source object to move the specified item to its new location.
    ///
    /// When interactions with an item end, the collection view calls this method if the position of the item changed.
    /// Use this method to update your data structures with the new index path information.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view notifying you of the move.
    ///   - sourceIndexPath: The item’s original index path.
    ///   - destinationIndexPath: The new index path of the item.
    @objc optional func collectionView(_ collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: IndexPath,
                                       toIndexPath destinationIndexPath: IndexPath)
}
