import UIKit
import ModelDataSource

final class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView?
    private var dataSource: TableViewDataSource = TableViewDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDataSource()
        buildTableView()
    }

    private func buildTableView() {

        let items: [ModelItem<UITableView>] = (1...10).map { index in
            return .init(model: .init(color: .gray, title: "cell # \(index)"), cell: TableViewCell.self)
        }

        let firstHeaderModel: DecorativeView.Model = .init(color: .darkGray, title: "Header 1")
        let firstDecorative: ModelDecorative<UITableView> =  .init(model: firstHeaderModel, view: DecorativeView.self)
        var firstSection: ModelSection<UITableView> = .init(decorative: firstDecorative, ofKind: .header)
        firstSection.append(contentsOf: items)

        let secondHeaderModel: DecorativeView.Model = .init(color: .darkGray, title: "Header 2")
        let secondDecorative: ModelDecorative<UITableView> =  .init(model: secondHeaderModel, view: DecorativeView.self)
        var secondSection: ModelSection<UITableView> = .init(decorative: secondDecorative, ofKind: .header)
        secondSection.append(contentsOf: items)

        dataSource.append(contentsOf: [firstSection, secondSection])

        tableView?.reloadData()
    }

    private func setupDataSource() {
        tableView?.delegate = self
        tableView?.dataSource = dataSource
        tableView?.register(TableViewCell.self)
        tableView?.register(DecorativeView.self)
    }
}

extension ViewController: UITableViewDelegate {

    // MARK: Cells

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource.heightForCellAtIndexPath(indexPath)
    }

    // MARK: Header

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return dataSource.heightForDecorativeView(inSection: section, ofKind: .header) ?? UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return dataSource.tableView(tableView, decorativeViewOfKind: .header, inSection: section)
    }
}

// MARK: - TableViewCell

final class TableViewCell: UITableViewCell, ModelDataSourceViewDisplayable {

    // MARK: Helper

    struct Model {
        let color: UIColor
        let title: String
    }

    // MARK: ModelDataSourceViewDisplayable

    static var source: Source<TableViewCell> {
        return Source.view(TableViewCell.self)
    }

    var model: Model? {
        didSet {
            titleLabel?.text = model?.title
            contentView.backgroundColor = model?.color
        }
    }

    private var titleLabel: UILabel?

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let headerLabel =  UILabel()
        headerLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        headerLabel.textColor = .white
        headerLabel.textAlignment = .left
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(headerLabel)
        headerLabel.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        contentView.topAnchor.constraint(equalTo: headerLabel.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: headerLabel.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: headerLabel.leftAnchor, constant: -12.0).isActive = true
        contentView.rightAnchor.constraint(equalTo: headerLabel.rightAnchor).isActive = true

        self.titleLabel = headerLabel
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - TestTableViewDecorativeView

final class DecorativeView: UITableViewHeaderFooterView, ModelDataSourceViewDisplayable {

    // MARK: Helper

    struct Model {
        let color: UIColor
        let title: String
    }

    // MARK: ModelDataSourceViewDisplayable

    static var source: Source<DecorativeView> {
        return Source.view(DecorativeView.self)
    }

    var model: Model? {
        didSet {
            contentView.backgroundColor = model?.color
            headerLabel?.text = model?.title
        }
    }

    static var staticSize: Size? { return 100.0 }

    private var headerLabel: UILabel?

    // MARK: Init

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        let headerLabel =  UILabel()
        headerLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        headerLabel.textColor = .white
        headerLabel.textAlignment = .center
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(headerLabel)
        contentView.topAnchor.constraint(equalTo: headerLabel.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: headerLabel.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: headerLabel.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: headerLabel.rightAnchor).isActive = true

        self.headerLabel = headerLabel
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
