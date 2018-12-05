import XCTest
import ModelDataSource

final class ModelCollectionDeprecatedTests: XCTestCase {

    private var tableViewTesting: ModelCollectionDeprecatedTesting<TableViewDataSource> {
        let tableViewTesting = ModelCollectionDeprecatedTesting<TableViewDataSource>()
        tableViewTesting.createItem = { .init(model: $0, cell: TestTableViewCell.self) }
        tableViewTesting.itemClass = TestTableViewCell.self
        tableViewTesting.searchItemClass = TestSearchTableViewCell.self
        tableViewTesting.createSearchItem = { .init(model: $0, cell: TestSearchTableViewCell.self) }
        tableViewTesting.createDecorative = { .init(model: $0, view: TestTableViewDecorativeView.self) }
        tableViewTesting.decorativeKinds = { [.header, .footer] }
        return tableViewTesting
    }

    private var collectionViewTesting: ModelCollectionDeprecatedTesting<CollectionViewDataSource> {
        let collectionViewTesting = ModelCollectionDeprecatedTesting<CollectionViewDataSource>()
        collectionViewTesting.createItem = { .init(model: $0, cell: TestCollectionViewCell.self) }
        collectionViewTesting.itemClass = TestCollectionViewCell.self
        collectionViewTesting.searchItemClass = TestSearchCollectionViewCell.self
        collectionViewTesting.createSearchItem = { .init(model: $0, cell: TestSearchCollectionViewCell.self) }
        collectionViewTesting.createDecorative = { .init(model: $0, view: TestCollectionViewDecorativeView.self) }
        collectionViewTesting.decorativeKinds = { [.header, .footer] }
        return collectionViewTesting
    }

    // MARK: Deprecated Tests

    func testEmptySection() {
        tableViewTesting.testEmptySection()
        collectionViewTesting.testEmptySection()
    }

    func testCountInSection() {
        tableViewTesting.testCountInSection()
        collectionViewTesting.testCountInSection()
    }

    func testAppendEmptySection() {
        tableViewTesting.testAppendEmptySection()
        collectionViewTesting.testAppendEmptySection()
    }

    func testAppendSectionWithDecorative() {
        tableViewTesting.testAppendSectionWithDecorative("TableViewDecorative", view: TestTableViewDecorativeView.self)
        collectionViewTesting.testAppendSectionWithDecorative("CollectionViewDecorative", view: TestCollectionViewDecorativeView.self)
    }

    func testAppendDecorative() {
        tableViewTesting.testAppendDecorative("TableViewDecorative", view: TestTableViewDecorativeView.self)
        collectionViewTesting.testAppendDecorative("CollectionViewDecorative", view: TestCollectionViewDecorativeView.self)
    }

    func testAppendItem() {
        tableViewTesting.testAppendItem("TableViewItem", cell: TestTableViewCell.self)
        collectionViewTesting.testAppendItem("CollectionViewItem", cell: TestCollectionViewCell.self)
    }

    func testAppendContentsOfItems() {
        let items = ["item0", "item1", "item2"]
        tableViewTesting.testAppendContentsOfItems(items, cell: TestTableViewCell.self)
        collectionViewTesting.testAppendContentsOfItems(items, cell: TestCollectionViewCell.self)
    }

    func testInsertItemAtIndexPath() {
        tableViewTesting.testInsertItemAtIndexPath("searchItem", insertCell: TestSearchTableViewCell.self)
        collectionViewTesting.testInsertItemAtIndexPath("searchItem", insertCell: TestSearchCollectionViewCell.self)
    }

    func testRemoveAtIndexPath() {
        tableViewTesting.testRemoveAtIndexPath()
        collectionViewTesting.testRemoveAtIndexPath()
    }

    func testRemoveAtIndexPaths() {
        tableViewTesting.testRemoveAtIndexPaths()
        collectionViewTesting.testRemoveAtIndexPaths()
    }

    func testRemoveAtIndices() {
        tableViewTesting.testRemoveAtIndices()
        collectionViewTesting.testRemoveAtIndices()
    }

}

private class ModelCollectionDeprecatedTesting<C: ModelCollection> {

