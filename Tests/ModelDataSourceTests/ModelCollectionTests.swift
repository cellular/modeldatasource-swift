import XCTest
import ModelDataSource

final class ModelCollectionTests: XCTestCase {

    private var tableViewTesting: ModelCollectionTesting<TableViewDataSource> {
        let tableViewTesting = ModelCollectionTesting<TableViewDataSource>()
        tableViewTesting.createItem = { .init(model: $0, cell: TestTableViewCell.self) }
        tableViewTesting.itemClass = TestTableViewCell.self
        tableViewTesting.searchItemClass = TestSearchTableViewCell.self
        tableViewTesting.createSearchItem = { .init(model: $0, cell: TestSearchTableViewCell.self) }
        tableViewTesting.createDecorative = { .init(model: $0, view: TestTableViewDecorativeView.self) }
        tableViewTesting.decorativeKinds = { [.header, .footer] }
        tableViewTesting.capactiy = { $0.capacity }
        return tableViewTesting
    }

    private var collectionViewTesting: ModelCollectionTesting<CollectionViewDataSource> {
        let collectionViewTesting = ModelCollectionTesting<CollectionViewDataSource>()
        collectionViewTesting.createItem = { .init(model: $0, cell: TestCollectionViewCell.self) }
        collectionViewTesting.itemClass = TestCollectionViewCell.self
        collectionViewTesting.searchItemClass = TestSearchCollectionViewCell.self
        collectionViewTesting.createSearchItem = { .init(model: $0, cell: TestSearchCollectionViewCell.self) }
        collectionViewTesting.createDecorative = { .init(model: $0, view: TestCollectionViewDecorativeView.self) }
        collectionViewTesting.decorativeKinds = { [.header, .footer] }
        collectionViewTesting.capactiy = { $0.capacity }
        return collectionViewTesting
    }

    // MARK: ModelCollection Conformance

    func testInit() {
        tableViewTesting.testEmptyInit()
        collectionViewTesting.testEmptyInit()
    }

    func testIndex() {
        tableViewTesting.testIndex()
        collectionViewTesting.testIndex()
    }

    func testReplaceSubrange() {
        tableViewTesting.testReplaceSubrange()
        collectionViewTesting.testReplaceSubrange()
    }

    // MARK: Convenience

    func testIndexSubscript() {
        tableViewTesting.testIndexSubscript()
        collectionViewTesting.testIndexSubscript()
    }

    func testIndexPathSubscript() {
        tableViewTesting.testIndexPathSubscript()
        collectionViewTesting.testIndexPathSubscript()
    }

    func testSubscriptDecorative() {
        tableViewTesting.testSubscriptDecorative()
        collectionViewTesting.testSubscriptDecorative()
    }

    func testFind()  {
        tableViewTesting.testFind()
        collectionViewTesting.testFind()
    }

    func testIsLastCell() {
        tableViewTesting.testIsLastCell()
        collectionViewTesting.testIsLastCell()
    }

    func testIsLastSection() {
        tableViewTesting.testIsLastSection()
        collectionViewTesting.testIsLastSection()
    }

    func testAppendSection() {
        tableViewTesting.testAppendSection()
        collectionViewTesting.testIsLastSection()
    }

    func testAppendDecorative() {
        tableViewTesting.testAppendDecorative()
        collectionViewTesting.testAppendDecorative()
    }

    func testAppendItem() {
        tableViewTesting.testAppendItem()
        collectionViewTesting.testAppendItem()
    }

    func testAppendItemList() {
        tableViewTesting.testAppendItemList(cell: TestTableViewCell.self)
        collectionViewTesting.testAppendItemList(cell: TestCollectionViewCell.self)
    }

    func testInserItem() {
        tableViewTesting.testInserItem()
        collectionViewTesting.testInserItem()
    }

    func testRemoveAllInSection() {
        tableViewTesting.testRemoveAllInSection()
        collectionViewTesting.testRemoveAllInSection()
    }

    func testRemoveAllMatchingCell() {
        tableViewTesting.testRemoveAllMatchingCell()
        collectionViewTesting.testRemoveAllMatchingCell()
    }

    func testRemoveAtIndexPath() {
        tableViewTesting.testRemoveAtIndexPath()
        collectionViewTesting.testRemoveAtIndexPath()
    }

