import UIKit

/// Defines which type of sources is used to describe the cell or view.
///
/// - view: Cell/View defined within a class file only (No XIB file definitions).
/// - nib: Cell/View defined within an own XIB file.
/// - prototype: Cell/View defined within a storyboard. DataSource wont (and cannot) calculate size.
public enum Source<T: ModelDataSourceViewDisplayable> {
    case view(T.Type)
    case nib(UINib)
    case prototype
}
