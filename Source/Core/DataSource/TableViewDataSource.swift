
import UIKit

open class TableViewDataSource: NSObject, ModelCollection {

    public typealias DataSourceView = UITableView
    public typealias Buffer = [ModelSection<UITableView>]

    public var buffer: Buffer = []

    open weak var delegate: TableViewDataSourceDelegate?

    required public override init() {
        super.init()
    }
}

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

@objc public protocol TableViewDataSourceDelegate: NSObjectProtocol {

    /**
     Forwards each cell within the data source to the delegate before displaying it in a particular location of the table view.

     - parameter tableView: The table-view object that is about to present the specified cell.
     - parameter cell:      The cell to be used to position within the table view and that may be prepared before being displayed.
     - parameter indexPath: The index path at which the cell is about to be positioned within the specified table view.
     */
    @objc optional func tableView(_ tableView: UITableView, prepareModelCell cell: UITableViewCell, atIndexPath indexPath: IndexPath)

    /**
     Asks the data source to verify that the given row is editable. Individual rows can opt out
     of having the `-editing` property set for them. Defaults to `false` if not implemented.

     - parameter tableView: The table-view object requesting this information.
     - parameter indexPath: An index path locating a row in tableView.

     - returns: `true` if the row indicated by indexPath is editable; otherwise, `false`.
     */
    @objc optional func tableView(_ tableView: UITableView, canEditRowAtIndexPath indexPath: IndexPath) -> Bool

    /**
     Asks the data source whether a given row can be moved to another location in the table view and allows the
     reorder accessory view to optionally be shown for a particular row. Defaults to `false` if not implemented.

     - parameter tableView: The table-view object requesting this information.
     - parameter indexPath: An index path locating a row in `tableView`.

     - returns: `true` if the row can be moved; otherwise `false`.
     */
    @objc optional func tableView(_ tableView: UITableView, canMoveRowAtIndexPath indexPath: IndexPath) -> Bool

    /**
     Asks the data source to commit the insertion or deletion of a specified row in the receiver.

     When users tap the insertion (green plus) control or Delete button associated with a UITableViewCell object in the table view,
     the table view sends this message to the data source, asking it to commit the change. (If the user taps the deletion (red minus)
     control, the table view then displays the Delete button to get confirmation.) The data source commits the insertion or deletion by
     invoking the UITableView methods insertRowsAtIndexPaths:withRowAnimation: or deleteRowsAtIndexPaths:withRowAnimation:, as appropriate.

     You should not call setEditing:animated: within an implementation of this method.

     - parameter tableView:    The table-view object requesting the insertion or deletion.
     - parameter editingStyle: The cell editing style corresponding to a insertion or deletion requested for the row specified by indexPath.
     Possible editing styles are UITableViewCellEditingStyleInsert or UITableViewCellEditingStyleDelete.
     - parameter indexPath:    An index path locating the row in tableView.
     */
    @objc optional func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle,
                                  forRowAtIndexPath indexPath: IndexPath)

    /**
     Tells the data source to move a row at a specific location in the table view to another location.
     The UITableView object sends this message to the data source when the user presses the reorder control in fromRow.

     - parameter tableView:            The table-view object requesting this action.
     - parameter sourceIndexPath:      An index path locating the row to be moved in tableView.
     - parameter destinationIndexPath: An index path locating the row in tableView that is the destination of the move.
     */
    @objc optional func tableView(_ tableView: UITableView, moveRowAtIndexPath sourceIndexPath: IndexPath,
                                  toIndexPath destinationIndexPath: IndexPath)
}
