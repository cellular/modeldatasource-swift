import XCTest
@testable import ModelDataSource

final class ModelCollectionTests: XCTestCase {

    private var tableViewTesting: ModelCollectionTesting<TableViewDataSource> {
        let tableViewTesting = ModelCollectionTesting<TableViewDataSource>()
        tableViewTesting.createItem = { .init(model: $0, cell: TestTableViewCell.self) }
        tableViewTesting.createDecorative = { .init(model: $0, view: TestTableViewDecorativeView.self) }
        tableViewTesting.decorativeKinds = { [.header, .footer] }
        return tableViewTesting
    }

    private var collectionViewTesting: ModelCollectionTesting<CollectionViewDataSource> {
        let collectionViewTesting = ModelCollectionTesting<CollectionViewDataSource>()
        collectionViewTesting.createItem = { .init(model: $0, cell: TestCollectionViewCell.self) }
        collectionViewTesting.createDecorative = { .init(model: $0, view: TestCollectionViewDecorativeView.self) }
        collectionViewTesting.decorativeKinds = { [.header, .footer] }
        return collectionViewTesting
    }

    // MARK: Conformance

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

    func testReplaceSubrang() {
        tableViewTesting.testReplaceSubrange()
        collectionViewTesting.testReplaceSubrange()
    }

    // MARK: Convenience

    func testIndexPathSubscript() {
        tableViewTesting.testIndexPathSubscript()
        collectionViewTesting.testIndexPathSubscript()
    }

    func testSubscriptDecorative() {
        tableViewTesting.testSubscriptDecorative()
        collectionViewTesting.testSubscriptDecorative()
    }

}

// MARK: Helper

private class ModelCollectionTesting<C: ModelCollection>{

    var createItem: ((String) -> ModelItem<C.DataSourceView>)?
    var createDecorative: ((String) -> ModelDecorative<C.DataSourceView>)?
    var decorativeKinds: (() -> [C.DataSourceView.DecorativeKind])?

    init() {}

    /// MARK: Collection Conformance

    var collectionName: String {
        return String(describing: C.self)
    }

    func testEmptyInit() {
        XCTAssertTrue(C.init().isEmpty, "\(collectionName) has no valid empty initializer")
    }

    func testIndex() {
        var collection: C = .init()
        XCTAssertTrue(collection.startIndex == collection.endIndex, "\(collectionName) start and index incorrect")

        let section: ModelSection<C.DataSourceView> = .init()
        collection.append(section)

        XCTAssertFalse(collection.isEmpty, "\(collectionName) start and index incorrect")
        XCTAssertTrue(collection.startIndex == 0 && collection.endIndex == 1, "\(collectionName) start and index incorrect")
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
        XCTAssertEqual(collection[0].first?.model as? String, replaceModel, "\(collectionName) subscript failed")
    }

    func testReplaceSubrange() {

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
                XCTAssertEqual(element[0].model as? String, replacedModel, "\(collectionName) replace subrange failed")
            } else {
                XCTAssertEqual(element[0].model as? String, initialModel, "\(collectionName) replace subrange failed")
            }
        }
    }

    // MARK: Convenience

    func testIndexPathSubscript() {

        let initialModel = "initial"
        let replacedModel = "replaced"

        guard let initialItem = createItem?(initialModel), let replacedItem = createItem?(replacedModel) else {
            return XCTFail("\(collectionName) failed to create items")
        }

        let initialSection: ModelSection<C.DataSourceView> = .init(decoratives: [:], items: [initialItem, initialItem])
        var collection: C = .init(repeating: initialSection, count: 5)

        let replaceIndexPath = IndexPath(item: 1, section: 3)
        collection[replaceIndexPath] = replacedItem

        collection.enumerated().forEach { sectionIndex, section in
            section.enumerated().forEach { itemIndex, item in

                let currentIndexPath = IndexPath(item: itemIndex, section: sectionIndex)
                if currentIndexPath == replaceIndexPath {
                    XCTAssertEqual(collection[currentIndexPath].model as? String, replacedModel, "\(collectionName) subscript failed")

                } else {
                    XCTAssertEqual(collection[currentIndexPath].model as? String, initialModel, "\(collectionName) subscript failed")
                }
            }
        }
    }

    func testSubscriptDecorative() {

        let initialModel = "initial"
        let replacedModel = "replaced"

        guard let decorativeKinds = decorativeKinds?(), let replaceKind = decorativeKinds.first,
            let decorative = createDecorative?(replacedModel) else {

            return XCTFail("\(collectionName) failed to create decoratives")
        }

        guard let initialItem = createItem?(initialModel) else {
            return XCTFail("\(collectionName) failed to create items")
        }

        let initialSection: ModelSection<C.DataSourceView> = .init(decoratives: [:], items: [initialItem, initialItem])
        var collection: C = C.init(repeating: initialSection, count: 10)
        let replaceIndex = 5
        collection[replaceIndex, replaceKind] = decorative

        collection.enumerated().forEach { sectionIndex, section in
            decorativeKinds.forEach { decorativeKind in
                if replaceKind == decorativeKind && sectionIndex == replaceIndex {
                    XCTAssertNotNil(collection[sectionIndex, decorativeKind],
                                    "\(collectionName) failed to subscript decoratives with seciton")
                } else {
                    XCTAssertNil(collection[sectionIndex, decorativeKind],
                                 "\(collectionName) failed to subscript decoratives with seciton")
                }
            }
        }
    }

    
}
