import XCTest

final class ModelDataSourceViewTests: XCTestCase {

    // MARK: UITableView + ModelDataSourceView

    func testTableViewRegisterCell() {
        let tableView = UITableView()
        tableView.register(TestTableViewCell.self)
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: TestTableViewCell.reuseIdentifier)
        XCTAssertTrue(dequeuedCell is TestTableViewCell)
    }

    func testTableViewRegisterDecorative() {
        let tableView = UITableView()
        tableView.register(TestTableViewDecorativeView.self)
        let dequeuedView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TestTableViewDecorativeView.reuseIdentifier)
        XCTAssertTrue(dequeuedView is TestTableViewDecorativeView)
    }

    func testCollectionViewRegisterCell() {
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: .init())
        collectionView.register(TestCollectionViewCell.self)
        collectionView.dequeueReusableCell(withReuseIdentifier: TestCollectionViewCell.reuseIdentifier, for: IndexPath())
        XCTAssert(true, "Collection view dequeued cell successfully.")
    }

    func testCollectionViewRegisterDecorative() {
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: .init())
        collectionView.register(TestCollectionViewDecorativeView.self, as: .footer)
        collectionView.register(TestCollectionViewDecorativeView.self, as: .header)
        collectionView.dequeueReusableSupplementaryView(ofKind: String(describing: UICollectionView.DecorativeKind.footer),
                                                        withReuseIdentifier: TestCollectionViewDecorativeView.reuseIdentifier,
                                                        for: IndexPath())
        collectionView.dequeueReusableSupplementaryView(ofKind: String(describing: UICollectionView.DecorativeKind.header),
                                                        withReuseIdentifier: TestCollectionViewDecorativeView.reuseIdentifier,
                                                        for: IndexPath())
        XCTAssert(true, "Collection view dequeued header / footer successfully")
    }
}