    func testRemoveAtIndexPaths() {
        tableViewTesting.testRemoveAtIndexPaths()
        collectionViewTesting.testRemoveAtIndexPaths()
    }

    func testRemoveIndices() {
        tableViewTesting.testRemoveIndices()
        collectionViewTesting.testRemoveIndices()
    }

    func testRemoveDecorative() {
        tableViewTesting.testRemoveDecorative()
        collectionViewTesting.testRemoveDecorative()
    }

    func testRemoveAllKeepingCapacity() {
        tableViewTesting.testRemoveAllKeepingCapacity()
        collectionViewTesting.testRemoveAllKeepingCapacity()
    }

    func testRemoveAllNotKeeingCapacity() {
        tableViewTesting.testRemoveAllNotKeeingCapacity()
        collectionViewTesting.testRemoveAllNotKeeingCapacity()
    }
}

// MARK: Helper

private class ModelCollectionTesting<C: ModelCollection> {

    var createItem: ((String) -> ModelItem<C.DataSourceView>)?
    var createSearchItem: ((String) -> ModelItem<C.DataSourceView>)?
    var createDecorative: ((String) -> ModelDecorative<C.DataSourceView>)?
    var decorativeKinds: (() -> [C.DataSourceView.DecorativeKind])?
    var searchItemClass: C.DataSourceView.Cell.Type?
    var itemClass: C.DataSourceView.Cell.Type?
    var capactiy: ((C) -> Int)?

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

    func testFind() {

        guard let item = createItem?("Test Model"), let searchItem = createSearchItem?("Search Model"),
            let searchItemClass = searchItemClass else {

            return XCTFail("\(collectionName) failed to create items")
        }

        let sections: ModelSection<C.DataSourceView>  = .init(repeating: item, count: 5)
        var collection: C = .init(repeating: sections, count: 5)

        let replaceIndices = [IndexPath(item: 0, section: 4), IndexPath(item: 2, section: 3), IndexPath(item: 1, section: 3)]
        replaceIndices.forEach { collection[$0] = searchItem }

        let found = collection.find(searchItemClass)
        XCTAssertEqual(Set(replaceIndices), Set(found))
    }

    func testIsLastCell() {

        guard let item = createItem?("Test Model") else {
            return XCTFail("\(collectionName) failed to create items")
        }

        let sections: ModelSection<C.DataSourceView>  = .init(repeating: item, count: 3)
        let collection: C = .init(repeating: sections, count: 3)

        collection.indices.forEach { section in
            guard section < collection.endIndex else { return }

            collection[section].indices.forEach { item in
                let lastItem = collection[section].endIndex - 1
                guard item <= lastItem else { return }

                let indexPath = IndexPath(item: item, section: section)
                item == lastItem ? XCTAssertTrue(collection.isLastCellInSection(indexPath))
                                 : XCTAssertFalse(collection.isLastCellInSection(indexPath))
            }
        }
    }

    func testIsLastSection() {

        let sections: ModelSection<C.DataSourceView>  = .init()
        let collection: C = .init(repeating: sections, count: 3)

        collection.indices.forEach { section  in
            guard section < collection.endIndex else { return }
            section == collection.endIndex - 1 ? XCTAssertTrue(collection.isLastSection(section))
                                               : XCTAssertFalse(collection.isLastSection(section))
        }
    }

    func testAppendSection() {
        var collection: C = .init()
        XCTAssertTrue(collection.endIndex == 0)
        XCTAssertTrue(collection.append(section: .init()) == collection.endIndex - 1)
    }