    var createItem: ((String) -> ModelItem<C.DataSourceView>)?
    var createSearchItem: ((String) -> ModelItem<C.DataSourceView>)?
    var createDecorative: ((String) -> ModelDecorative<C.DataSourceView>)?
    var decorativeKinds: (() -> [C.DataSourceView.DecorativeKind])?

    var searchItemClass: C.DataSourceView.Cell.Type?
    var itemClass: C.DataSourceView.Cell.Type?

    init() {}

    var collectionName: String {
        return String(describing: C.self)
    }

    func testEmptySection() {
        var collection: C = .init(repeating: .init(), count: 1)

        XCTAssertTrue(collection.isEmptySection(0), "\(collectionName) failed to validate count in section.")
        XCTAssertEqual(collection[0].isEmpty, collection.isEmptySection(0), "\(collectionName) failed to validate count in section.")

        guard let item = createItem?("first item") else {
            return XCTFail("\(collectionName) failed to create item") }

        collection[0].append(item)

        XCTAssertFalse(collection.isEmptySection(0), "\(collectionName) failed to validate count in section.")
        XCTAssertEqual(collection[0].isEmpty, collection.isEmptySection(0), "\(collectionName) failed to validate count in section.")
    }

    func testCountInSection() {

        guard let item = createItem?("Item") else {
            return XCTFail("\(collectionName) failed to create item") }

        var collection: C = .init()

        collection.append(.init(repeating: item, count: 5))
        collection.append(.init())
        collection.append(.init(repeating: item, count: 2))

        XCTAssertEqual(collection[0].count, collection.countInSection(0), "\(collectionName) failed to validate count in section \(0).")
        XCTAssertEqual(collection[1].count, collection.countInSection(1), "\(collectionName) failed to validate count in section \(1).")
        XCTAssertEqual(collection[2].count, collection.countInSection(2), "\(collectionName) failed to validate count in section \(2).")
    }

    func testAppendEmptySection() {
        var collection: C = .init()
        XCTAssertEqual(0, collection.appendSection(), "\(collectionName) failed to append empty in section.")
        XCTAssertEqual(1, collection.count, "\(collectionName) failed to append empty in section.")
        XCTAssertEqual(1, collection.appendSection(), "\(collectionName) failed to append empty in section.")
        XCTAssertEqual(2, collection.count, "\(collectionName) failed to append empty in section.")
    }

    func testAppendSectionWithDecorative<M, D: ModelDataSourceViewDisplayable>(_ model: M, view: D.Type)
        where M == D.Model, D.Size == C.DataSourceView.Dimension {

        guard let decorativeKind = decorativeKinds?().first,  let modelDecorative = createDecorative?("Decorative") else {
            return XCTFail("\(collectionName) failed to create decoratives.")
        }

        var collection: C = .init()
        var deprecatedCollection: C = .init()
        XCTAssert(collection.isEmpty, "\(collectionName) is not empty.")
        XCTAssert(deprecatedCollection.isEmpty, "Deprecated \(collectionName) is not empty.")

        let indexIndex = collection.append(section: ModelSection<C.DataSourceView>.init(decorative: modelDecorative, kind: decorativeKind))
        let deprecatedIndex = deprecatedCollection.appendSection(model, view: view, ofKind: decorativeKind)

        XCTAssertFalse(collection.isEmpty, "\(collectionName) failed to append section with decorative.")
        XCTAssertFalse(deprecatedCollection.isEmpty, "Deprecated \(collectionName) failed to append section with decorative.")
        XCTAssertEqual(indexIndex, deprecatedIndex, "\(collectionName) failed to append section with decorative.")
        XCTAssertNotNil(collection.first?[decorativeKind], "\(collectionName) failed to create decorative.")
        XCTAssertNotNil(deprecatedCollection.first?[decorativeKind], "Deprecated \(collectionName) failed to create decorative.")
    }

