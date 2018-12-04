import Foundation
import UIKit

/// Protocol implemented by data sources managing a two dimensional list of items and sections.
/// In a `UITableView` context this would mean it manages rows and sections.
public protocol ModelCollection: MutableCollection, RandomAccessCollection, RangeReplaceableCollection
    where Self.Element == ModelSection<DataSourceView>, Index == Int {

    /// Type of the class that should support two dimensional model handling and is driven by a data source (e.g. UITableView)
    associatedtype DataSourceView: ModelDataSourceView
}

// MARK: - Convenience

public extension ModelCollection {

    // MARK: Subscript

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
    subscript(indexPath: IndexPath) -> ModelItem<DataSourceView> {
        get {
            return self[indexPath.section][indexPath.item]
        }
        set {
            self[indexPath.section][indexPath.item] = newValue
        }
    }

    /// Accesses the elements decorative view at the specified position.
    ///
    /// You can subscript a collection with any valid index other than the
    /// collection's end index. The end index refers to the position one
    /// past the last element of a collection, so it doesn't correspond with an
    /// element.
    ///
    /// - Parameter:
    ///   - section: The position of the element to access. `section`
    ///   must be a valid index of the collection that is not equal to the
    ///   `endIndex` property.
    ///   - kind: The kind of the decorative view to access.
    ///
    /// - Complexity: O(1)
    subscript(section: Index, kind: DataSourceView.DecorativeKind) -> ModelDecorative<DataSourceView>? {
        get {
            return self[section][kind]
        }
        set {
            self[section][kind] = newValue
        }
    }

    // MARK: Search

    /// Searches for cells matching the given cell type.
    ///
    /// - Parameter cell: Type of the cell to find.
    /// - Returns: Returns positions of the found cells.
    func find(_ cell: DataSourceView.Cell.Type) -> [IndexPath] {
        return enumerated().reduce(into: [IndexPath]()) { (result, sectionItem)  in
            let section = sectionItem.offset
            let paths = self[section].find(cell).map { IndexPath.init(item: $0, section: section) }
            result.append(contentsOf: paths)
        }
    }

    /// Checks if the indexPath points to the last cell in the section
    ///
    /// - Parameter indexPath: Position of the cell
    /// - Returns: Returns true indexPath equals last valid index in section
    func isLastCellInSection(_ indexPath: IndexPath) -> Bool {
        return indexPath.item == (self[indexPath.section].endIndex - 1)
    }

    /// Checks if the given index is the last section
    ///
    /// - Parameter section: Section index
    /// - Returns: True if the given index is the last section.
    func isLastSection(_ section: Index) -> Bool {
        return section == (endIndex - 1)
    }

    // MARK: Create

    /// Appends a section to self.
    ///
    /// - Returns: The index of the newly created section.
    @discardableResult
    mutating func append(section: ModelSection<DataSourceView>) -> Index {
        let index = count
        append(section)
        return index
    }

    /// Appends a decorative view either to the given section or to the last if none is given.
    /// If a decorative view of the same kind already exists, it will be replaced.
    ///
    /// Iff the collection is empty and no section index is given, a section containing the decorative view will be created.
    /// A provided section index must be a valid index of the collection that is not equal to the `endIndex` property.
    ///
    /// - Parameters:
    ///   - decorative: ModelDecorative to append
    ///   - ofKind: Kind if the decorative view
    ///   - inSection: The optional section in which the view will be appended. If provided,
    ///     the `section` must be a valid index of the collection that is not equal to the
    ///   `endIndex` property.
    /// - Returns: The section index of the appended element
    ///
    /// - Complexity: O(1) on average, over many calls to append(_:) on the same collection.
    @discardableResult
    mutating func append(decorative: ModelDecorative<DataSourceView>,
                         ofKind: DataSourceView.DecorativeKind,
                         inSection: Index? = nil) -> Index {

        if isEmpty && inSection == nil { append(.init()) } // Creates a first section on empty data sources
        let sectionToAppend = inSection ?? endIndex - 1 // Either given section or the last section if none givens
        self[sectionToAppend][ofKind] = decorative
        return sectionToAppend
    }

    /// Appends a ModelItem either to the given section or to the last if none is given.
    ///
    /// Iff the collection is empty and no section index is given, a section containing the item will be created.
    /// A provided section index must be a valid index of the collection that is not equal to the `endIndex` property.
    ///
    /// - Parameters:
    ///   - item: ModelItem to append
    ///   - inSection: The optional section in which the item will be appended. If provided,
    ///     the `section` must be a valid index of the collection that is not equal to the
    /// - Returns: The section index of the appended element
    ///
    /// - Complexity: O(1) on average, over many calls to append(_:) on the same collection.
    @discardableResult
    mutating func append(item: ModelItem<DataSourceView>, inSection: Index? = nil) -> IndexPath {

        if isEmpty && inSection == nil { append(.init()) } // Creates a first section on empty data sources
        let sectionToAppend = inSection ?? endIndex - 1  // Either given section or the last section if none given
        self[sectionToAppend].append(item)
        let itemIndex = self[sectionToAppend].endIndex - 1
        return IndexPath(item: itemIndex, section: sectionToAppend)
    }

