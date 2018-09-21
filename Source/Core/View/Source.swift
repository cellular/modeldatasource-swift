import UIKit

/**
 Defines which type of sources is used to describe the cell or view.
 */
public enum Source<T: ModelDataSourceViewDisplayable> {
    // Cell/View defined within a class file only (No XIB file definitions).
    case view(T.Type)
    // Cell/View defined within an own XIB file.
    case nib(UINib)
    // Cell/View defined within a storyboard. DataSource wont (and cannot) calculate size.
    case prototype
}
