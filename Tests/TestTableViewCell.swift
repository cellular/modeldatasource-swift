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


final class TestDecorativeView: UITableViewHeaderFooterView, ModelDataSourceViewDisplayable {

    static var source: Source<TestDecorativeView> {
        return Source.view(TestDecorativeView.self)
    }

    var model: String?
}