    /// Appends a list of ModelItems each containing one element of list of models and referencing the specified cell type.
    ///
    /// Iff the collection is empty and no section index is given, a section containing the item will be created.
    /// A provided section index must be a valid index of the collection that is not equal to the `endIndex` property.
    ///
    /// - Parameters:
    ///   - models: Models to append to the collection
    ///   - cell: The cell type each newly created Element should reference.
    ///   - inSection: The optional section in which the item will be appended. If provided,
    ///     the `section` must be a valid index of the collection that is not equal to the
    /// - Returns: The positions of each created ModelItem.
    ///
    /// - Complexity: O(*n*) where n is the length of the model list.
    @discardableResult
    mutating func append<M, C: ModelDataSourceViewDisplayable>(contentsOf models: [M],
                                                               cell: C.Type,
                                                               inSection: Index? = nil)
        -> [IndexPath] where C.Model == M, C.Size == DataSourceView.Dimension {

        return models.map { append(item: .init(model: $0, cell: cell), inSection: inSection) }
    }

    /// Inserts a new element into the collection at the specified position.
    ///
    /// The new element is inserted before the element currently at the
    /// specified index. If you pass the collection's `endIndex` property as
    /// the `index` parameter, the new element is appended to the
    /// collection.
    ///
    /// Calling this method may invalidate any existing indices for use with this
    /// collection.
    ///
    /// - Parameter item: The new element to insert into the collection.
    /// - Parameter indexPath: The position at which to insert the new element.
    ///   `index` must be a valid index into the collection.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection. If
    ///   `i == endIndex`, this method is equivalent to `append(_:)`.
    mutating func insert(item: ModelItem<DataSourceView>, indexPath: IndexPath) {
        self[indexPath.section].insert(item, at: indexPath.item)
    }

    // MARK: Delete

    /// Removes all elements from the section.
    ///
    /// Calling this method may invalidate any existing indices for use with this
    /// collection.
    ///
    /// - Parameter inSection: The Index of the section to remove all elemets from.
    /// - Parameter keepCapacity: Pass `true` to request that the collection
    ///   avoid releasing its storage. Retaining the collection's storage can
    ///   be a useful optimization when you're planning to grow the collection
    ///   again. The default value is `false`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    mutating func removeAll(inSection section: Index, keepingCapacity keepCapacity: Bool) {
        self[section].removeAll(keepingCapacity: keepCapacity)
    }

    /// Removes all elements from the collection matching the given cell type
    ///
    /// - Parameter cell: Cell type to remove from collection
    /// - Returns: List of IndexPahts that where removed
    ///
    /// - Complexity: O(n^2), where n is the length of the collection.
    @discardableResult
    mutating func removeAll(matching cell: DataSourceView.Cell.Type) -> [IndexPath] {
        let paths = find(cell)
        remove(at: Set(paths))
        return paths
    }

    /// Removes and returns the element at the specified position.
    ///
    /// Calling this method may invalidate any existing indices for use with this
    /// collection.
    ///
    /// - Parameter indexPath: The position of the element to remove. `Index.section` and Index.Item`
    ///   must be a valid index of the collection and it's sub collection.
    /// - Returns: The removed element.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    @discardableResult
    mutating func remove(at indexPath: IndexPath) -> ModelItem<DataSourceView> {
        return self[indexPath.section].remove(at: indexPath.item)
    }

    /// Removes model and cell at given `indexPaths`.
    ///
    /// Calling this method may invalidate any existing indices for use with this
    /// collection.
    ///
    /// - Parameter indices: Indices to remvoe
    /// - Returns: Removed elemnts
    ///
    /// - Complexity: O(*n^2*), where *n* is the length of the collection.
    @discardableResult
    mutating func remove(at indexPaths: Set<IndexPath>) -> [ModelItem<DataSourceView>] {
        return indexPaths.sorted(by: >).map {
            remove(at: $0)
        }
    }

    /// Removes model and cell at given `indices`.
    ///
    /// Calling this method may invalidate any existing indices for use with this
    /// collection.
    ///
    /// - Parameter indices: Indices to remvoe
    /// - Returns: Removed elemnts
    ///
    /// - Complexity: O(*n^2*), where *n* is the length of the collection.
    @discardableResult
    mutating func remove(at indices: Set<Index>) -> [ModelSection<DataSourceView>] {
        return indices.sorted(by: >).map { section in
            remove(at: section)
        }
    }

    /// Rmeoves decorative in the given section
    ///
    /// - Parameters:
    ///   - ofKind: The type of the decorative view.
    ///   - inSection: The section which contains the decorative view.
    /// - Returns: Removed Decorative or nil
    @discardableResult
    mutating func remove(decorative ofKind: DataSourceView.DecorativeKind, inSection: Index) -> ModelDecorative<DataSourceView>? {
        return self[inSection].remove(decorative: ofKind)
    }
}