    func testAppendDecorative() {
        guard let decorativeKind = decorativeKinds?().first, let decorative = createDecorative?("Header") else {
            return XCTFail("\(collectionName) failed to create decoratives")
        }

        var collection: C = .init()

        // Append decorative without a specific section

        var createdSectionIndex = collection.append(decorative: decorative, ofKind: decorativeKind)
        // On empty collection append decorative creates a new empty section with the given decorative.
        XCTAssertTrue(createdSectionIndex ==  0, "\(collectionName) failed to append decorative")
        XCTAssertFalse(collection.isEmpty, "\(collectionName) failed to append decorative")
        XCTAssertNotNil(collection[0, decorativeKind], "\(collectionName) failed to append decorative")

        // Replace first section with an empty section
        collection[0] = .init()
        XCTAssertNil(collection[0, decorativeKind], "\(collectionName) failed to remove decorative")
        createdSectionIndex = collection.append(decorative: decorative, ofKind: decorativeKind)

        // If collection is not empty, decorative will be added to the last section
        XCTAssertTrue(createdSectionIndex ==  0, "\(collectionName) failed to append decorative")
        XCTAssertNotNil(collection[0, decorativeKind], "\(collectionName) failed to append decorative")

        // Append decorative with to a specific section

        // Create collection with empty sections
        collection = .init(repeating: .init(), count: 5)
        collection.enumerated().forEach { sectionIndex, element in
            XCTAssertNil(collection[sectionIndex, decorativeKind], "\(collectionName) should be empty")
        }

        let sectionToAppend = 3
        createdSectionIndex = collection.append(decorative: decorative, ofKind: decorativeKind, inSection: sectionToAppend)
        XCTAssertTrue(createdSectionIndex == 3, "\(collectionName) unable to append decorative to a specific section")
        collection.enumerated().forEach { sectionIndex, element in
            if sectionIndex == sectionToAppend {
                XCTAssertNotNil(collection[sectionIndex, decorativeKind], "\(collectionName) failed to append decorative")
            } else {
                XCTAssertNil(collection[sectionIndex, decorativeKind], "\(collectionName) should be empty")
            }
        }
    }

    func testAppendItem() {
        guard let item = createItem?("Test Model") else {  return XCTFail("\(collectionName) failed to create item") }

        var collection: C = .init()
        var createdSectionIndex = collection.append(item: item)

        // On empty collection append item creates a new empty section with the given item.
        XCTAssertTrue(createdSectionIndex.section ==  0 && createdSectionIndex.item ==  0, "\(collectionName) failed to append item")
        XCTAssertFalse(collection.isEmpty, "\(collectionName) failed to append item")
        XCTAssertTrue(collection[0].count == 1, "\(collectionName) failed to append item")

        // If a section exists, item will be appended to the last exisiting section.
        createdSectionIndex = collection.append(item: item)
        XCTAssertTrue(createdSectionIndex.section == 0 && createdSectionIndex.item ==  1, "\(collectionName) failed to append item")
        XCTAssertTrue(collection[0].count == 2, "\(collectionName) failed to append item")

        // Append item with to a specific section

        // Create collection with empty sections
        collection = .init(repeating: .init(), count: 5)
        collection.enumerated().forEach { sectionIndex, element in
            XCTAssertTrue(collection[sectionIndex].isEmpty, "\(collectionName) should be empty")
        }

        let sectionToAppend = 3
        createdSectionIndex = collection.append(item: item, inSection: sectionToAppend)
        XCTAssertTrue(createdSectionIndex.section == 3 && createdSectionIndex.item == 0,
                      "\(collectionName) unable to append decorative to a specific section")

        collection.enumerated().forEach { sectionIndex, element in
            if sectionIndex == sectionToAppend {
                XCTAssertFalse(element.isEmpty, "\(collectionName) unable to append item to specific section")
            } else {
                XCTAssertTrue(element.isEmpty, "\(collectionName) unable to append item to specific section")
            }
        }
    }

    func testAppendItemList<Cell: TestModelDataSourceViewDisplayable>(cell: Cell.Type) where Cell.Size == C.DataSourceView.Dimension {
        var collection: C = .init()
        let modelCount = 5
        let models: [Cell.Model] = .init(repeating: Cell.testModel, count: modelCount)
        collection.append(contentsOf:models, cell: cell, inSection: nil)
        XCTAssertFalse(collection.isEmpty, "\(collectionName) unable to append list of models")
        XCTAssertTrue(collection.count == 1 && collection[0].count == models.count)

        // Append to already existing section
        collection.append(contentsOf:models, cell: cell, inSection: 0)
        XCTAssertTrue(collection.count == 1 && collection[0].count == models.count * 2,
                      "\(collectionName) unable to append list of models to specific section")
    }