    func testAppendDecorative<M, D: ModelDataSourceViewDisplayable>(_ model: M, view: D.Type) where M == D.Model, D.Size == C.DataSourceView.Dimension {

        guard let decorativeKind = decorativeKinds?().first,  let modelDecorative = createDecorative?("Decorative") else {
            return XCTFail("\(collectionName) failed to create decoratives.")
        }

        var collection: C = .init()
        var deprecatedCollection: C = .init()
        XCTAssert(collection.isEmpty, "\(collectionName) is not empty.")
        XCTAssert(deprecatedCollection.isEmpty, "Deprecated \(collectionName) is not empty.")

        // Creates new section if nil is passed
        let createdIndex = collection.append(decorative: modelDecorative, ofKind: decorativeKind, inSection: nil)
        let deprecatedCreatedIndex = deprecatedCollection.append(model, view: view, ofKind: decorativeKind, inSection: nil)

        XCTAssertFalse(collection.isEmpty, "\(collectionName) failed to append section with decorative.")
        XCTAssertFalse(deprecatedCollection.isEmpty, "Deprecated \(collectionName) failed to append section with decorative.")
        XCTAssertEqual(createdIndex, deprecatedCreatedIndex, "\(collectionName) failed to append section with decorative.")
        XCTAssertNotNil(collection[0, decorativeKind], "\(collectionName) failed to create decorative.")
        XCTAssertNotNil(deprecatedCollection[0, decorativeKind], "Deprecated \(collectionName) failed to create decorative.")

        collection.appendSection()
        deprecatedCollection.appendSection()

        XCTAssertNil(collection[1, decorativeKind])
        XCTAssertNil(deprecatedCollection[1, decorativeKind])

        // Append decorative to exisiting section
        let index = collection.append(decorative: modelDecorative, ofKind: decorativeKind, inSection: 1)
        let deprecatedIndex = deprecatedCollection.append(model, view: view, ofKind: decorativeKind, inSection: 1)

        XCTAssertEqual(index, deprecatedIndex, "\(collectionName) failed to append section with item. Indices must be equal to new API.")
        XCTAssertNotNil(collection[1, decorativeKind], "\(collectionName) failed to create decorative.")
        XCTAssertNotNil(deprecatedCollection[1, decorativeKind], "Deprecated \(collectionName) failed to create decorative.")
    }

    func testAppendItem<M, Cell: ModelDataSourceViewDisplayable>(_ model: M, cell: Cell.Type)
        where Cell.Model == M, Cell.Size == C.DataSourceView.Dimension {

        guard let modelItem = createItem?("Item") else {
            return XCTFail("\(collectionName) failed to create item.")
        }

        var collection: C = .init()
        var deprecatedCollection: C = .init()
        XCTAssert(collection.isEmpty, "\(collectionName) is not empty.")
        XCTAssert(deprecatedCollection.isEmpty, "Deprecated \(collectionName) is not empty.")

        // Creates new section if nil is passed
        let createdIndex = collection.append(item: modelItem, inSection: nil)
        let deprecatedCreatedIndex = deprecatedCollection.append(model, cell: cell, inSection: nil)

        XCTAssertFalse(collection.isEmpty, "\(collectionName) failed to append section with item.")
        XCTAssertFalse(deprecatedCollection.isEmpty, "Deprecated \(collectionName) failed to append section with item.")
        XCTAssertEqual(createdIndex, deprecatedCreatedIndex, "\(collectionName) failed to append section with item. Indices must be equal to new API.")
        XCTAssertFalse(collection[0].isEmpty, "\(collectionName) failed to create item.")
        XCTAssertFalse(deprecatedCollection[0].isEmpty, "Deprecated \(collectionName) failed to create item.")

        collection.appendSection()
        deprecatedCollection.appendSection()

        XCTAssertTrue(collection[1].isEmpty)
        XCTAssertTrue(deprecatedCollection[1].isEmpty)

        // Append item to exisiting section
        let index = collection.append(item: modelItem, inSection: 1)
        let deprecatedIndex = deprecatedCollection.append(model, cell: cell, inSection: 1)

        XCTAssertEqual(index, deprecatedIndex, "\(collectionName) failed to append section with item. Indices must be equal to new API.")
        XCTAssertFalse(collection[1].isEmpty, "\(collectionName) failed to create item.")
        XCTAssertFalse(deprecatedCollection[1].isEmpty, "Deprecated \(collectionName) failed to create item.")
    }

