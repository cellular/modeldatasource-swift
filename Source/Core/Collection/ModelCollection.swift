import Foundation
import UIKit

public protocol ModelCollection: MutableCollection, RandomAccessCollection, RangeReplaceableCollection where Self.Element == ModelSection<Self.DataSourceView>, Self.Index == Int {

    associatedtype DataSourceView: ModelDataSourceView
    associatedtype Buffer: MutableCollection, RandomAccessCollection, RangeReplaceableCollection where Buffer.Element == Self.Element, Buffer.Index == Self.Index
    var buffer: Buffer { get set }
}

// MARK: - MutableCollection, RandomAccessCollection, RangeReplaceableCollection

public extension ModelCollection {

    public var startIndex: Int {
        return buffer.startIndex
    }

    public var endIndex: Int {
        return buffer.endIndex
    }

    public subscript(index: Int) -> ModelSection<DataSourceView> {
        get {
            return buffer[index]
        }
        set(section) {
            buffer[index] = section
        }
    }

    public func index(after index: Int) -> Int {
        return buffer.index(after: index)
    }

    public mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C : Collection, Self.Element == C.Element {
        buffer.replaceSubrange(subrange, with: newElements)
    }
}

// MARK: - Convenience

extension ModelCollection {

    public subscript(indexPath: IndexPath) -> ModelItem<DataSourceView> {
        return buffer[indexPath.section][indexPath.item]
    }

    public subscript(section: Int, kind: DataSourceView.DecorativeKind) -> ModelDecorative<DataSourceView>? {
        return self[section].decoratives[kind]
    }
}