    func testInserItem() {
        let initialModel = "Initial Model"
        let insertedModel = "Inserted Model"

        guard let initialItem = createItem?(initialModel), let insertedItem = createItem?(insertedModel) else {
            return XCTFail("\(collectionName) failed to create items")
        }

        let initalSectionCount = 5
        let section: ModelSection<C.DataSourceView> = .init(repeating: initialItem, count: initalSectionCount)
        var collection: C = .init(repeating: section, count: 3)

        let insertIndexPath = IndexPath(item: 2, section: 2)
        collection.insert(item: insertedItem, indexPath: insertIndexPath)

        collection.enumerated().forEach { sectionIndex, section in

            insertIndexPath.section == sectionIndex ? XCTAssertTrue(section.count == initalSectionCount + 1)
                                                    : XCTAssertTrue(section.count == initalSectionCount)

            section.enumerated().forEach { itemIndex, item in
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                let failureMessage = "\(collectionName) failed to insert item"
                if indexPath == insertIndexPath {
                    XCTAssertEqual(collection[indexPath].model as? String, insertedModel, failureMessage)
                } else {
                    XCTAssertEqual(collection[indexPath].model as? String, initialModel, failureMessage)
                }
            }
        }
    }

    func testRemoveAllInSection() {

        guard let initialItem = createItem?("Initial Model") else {
            return XCTFail("\(collectionName) failed to create items")
        }

        let initalItemCount = 5
        let section: ModelSection<C.DataSourceView> = .init(repeating: initialItem, count: initalItemCount)
        var collection: C = .init(repeating: section, count: 3)

        let removeIndex = 1
        collection.removeAll(inSection: removeIndex, keepingCapacity: true)
        collection.enumerated().forEach { sectionIndex, section in
            let failureMessage = "\(collectionName) failed to remove all from section"
            sectionIndex == removeIndex ? XCTAssertTrue(section.count == 0, failureMessage)
                                        : XCTAssertTrue(section.count == initalItemCount, failureMessage)
        }
    }

    func testRemoveAllMatchingCell() {
        guard let item = createItem?("Test Model"), let searchItem = createSearchItem?("Search Model"),
            let searchItemClass = searchItemClass else {

            return XCTFail("\(collectionName) failed to create items")
        }

        let initalItemCount = 5
        let section: ModelSection<C.DataSourceView> = .init(repeating: item, count: initalItemCount)
        var collection: C = .init(repeating: section, count: 3)

        let indexPaths: [IndexPath] = (0..<collection.endIndex).map { collection.append(item: searchItem, inSection: $0) }
        let removedIndexPaths = collection.removeAll(matching: searchItemClass)
        XCTAssertTrue(Set(indexPaths) == Set(removedIndexPaths), "\(collectionName) failed to remove items")
        XCTAssertTrue(collection.find(searchItemClass).count == 0, "\(collectionName) failed to remove items")
    }

    func testRemoveAtIndexPath() {
        let searchModel = "Search Model"

        guard let item = createItem?("Test Model"), let searchItem = createSearchItem?(searchModel),
            let searchItemClass = searchItemClass else {

                return XCTFail("\(collectionName) failed to create items")
        }

        let initalSectionCount = 5
        let section: ModelSection<C.DataSourceView> = .init(repeating: item, count: initalSectionCount)
        var collection: C = .init(repeating: section, count: 1)

        let insertIndexPath = IndexPath(item: 3, section: 0)
        collection.insert(item: searchItem, indexPath: insertIndexPath)
        XCTAssertTrue(initalSectionCount + 1 == collection[0].count, "\(collectionName) failed to insert item at index path")
        let removedItem = collection.remove(at: insertIndexPath)

        XCTAssertEqual(removedItem.model as? String, searchModel, "\(collectionName) failed to remove item at index path")
        XCTAssertTrue(collection.find(searchItemClass).count == 0, "\(collectionName) failed to remove items")
    }

    func testRemoveAtIndexPaths() {
        let searchModel = "Search Model"

        guard let item = createItem?("Test Model"), let searchItem = createSearchItem?(searchModel),
            let searchItemClass = searchItemClass else {

                return XCTFail("\(collectionName) failed to create items")
        }

        let initalSectionCount = 5
        let sectionCount = 2
        let section: ModelSection<C.DataSourceView> = .init(repeating: item, count: initalSectionCount)
        var collection: C = .init(repeating: section, count: sectionCount)

        let insertIndexPaths: [IndexPath] = [IndexPath(item: 3, section: 1),
                                                IndexPath(item: 1, section: 0),
                                                IndexPath(item: 2, section: 1)]

        insertIndexPaths.forEach { indexPath in collection.insert(item: searchItem, indexPath: indexPath) }
        // After insertion newly created indexPath might no be equal to insertedIndexPath, thus find inserted items
        let indexPathsToRemove = collection.find(searchItemClass)
        XCTAssertTrue(indexPathsToRemove.count == insertIndexPaths.count,
                      "\(collectionName) failed to insert item at index path")

        let removedItems = collection.remove(at: Set(indexPathsToRemove))
        removedItems.forEach { item in
            XCTAssertEqual(item.model as? String, searchModel, "\(collectionName) failed to remove item at index path")
        }
        XCTAssertTrue(collection.find(searchItemClass).count == 0, "\(collectionName) failed to remove items")
    }

