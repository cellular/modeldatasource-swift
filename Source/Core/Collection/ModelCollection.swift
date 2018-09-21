import Foundation
import UIKit

public protocol ModelCollection: MutableCollection, RandomAccessCollection, RangeReplaceableCollection where Self.Element == ModelSection<Self.DataSourceView>, Self.Index == Int {

    associatedtype DataSourceView: ModelDataSourceView
    associatedtype Storage: MutableCollection, RandomAccessCollection, RangeReplaceableCollection where Storage.Element == Self.Element, Storage.Index == Self.Index
    var storage: Storage { get set }
}

public extension ModelCollection {

    public var startIndex: Int {
        return storage.startIndex
    }

    public var endIndex: Int {
        return storage.endIndex
    }

    public subscript(index: Int) -> ModelSection<DataSourceView> {
        get {
            return storage[index]
        }
        set(section) {
            storage[index] = section
        }
    }

    public func index(after index: Int) -> Int {
        return storage.index(after: index)
    }

    public subscript(indexPath: IndexPath) -> ModelItem<DataSourceView> {
        return storage[indexPath.section][indexPath.item]
    }

    public subscript(section: Int, kind: DataSourceView.DecorativeKind) -> ModelDecorative<DataSourceView>? {
        return self[section].decoratives[kind]
    }

    public mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C : Collection, Self.Element == C.Element {
        storage.replaceSubrange(subrange, with: newElements)
    }
}