    func testAppendContentsOfItems<M, Cell: ModelDataSourceViewDisplayable>(_ models: [M], cell: Cell.Type)
        where Cell.Model == M, Cell.Size == C.DataSourceView.Dimension {

        var collection: C = .init()
        var deprecatedCollection: C = .init()
        XCTAssert(collection.isEmpty, "\(collectionName) is not empty.")
        XCTAssert(deprecatedCollection.isEmpty, "Deprecated \(collectionName) is not empty.")

        // Creates new section if nil is passed
        let createdIndexPaths = collection.append(contentsOf: models, cell: cell, inSection: nil)
        let deprecatedCreatedIndexPaths = deprecatedCollection.appendContentsOf(models, cell: cell, inSection: nil)

        XCTAssertFalse(collection.isEmpty, "\(collectionName) failed to append section with items.")
        XCTAssertFalse(deprecatedCollection.isEmpty, "Deprecated \(collectionName) failed to append section with items.")
        XCTAssertEqual(createdIndexPaths, deprecatedCreatedIndexPaths, "\(collectionName) failed to append section with items. Indices must be equal to new API.")
        XCTAssertTrue(collection[0].count == models.count, "\(collectionName) failed to create items.")
        XCTAssertTrue(deprecatedCollection[0].count == models.count, "Deprecated \(collectionName) failed to create items.")

        collection.appendSection()
        deprecatedCollection.appendSection()

        XCTAssertTrue(collection[1].isEmpty)
        XCTAssertTrue(deprecatedCollection[1].isEmpty)

        // Append item to exisiting section
        let indexPaths = collection.append(contentsOf: models, cell: cell, inSection: nil)
        let deprecatedIndexPaths = deprecatedCollection.appendContentsOf(models, cell: cell, inSection: nil)

        XCTAssertEqual(indexPaths, deprecatedIndexPaths, "\(collectionName) failed to append section with item. Indices must be equal to new API.")
        XCTAssertTrue(collection[1].count == models.count, "\(collectionName) failed to create items.")
        XCTAssertTrue(deprecatedCollection[1].count == models.count, "Deprecated \(collectionName) failed to create items.")
    }

    func testInsertItemAtIndexPath<M, Cell: ModelDataSourceViewDisplayable>(_ model: M, insertCell: Cell.Type)
        where Cell.Model == M, Cell.Size == C.DataSourceView.Dimension {

        guard let modelItem = createItem?("Item"), let searchItem = createSearchItem?("searchItem"),
            let searchClass = searchItemClass else {
            return XCTFail("\(collectionName) failed to create items.")
        }

        let initialCount = 3

        var collection: C = C([ModelSection<C.DataSourceView>.init(repeatElement(modelItem, count: initialCount))])
        var deprecatedCollection: C = C([ModelSection<C.DataSourceView>.init(repeatElement(modelItem, count: initialCount))])
        XCTAssert(!collection.isEmpty && collection[0].count == initialCount, "\(collectionName) is empty.")
        XCTAssert(!deprecatedCollection.isEmpty && deprecatedCollection[0].count == initialCount, "Deprecated \(collectionName) is empty.")

        let insertionPath = IndexPath(row: 1, section: 0)
        collection.insert(item: searchItem, indexPath: insertionPath)
        deprecatedCollection.insert(model, cell: insertCell, index: insertionPath)

        let indexPaths = collection.find(searchClass)
        XCTAssertTrue(indexPaths.count == 1, "\(collectionName) failed to insert item")
        XCTAssertTrue(indexPaths[0] == insertionPath, "\(collectionName) failed to insert item")

        let deprecatedIndexPaths = deprecatedCollection.find(searchClass)
        XCTAssertTrue(deprecatedIndexPaths.count == 1, "\(collectionName) failed to insert item")
        XCTAssertTrue(deprecatedIndexPaths[0] == insertionPath, "\(collectionName) failed to insert item")
    }

