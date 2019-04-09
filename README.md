<center>

# modeldatasource-swift

<b>
Easily and safely manage your content for data compatible views. The module is capable of handling two dimensional sets of data and simplifies displaying content in section and row/item based views.
Every set of data/content and the associated view is stored within a ModelCollection. The ModelCollection inherites from MutableCollection, RandomAccessCollection, RangeReplaceableCollection. Concrete classes conforming against ModelCollection are TableViewDataSource and CollectionViewDataSource.
</b>

[![Swift Version](https://img.shields.io/badge/swift-4.2-orange.svg?style=flat)](https://swift.org)
[![Travis Build](https://img.shields.io/travis/com/cellular/networking-swift.svg)](http://travis-ci.com/cellular/modeldatasource-swift/)
[![Coverage Report](https://codecov.io/gh/cellular/modeldatasource-swift/branch/master/graph/badge.svg)](https://codecov.io/gh/cellular/modeldatasource-swift)


</center>

## Example TableViewDataSource
---

```swift
// The Example shows how to display two sections, each with 10 cells and a header.
//
// To use a data source there a certain requirements that have to be fulfilled:
// Every cell or header/footer view needs to conform against ModelDataSourceViewDisplayable. 
// They can be stored with their associated content (Model) in either a ModelItem or ModelDecorative
// which are contstrained to a specific view conforming against ModelDataSourceView (e.g. UITableView). 
// Each section is represented by a ModelSection holding ModelItems and ModelDecoratives.
//
// NOTE: The Example folder contains the full code.

let dataSource = TableViewDataSource()

// Setup the UITableViewView
let tableView = UITableView()
tableView.register(TableViewCell.self)
tableView.register(DecorativeView.self)
tableView.dataSource = dataSource

// Items to be displayed in each section-
let items: [ModelItem<UITableView>] = (1...10).map { index in
    return .init(model: .init(color: .gray, title: "cell # \(index)"), cell: TableViewCell.self)
}

// Build first section
let firstHeaderModel: DecorativeView.Model = .init(color: .darkGray, title: "Header 1")
let firstDecorative: ModelDecorative<UITableView> =  .init(model: firstHeaderModel, view: DecorativeView.self)
var firstSection: ModelSection<UITableView> = .init(decorative: firstDecorative, kind: .header)
firstSection.append(contentsOf: items)

// Build second section.
let secondHeaderModel: DecorativeView.Model = .init(color: .darkGray, title: "Header 2")
let secondDecorative: ModelDecorative<UITableView> =  .init(model: secondHeaderModel, view: DecorativeView.self)
var secondSection: ModelSection<UITableView> = .init(decorative: secondDecorative, kind: .header)
secondSection.append(contentsOf: items)

// Append the sections to the TableViewDataSource.
dataSource.append(contentsOf: [firstSection, secondSection])

// Load the content into the UITableView.
tableView.reloadData()

```


## Cusomization
---
If you want to customize the data source handling, either subclass TableViewDataSource/CollectionViewDataSource or create a custom class that conforms to ModelCollection.

## Installation
---

```ruby
### Cocoapods
pod 'CellularModelDataSource'
```