    func testRemoveIndices() {
        let searchModel = "Search Model"
        guard let searchItem = createSearchItem?(searchModel), let searchItemClass = searchItemClass else {
            return XCTFail("\(collectionName) failed to create items")
        }

        let sectionCount = 5
        var collection: C = .init(repeating: .init(), count: sectionCount)

        let indices: Set<C.Index> = [0, 1, 4]
        indices.forEach { collection[$0].append(searchItem) }
        XCTAssertTrue(collection.find(searchItemClass).count == indices.count, "\(collectionName) failed to append item to section")

        let removedSections = collection.remove(at: indices)
        removedSections.forEach { section in
            XCTAssertEqual(section.first?.model as? String, searchModel, "\(collectionName) failed to remove item at index")
        }
        XCTAssertTrue(collection.find(searchItemClass).count == 0, "\(collectionName) failed to remove sections")
        XCTAssertTrue(collection.count == sectionCount - indices.count, "\(collectionName) failed to remove sections")
    }

    func testRemoveDecorative() {
        guard let decorativeKind = decorativeKinds?().first, let decorative = createDecorative?("Header") else {
            return XCTFail("\(collectionName) failed to create decorative")
        }

        var collection: C = .init()
        let sectionIndex = collection.append(decorative: decorative, ofKind: decorativeKind)
        XCTAssertNotNil(collection[sectionIndex, decorativeKind], "\(collectionName) failed to create decorative")

        collection.remove(decorative: decorativeKind, inSection: sectionIndex)
        XCTAssertNil(collection[sectionIndex, decorativeKind], "\(collectionName) failed to remove decorative")
    }

    func testRemoveAllKeepingCapacity() {
        guard let item = createItem?("item"), let capacity = capactiy else {
            return XCTFail("\(collectionName) failed to create items")
        }

        var collection: C = .init()
        collection.removeAll() // Try to perform removeAll on an empty collection

        collection = .init(repeatElement(.init(decoratives: [:], items: [item]), count: 10))

        XCTAssertFalse(collection.isEmpty)
        let addressBefore: UnsafeMutableRawPointer =  Unmanaged.passUnretained(collection as AnyObject).toOpaque()
        let capacityBefore = capacity(collection)

        collection.removeAll() // Default should be keepingCapacity = true

        let addressAfter: UnsafeMutableRawPointer = Unmanaged.passUnretained(collection as AnyObject).toOpaque()
        let capacityAfter = capacity(collection)
        XCTAssertEqual(addressBefore, addressAfter)
        XCTAssertEqual(capacityBefore, capacityAfter)
        XCTAssertTrue(collection.isEmpty)
    }


    func testRemoveAllNotKeeingCapacity() {
        guard let item = createItem?("item"), let capacity = capactiy else {
            return XCTFail("\(collectionName) failed to create items")
        }

        var collection: C = .init()
        collection.removeAll(keepingCapacity: false) // Try to perform removeAll on an empty collection

        collection = .init(repeatElement(.init(decoratives: [:], items: [item]), count: 10))

        XCTAssertFalse(collection.isEmpty)
        let capacityBefore = capacity(collection)
        let addressBefore: UnsafeMutableRawPointer =  Unmanaged.passUnretained(collection as AnyObject).toOpaque()

        collection.removeAll(keepingCapacity: false)

        let addressAfter: UnsafeMutableRawPointer = Unmanaged.passUnretained(collection as AnyObject).toOpaque()
        let capacityAfter = capacity(collection)
        XCTAssertNotEqual(addressBefore, addressAfter)
        XCTAssertNotEqual(capacityBefore, capacityAfter)
        XCTAssertTrue(collection.isEmpty)
    }
}
