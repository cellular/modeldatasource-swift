//
//  TestModelSection.swift
//  ModelDataSourceTests
//
//  Created by Michael Hass on 26.10.18.
//  Copyright © 2018 CELLULAR GmbH. All rights reserved.
//

import XCTest
@testable import ModelDataSource

final class TestModelSection: XCTestCase {

    /// MARK: Collection Conformance

    func testEmptyInit() {
        let modelSection: ModelSection<UITableView> = .init()
        XCTAssertTrue(modelSection.isEmpty)
    }

    func testIndex() {
        var modelSection: ModelSection<UITableView> = .init()
        XCTAssertTrue(modelSection.startIndex == modelSection.endIndex)

        let initialModel: String = "initial"
        modelSection.append(.init(model: initialModel, cell: TestTableViewCell.self))

        XCTAssertFalse(modelSection.isEmpty)
        XCTAssertTrue(modelSection.startIndex == 0 && modelSection.endIndex == 1)
    }

    func testIndexSubscript() {
        var modelSection: ModelSection<UITableView> = .init()
        let initialModel: String = "initial"
        modelSection.append(.init(model: initialModel, cell: TestTableViewCell.self))
        XCTAssertTrue(modelSection.startIndex == 0 && modelSection.endIndex == 1)
        XCTAssertEqual((modelSection[0].model as? String), initialModel)
        let replacedModel = "replaced"
        modelSection[0] = .init(model: replacedModel, cell: TestTableViewCell.self)
        XCTAssertEqual((modelSection[0].model as? String), replacedModel)
    }

    func testReplaceSubrange() {

        var modelSection: ModelSection<UITableView> = .init()
        let initialModel: String = "initial"
        let replacedModel = "replaced"

        // Repalce subrange
        let replaceRange = 4...7
        let initialCount = 10
        let repatingModel = ModelItem<UITableView>.init(model: initialModel, cell: TestTableViewCell.self)
        modelSection = .init(decoratives: [:], items: Array(repeating: repatingModel, count: initialCount))

        let newElements: [ModelItem<UITableView>] = replaceRange.map { _ in .init(model: replacedModel, cell: TestTableViewCell.self) }
        modelSection.replaceSubrange(replaceRange, with: newElements)
        XCTAssertTrue(modelSection.count == initialCount)

        modelSection.enumerated().forEach { offset, element in
            if replaceRange.contains(offset) {
                XCTAssertEqual(element.model as? String, replacedModel)
            } else {
                XCTAssertEqual(element.model as? String, initialModel)
            }
        }
    }

    // MARK: Convenience

    func testDecorativeInit() {
        let header: ModelDecorative<UITableView> =  .init(model: "header", view: TestDecorativeView.self)
        let modelSection = ModelSection.init(decorative: header, kind: .header)
        XCTAssertNotNil(modelSection[.header])
        XCTAssertNil(modelSection[.footer])
    }

    func testFullInit() {
        let count = 10
        let repatingModel: ModelItem<UITableView> = .init(model: "Test", cell: TestTableViewCell.self)
        let items: [ModelItem<UITableView>] = Array(repeating: repatingModel, count: count)
        let header: ModelDecorative<UITableView> =  .init(model: "header", view: TestDecorativeView.self)
        let modelSection = ModelSection(decoratives: [.header: header], items: items)

        XCTAssertNotNil(modelSection[.header])
        XCTAssertNil(modelSection[.footer])
        XCTAssertTrue(modelSection.count == count)
    }

    func testDecorativeSubscript() {
        var modelSection: ModelSection<UITableView> = .init()
        XCTAssertNil(modelSection[.footer])
        XCTAssertNil(modelSection[.header])

        modelSection[.footer] = .init(model: "footer", view: TestDecorativeView.self)
        modelSection[.header] = .init(model: "header", view: TestDecorativeView.self)

        XCTAssertEqual(modelSection[.footer]?.model as? String, "footer")
        XCTAssertEqual(modelSection[.header]?.model as? String, "header")
    }

    func testFind() {
        var modelSection: ModelSection<UITableView> = .init()

        let items: [ModelItem<UITableView>] = (0..<10).map { _ in .init(model: "Test Model", cell: TestTableViewCell.self) }
        modelSection.append(contentsOf: items)
        let searchModel = "Search Model"
        let replaceIndices = [5, 8]
        replaceIndices.forEach { modelSection[$0] = .init(model: searchModel, cell: TestSearchTableViewCell.self) }

        let found = modelSection.find(TestSearchTableViewCell.self)
        XCTAssertEqual(replaceIndices, found)
    }

    func testRemoveDecorative() {
        var modelSection: ModelSection<UITableView> = .init()
        XCTAssertNil(modelSection[.footer])
        XCTAssertNil(modelSection[.header])

        modelSection[.footer] = .init(model: "footer", view: TestDecorativeView.self)
        modelSection[.header] = .init(model: "header", view: TestDecorativeView.self)

        let removedItem = modelSection.remove(decorative: .footer)
        XCTAssertEqual(removedItem?.model as? String, "footer")
        XCTAssertNil(modelSection[.footer])
    }
}
