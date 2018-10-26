import XCTest
@testable import ModelDataSource

final class ModelCollectionTests: XCTestCase {

    private var tableViewTesting: ModelCollectionTesting<TableViewDataSource> {
        let tableViewTesting = ModelCollectionTesting<TableViewDataSource>()
        tableViewTesting.createItem = { .init(model: $0, cell: TestTableViewCell.self) }
        return tableViewTesting
    }

    private var collectionViewTesting: ModelCollectionTesting<CollectionViewDataSource> {
        let collectionViewTesting = ModelCollectionTesting<CollectionViewDataSource>()
        collectionViewTesting.createItem = { .init(model: $0, cell: TestCollectionViewCell.self) }
        return collectionViewTesting
    }

    func testInit() {
        tableViewTesting.testEmptyInit()
        collectionViewTesting.testEmptyInit()
    }

    func testIndex() {
        tableViewTesting.testIndex()
        collectionViewTesting.testIndex()
    }

    func testIndexSubscript() {
        tableViewTesting.testIndexSubscript()
        collectionViewTesting.testIndexSubscript()
    }

    func testIndexReplace() {
        tableViewTesting.testReplaceSubrang()
        collectionViewTesting.testReplaceSubrang()
    }
}


private class ModelCollectionTesting<C: ModelCollection>{


    var createItem: ((String) -> ModelItem<C.DataSourceView>)?

    init() {
    }

    /// MARK: Collection Conformance

    var collectionName: String {
        return String(describing: C.self)
    }

    func testEmptyInit() {
        XCTAssertTrue(C.init().isEmpty)
    }

    func testIndex() {
        var collection: C = .init()
        XCTAssertTrue(collection.startIndex == collection.endIndex)

        let section: ModelSection<C.DataSourceView> = .init()
        collection.append(section)

        XCTAssertFalse(collection.isEmpty)
        XCTAssertTrue(collection.startIndex == 0 && collection.endIndex == 1)
    }

    func testIndexSubscript() {

        var collection: C = .init()
        let initialModel = "Initial Model"
        guard let initialItem = createItem?(initialModel) else { return XCTFail("\(collectionName) failed to create item") }
        let initialItems = [initialItem]
        let section: ModelSection<C.DataSourceView> = .init(decoratives: [:], items: initialItems)
        collection.append(section)
        XCTAssertEqual(collection[0].first?.model as? String, initialModel)

        let replaceModel = "Replace Model"
        guard let replaceItem = createItem?(replaceModel) else { return XCTFail("\(collectionName) failed to create item") }
        let replaceItems = [replaceItem]
        collection[0] = .init(decoratives: [:], items: replaceItems)
        XCTAssertEqual(collection[0].first?.model as? String, replaceModel)
    }

    func testReplaceSubrang() {

        let initialModel = "initial"
        let replacedModel = "replaced"

        guard let initialItem = createItem?(initialModel), let replacedItem = createItem?(replacedModel) else {
            return XCTFail("\(collectionName) failed to create items")
        }

        let initialSection: ModelSection<C.DataSourceView> = .init(decoratives: [:], items: [initialItem])
        let replacedSection: ModelSection<C.DataSourceView> = .init(decoratives: [:], items: [replacedItem])

        let initialCount = 10
        var collection: C = .init(repeating: initialSection, count: initialCount)

        // Repalce subrange
        let replaceRange = 4...7

        let newElements: [ModelSection<C.DataSourceView>] = .init(repeating: replacedSection, count: replaceRange.count)
        collection.replaceSubrange(replaceRange, with: newElements)

        collection.enumerated().forEach { offset, element in
            if replaceRange.contains(offset) {
                XCTAssertEqual(element[0].model as? String, replacedModel)
            } else {
                XCTAssertEqual(element[0].model as? String, initialModel)
            }
        }
    }
}
