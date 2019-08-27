import UIKit

@objc public protocol TableViewDataSourceDelegate: NSObjectProtocol {

    /// Forwards each cell within the data source to the delegate before displaying it in a particular location of the table view.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object that is about to present the specified cell.
    ///   - cell: The cell to be used to position within the table view and that may be prepared before being displayed.
    ///   - indexPath: The index path at which the cell is about to be positioned within the specified table view.
    @objc optional func tableView(_ tableView: UITableView, prepareModelCell cell: UITableViewCell, atIndexPath indexPath: IndexPath)

    /// Asks the data source to verify that the given row is editable. Individual rows can opt out
    /// of having the `-editing` property set for them. Defaults to `false` if not implemented.
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - indexPath: An index path locating a row in tableView.
    /// - Returns: `true` if the row indicated by indexPath is editable; otherwise, `false`.
    @objc optional func tableView(_ tableView: UITableView, canEditRowAtIndexPath indexPath: IndexPath) -> Bool

    /// Asks the data source whether a given row can be moved to another location in the table view and allows the
    /// reorder accessory view to optionally be shown for a particular row. Defaults to `false` if not implemented.
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - indexPath: An index path locating a row in `tableView`.
    /// - Returns: `true` if the row can be moved; otherwise `false`.
    @objc optional func tableView(_ tableView: UITableView, canMoveRowAtIndexPath indexPath: IndexPath) -> Bool

    /// Asks the data source to commit the insertion or deletion of a specified row in the receiver.
    ///
    /// When users tap the insertion (green plus) control or Delete button associated with a UITableViewCell object in the table view,
    /// the table view sends this message to the data source, asking it to commit the change. (If the user taps the deletion (red minus)
    /// control, the table view then displays the Delete button to get confirmation.) The data source commits the insertion or deletion by
    /// invoking the UITableView methods insertRowsAtIndexPaths:withRowAnimation: or deleteRowsAtIndexPaths:withRowAnimation:,
    /// as appropriate.
    ///
    /// You should not call setEditing:animated: within an implementation of this method.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting the insertion or deletion.
    ///   - editingStyle: The cell editing style corresponding to a insertion or deletion requested for the row specified by indexPath.
    ///     Possible editing styles are UITableViewCellEditingStyleInsert or UITableViewCellEditingStyleDelete.
    ///   - indexPath: An index path locating the row in tableView.
    @objc optional func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle,
                                  forRowAtIndexPath indexPath: IndexPath)

    /// Tells the data source to move a row at a specific location in the table view to another location.
    /// The UITableView object sends this message to the data source when the user presses the reorder control in fromRow.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this action.
    ///   - sourceIndexPath: An index path locating the row to be moved in tableView.
    ///   - destinationIndexPath:  An index path locating the row in tableView that is the destination of the move.
    @objc optional func tableView(_ tableView: UITableView, moveRowAtIndexPath sourceIndexPath: IndexPath,
                                  toIndexPath destinationIndexPath: IndexPath)
}
