import XCTest
@testable import ModelDataSource

class TableViewDataSourceTests: XCTestCase {

    override func setUp() {

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreate() {
        var dataSource = TestDatatSource()

        XCTAssertTrue(dataSource.isEmpty)
        dataSource.append(.init())
        XCTAssertFalse(dataSource.isEmpty)


        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}

struct TestDatatSource {

    public typealias DataSourceView = UITableView
    public typealias Buffer = [ModelSection<UITableView>]
    public typealias Index = Buffer.Index
    private var buffer: Buffer

    init() {
        buffer = []
    }
}

extension TestDatatSource: ModelCollection {

    /// The position of the first element in a nonempty collection.
    ///
    /// If the collection is empty, `startIndex` is equal to `endIndex`.
    public var startIndex: Buffer.Index {
        return buffer.startIndex
    }

    /// The collection's "past the end" position---that is, the position one
    /// greater than the last valid subscript argument.
    ///
    /// When you need a range that includes the last element of a collection, use
    /// the half-open range operator (`..<`) with `endIndex`. The `..<` operator
    /// creates a range that doesn't include the upper bound, so it's always
    /// safe to use with `endIndex`. For example:
    ///
    /// If the collection is empty, `endIndex` is equal to `startIndex`.
    public var endIndex: Buffer.Index {
        return buffer.endIndex
    }

    /// Accesses the element at the specified position.
    ///
    /// You can subscript a collection with any valid index other than the
    /// collection's end index. The end index refers to the position one
    /// past the last element of a collection, so it doesn't correspond with an
    /// element.
    ///
    /// - Parameter position: The position of the element to access. `position`
    ///   must be a valid index of the collection that is not equal to the
    ///   `endIndex` property.
    ///
    /// - Complexity: O(1)
    public subscript(index: Buffer.Index) -> ModelSection<DataSourceView> {
        get {
            return buffer[index]
        }
        set {
            buffer[index] = newValue
        }
    }

    mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C : Collection, R : RangeExpression, ModelSection<TestDatatSource.DataSourceView> == C.Element, TestDatatSource.Index == R.Bound {
        buffer.replaceSubrange(subrange, with: newElements)
    }
}
