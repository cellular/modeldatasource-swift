import UIKit

open class CollectionViewDataSource: NSObject, ModelCollection {

    // MARK: ModelCollection
    public typealias DataSourceView = UICollectionView
    // swiftlint:disable syntactic_sugar
    public typealias Buffer = Array<ModelSection<UICollectionView>>
    // swiftlint:enable syntactic_sugar
    public var buffer: Buffer

    open weak var delegate: CollectionViewDataSourceDelegate?

    required override public init() {
        buffer = []
        super.init()
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