    func testRemoveAtIndexPath() {

        guard let modelItem = createItem?("Item"), let searchItem = createSearchItem?("searchItem"),
            let searchClass = searchItemClass else {
            return XCTFail("\(collectionName) failed to create items.")
        }

        let initialCount = 3

        var collection: C = C([ModelSection<C.DataSourceView>.init(repeatElement(modelItem, count: initialCount))])
        var deprecatedCollection: C = C([ModelSection<C.DataSourceView>.init(repeatElement(modelItem, count: initialCount))])
        XCTAssert(!collection.isEmpty && collection[0].count == initialCount, "\(collectionName) is empty.")
        XCTAssert(!deprecatedCollection.isEmpty && deprecatedCollection[0].count == initialCount, "Deprecated \(collectionName) is empty.")

        let removeIndexPath = IndexPath(row: 1, section: 0)

        // Replace model at index path to check if worked
        collection[removeIndexPath] = searchItem
        deprecatedCollection[removeIndexPath] = searchItem

        let removedModelItem = collection.remove(at: removeIndexPath)
        let deprecatedRemovedModelItem = deprecatedCollection.removeAtIndex(removeIndexPath)

        XCTAssertTrue(collection[0].count == initialCount - 1, "\(collectionName) unable to remove model at index path.")
        XCTAssertTrue(collection.find(searchClass).count == 0, "\(collectionName) unable to remove model at index path.")
        XCTAssertTrue(removedModelItem.cell == searchClass, "\(collectionName) unable to remove model at index path.")

        XCTAssertTrue(deprecatedCollection[0].count == initialCount - 1, "\(collectionName) unable to remove model at index path.")
        XCTAssertTrue(deprecatedCollection.find(searchClass).count == 0, "\(collectionName) unable to remove model at index path.")
        XCTAssertTrue(deprecatedRemovedModelItem.cell == searchClass, "\(collectionName) unable to remove model at index path.")

    }

    func testRemoveAtIndexPaths() {

        guard let modelItem = createItem?("Item"), let searchItem = createSearchItem?("searchItem"),
            let searchClass = searchItemClass else {
                return XCTFail("\(collectionName) failed to create items.")
        }

        let initialCount = 5

        var collection: C = C([ModelSection<C.DataSourceView>.init(repeatElement(modelItem, count: initialCount))])
        var deprecatedCollection: C = C([ModelSection<C.DataSourceView>.init(repeatElement(modelItem, count: initialCount))])
        XCTAssert(!collection.isEmpty && collection[0].count == initialCount, "\(collectionName) is empty.")
        XCTAssert(!deprecatedCollection.isEmpty && deprecatedCollection[0].count == initialCount, "Deprecated \(collectionName) is empty.")

        let removeIndexPaths = [IndexPath(row: 1, section: 0), IndexPath(row: 3, section: 0)]

        // Replace model at index path to check if remove worked
        removeIndexPaths.forEach { collection[$0] = searchItem }
        removeIndexPaths.forEach { deprecatedCollection[$0] = searchItem }

        XCTAssertTrue(collection.find(searchClass).count == removeIndexPaths.count, "\(collectionName) unable to insert model at index path.")
        XCTAssertTrue(deprecatedCollection.find(searchClass).count == removeIndexPaths.count, "\(collectionName) unable to insert model at index path.")

        let removedModelItems = collection.remove(at: Set(removeIndexPaths))
        let deprecatedRemovedModelItems = deprecatedCollection.removeAtIndex(removeIndexPaths)

        XCTAssertTrue(collection.find(searchClass).count == 0, "\(collectionName) unable to remove model at index path.")
        XCTAssertTrue(deprecatedCollection.find(searchClass).count == 0, "\(collectionName) unable to remove model at index path.")
        XCTAssertTrue(removedModelItems.count == removeIndexPaths.count, "\(collectionName) unable to remove model at index path.")
        XCTAssertTrue(deprecatedRemovedModelItems.count == removeIndexPaths.count, "\(collectionName) unable to remove model at index path.")
    }

    func testRemoveAtIndices() {

        let initialCount = 5

        var collection: C = C(repeatElement(.init(), count: initialCount))
        var deprecatedCollection: C = C(repeatElement(.init(), count: initialCount))
        XCTAssertFalse(collection.isEmpty, "\(collectionName) is empty.")
        XCTAssertFalse(deprecatedCollection.isEmpty, "Deprecated \(collectionName) is empty.")

        let removeIndices = [3, 0, 2]
        let removedSections = collection.remove(at: Set(removeIndices))
        let removedDeprecated = deprecatedCollection.removeAtIndex(removeIndices)

        XCTAssertTrue(removedSections.count == removeIndices.count)
        XCTAssertTrue(collection.count == initialCount - removeIndices.count)

        XCTAssertTrue(removedDeprecated.count == removeIndices.count)
        XCTAssertTrue(deprecatedCollection.count == initialCount - removeIndices.count)
    }

}

