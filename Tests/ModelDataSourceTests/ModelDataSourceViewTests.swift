import XCTest
import ModelDataSource

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
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TestCollectionViewCell.self)

        var dataSource: CollectionViewDataSource = .init()
        collectionView.dataSource = dataSource

        let indexPath = dataSource.append(item: .init(model: "Test", cell: TestCollectionViewCell.self))

        collectionView.reloadData()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dataSource[indexPath].reuseIdentifier, for: indexPath)

        XCTAssert(cell is TestCollectionViewCell, "Collection view dequeued cell successfully.")
    }

    func testCollectionViewRegisterDecorative() {

        let collectionView = UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: 200.0, height: 500.0),
                                             collectionViewLayout: CollectionLayout.init(width: 200.0))

        collectionView.register(TestCollectionViewDecorativeView.self, as: .header)
        collectionView.register(TestCollectionViewDecorativeView.self, as: .footer)
        collectionView.register(TestCollectionViewCell.self)

        var dataSource: CollectionViewDataSource = .init()
        collectionView.dataSource = dataSource

        let header: ModelDecorative<UICollectionView> = .init(model: "Header", view: TestCollectionViewDecorativeView.self)
        let footer: ModelDecorative<UICollectionView> = .init(model: "Footer", view: TestCollectionViewDecorativeView.self)

        let sectionIndex = dataSource.append(section: ModelSection.init(decoratives: [.header: header, .footer: footer],
                                            items: []))

        collectionView.reloadData()

        let headerReuseIdentifier = dataSource[sectionIndex, .header]?.reuseIdentifier ?? ""
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: String(describing: UICollectionView.DecorativeKind.header),
                                                                      withReuseIdentifier: headerReuseIdentifier,
                                                                      for: IndexPath())

        let footerReuseIdentifier = dataSource[sectionIndex, .footer]?.reuseIdentifier ?? ""
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: String(describing: UICollectionView.DecorativeKind.footer),
                                                                      withReuseIdentifier: footerReuseIdentifier,
                                                                      for: IndexPath())

        XCTAssertTrue(headerView is TestCollectionViewDecorativeView, "Collection view dequeued header successfully")
        XCTAssertTrue(footerView is TestCollectionViewDecorativeView, "Collection view dequeued footer successfully")
    }
}

// Custom Layout. Some properties / functions are requiered to dequeue supplementary views for iOS versions < iOS12.
private final class CollectionLayout: UICollectionViewFlowLayout {

    init(width: CGFloat) {
        super.init()
        itemSize = .init(width: 50.0, height: 50.0)
        sectionInset = .init(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        footerReferenceSize = .init(width: width, height: 100.0)
        headerReferenceSize = .init(width: width, height: 100.0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return .init()
    }
}


