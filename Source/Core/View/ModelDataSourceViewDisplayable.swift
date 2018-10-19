import Foundation

public protocol ModelDataSourceViewDisplayable: class {

    /// The model class to be associated with the cell.
    associatedtype Model

    /// The variable/dynamic dimension of the cell for sizing calculations.
    associatedtype Size

    /// The source file of the decorative view. Used to register/dequeue & calculate size of the receiver.
    static var source: Source<Self> { get }

    /// Unique cell reuse identifier. Used to register and dequeue the receiver.
    static var reuseIdentifier: String { get }

    /// Optional fixed size definition to override dynamic height calculations.
    static var staticSize: Size? { get }

    /// Model that was associated with the cell on initialization or reuse.
    var model: Model? { get set }
}

// MARK: - Defaults

public extension ModelDataSourceViewDisplayable {

    /// Defaults to the class name of the view. Raw class name only, no module or hash attached.
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    /// Optional fixed size definition to override dynamic height calculations.
    public static var staticSize: Size? {
        return nil
    }
}
