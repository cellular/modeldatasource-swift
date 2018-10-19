import UIKit

open class TableViewDataSource: NSObject, ModelCollection {

    // MARK: ModelCollection
    public typealias DataSourceView = UITableView
    // swiftlint:disable syntactic_sugar
    public typealias Buffer = Array<ModelSection<UITableView>>
    // swiftlint:enable syntactic_sugar
    public var buffer: Buffer

    open weak var delegate: TableViewDataSourceDelegate?

    required public override init() {
        buffer = []
        super.init()
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
