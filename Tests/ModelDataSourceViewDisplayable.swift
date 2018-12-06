import UIKit
import ModelDataSource

protocol TestModelDataSourceViewDisplayable: ModelDataSourceViewDisplayable {
    static var testModel: Model { get }
}

final class TestTableViewCell: UITableViewCell, TestModelDataSourceViewDisplayable {

    static var source: Source<TestTableViewCell> {
        return Source.view(TestTableViewCell.self)
    }

    var model: String?
    static var testModel: String { return reuseIdentifier }
}

final class TestSearchTableViewCell: UITableViewCell, TestModelDataSourceViewDisplayable {

    static var source: Source<TestSearchTableViewCell> {
        return Source.view(TestSearchTableViewCell.self)
    }

    var model: String?
    static var testModel: String { return reuseIdentifier }
}


final class TestTableViewDecorativeView: UITableViewHeaderFooterView, TestModelDataSourceViewDisplayable {

    static var source: Source<TestTableViewDecorativeView> {
        return Source.view(TestTableViewDecorativeView.self)
    }

    var model: String?
    static var testModel: String { return reuseIdentifier }
}

final class TestCollectionViewCell: UICollectionViewCell, TestModelDataSourceViewDisplayable {

    static var source: Source<TestCollectionViewCell> {
        return Source.view(TestCollectionViewCell.self)
    }

    var model: String?
    static var testModel: String { return reuseIdentifier }
}

final class TestSearchCollectionViewCell: UICollectionViewCell, TestModelDataSourceViewDisplayable {

    static var source: Source<TestSearchCollectionViewCell> {
        return Source.view(TestSearchCollectionViewCell.self)
    }

    var model: String?
    static var testModel: String { return reuseIdentifier }
}


final class TestCollectionViewDecorativeView: UICollectionReusableView, TestModelDataSourceViewDisplayable {

    static var source: Source<TestCollectionViewDecorativeView> {
        return Source.view(TestCollectionViewDecorativeView.self)
    }

    var model: String?
    static var testModel: String { return reuseIdentifier }
}
