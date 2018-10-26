import UIKit
import ModelDataSource
@testable import ModelDataSource

final class TestTableViewCell: UITableViewCell, ModelDataSourceViewDisplayable {

    static var source: Source<TestTableViewCell> {
        return Source.view(TestTableViewCell.self)
    }

    var model: String?

}

final class TestSearchTableViewCell: UITableViewCell, ModelDataSourceViewDisplayable {

    static var source: Source<TestSearchTableViewCell> {
        return Source.view(TestSearchTableViewCell.self)
    }

    var model: String?
}


final class TestTableViewDecorativeView: UITableViewHeaderFooterView, ModelDataSourceViewDisplayable {

    static var source: Source<TestTableViewDecorativeView> {
        return Source.view(TestTableViewDecorativeView.self)
    }

    var model: String?
}

final class TestCollectionViewCell: UICollectionViewCell, ModelDataSourceViewDisplayable {

    static var source: Source<TestCollectionViewCell> {
        return Source.view(TestCollectionViewCell.self)
    }

    var model: String?

}

final class TestSearchCollectionViewCell: UICollectionViewCell, ModelDataSourceViewDisplayable {

    static var source: Source<TestSearchCollectionViewCell> {
        return Source.view(TestSearchCollectionViewCell.self)
    }

    var model: String?
}


final class TestCollectionViewDecorativeView: UICollectionReusableView, ModelDataSourceViewDisplayable {

    static var source: Source<TestCollectionViewDecorativeView> {
        return Source.view(TestCollectionViewDecorativeView.self)
    }

    var model: String?
}

