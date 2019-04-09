<!-- markdownlint-disable MD002 MD033 MD041 -->
<h1 align="center">
  <a href="https://cellular.de">
    <img src="./.github/cellular.svg" width="300" max-width="50%">
  </a>
  <br>modeldatasource<br>
</h1>


<h4 align="center">
Easily and safely manage your content for data compatible views. The module is capable of handling two dimensional sets of data and simplifies displaying content in section and row/item based views.
Every set of data/content and the associated view is stored within a ModelCollection. The ModelCollection inherites from MutableCollection, RandomAccessCollection, RangeReplaceableCollection. Concrete classes conforming against ModelCollection are TableViewDataSource and CollectionViewDataSource.
</h4>

<p align="center">
    <a href="https://swift.org">
        <img src="https://img.shields.io/badge/swift-4.2-orange.svg?style=flat" alt="Swift Version">
    </a>
    <a href="http://travis-ci.com/cellular/modeldatasource-swift/">
        <img src="https://img.shields.io/travis/com/cellular/networking-swift.svg" alt="Travis Build">
    </a>
     <a href="https://codecov.io/gh/cellular/modeldatasource-swift">
        <img src="https://codecov.io/gh/cellular/modeldatasource-swift/branch/master/graph/badge.svg" alt="Coverage Report">
    </a>
</p>
<!-- markdownlint-enable MD033 -->

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

var dataSource = TableViewDataSource()

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