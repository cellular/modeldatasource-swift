import UIKit

open class TableViewDataSource: NSObject {

    public typealias DataSourceView = UITableView
    public typealias Buffer = [ModelSection<UITableView>]
    public typealias Index = Buffer.Index

    private var buffer: Buffer

    open weak var delegate: TableViewDataSourceDelegate?

    /// Creates a new, empty collection (required by RangeReplaceableCollection)
    required override public init() {
        buffer = []
        super.init()
    }
}

// MARK: - ModelCollection Collection conformance (MutableCollection, RandomAccessCollection, RangeReplaceableCollection)

extension TableViewDataSource: ModelCollection {

    /// The position of the first element in a nonempty collection.
    ///
    /// If the collection is empty, `startIndex` is equal to `endIndex`.
    public var startIndex: Index {
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
    public var endIndex: Index {
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
    public subscript(index: Index) -> ModelSection<DataSourceView> {
        get {
            return buffer[index]
        }
        set {
            buffer[index] = newValue
        }
    }
}

// MARK: - UITableViewDataSource

extension TableViewDataSource: UITableViewDataSource {

    open func heightForCellAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
        return self[indexPath].size ?? UITableView.automaticDimension
    }

    open func heightForDecorativeView(inSection section: Int, ofKind kind: UITableViewDecorativeKind) -> CGFloat? {
        return self[section, kind]?.size
    }

    // MARK: UITableView DataSource Support

    open func numberOfSections(in tableView: UITableView) -> Int {
        return count
    }

    open func tableView(_ tableView: UITableView, decorativeViewOfKind kind: UITableViewDecorativeKind,
                        inSection section: Int) -> UITableViewHeaderFooterView? {

        guard let identifier = self[section, kind]?.reuseIdentifier else { return nil }
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self[section].count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: self[indexPath].reuseIdentifier, for: indexPath)
        delegate?.tableView?(tableView, prepareModelCell: cell, atIndexPath: indexPath)
        return cell
    }

    // MARK: Editing

    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return delegate?.tableView?(tableView, canEditRowAtIndexPath: indexPath) ?? false
    }

    // MARK: Moving & Re-Ordering

    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return delegate?.tableView?(tableView, canMoveRowAtIndexPath: indexPath) ?? false
    }

    // MARK: Data manipulation

    open func tableView(_ tableView: UITableView, commit commitEditingStyle: UITableViewCell.EditingStyle,
                        forRowAt forRowAtIndexPath: IndexPath) {
        delegate?.tableView?(tableView, commitEditingStyle: commitEditingStyle, forRowAtIndexPath: forRowAtIndexPath)
    }

    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to toIndexPath: IndexPath) {
        delegate?.tableView?(tableView, moveRowAtIndexPath: sourceIndexPath, toIndexPath: toIndexPath)
    }
}
