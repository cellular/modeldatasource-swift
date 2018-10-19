import UIKit
import ModelDataSource

final class TestTableViewCell: UITableViewCell, ModelDataSourceViewDisplayable {

    static var source: Source<TestTableViewCell> {
        return Source.view(TestTableViewCell.self)
    }

    var model: String?
}
