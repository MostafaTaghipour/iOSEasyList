# iOSEasyList

[![CI Status](http://img.shields.io/travis/mostafa.taghipour@ymail.com/iOSEasyList.svg?style=flat)](https://travis-ci.org/mostafa.taghipour@ymail.com/iOSEasyList)
[![Version](https://img.shields.io/cocoapods/v/iOSEasyList.svg?style=flat)](http://cocoapods.org/pods/iOSEasyList)
[![License](https://img.shields.io/cocoapods/l/iOSEasyList.svg?style=flat)](http://cocoapods.org/pods/iOSEasyList)
[![Platform](https://img.shields.io/cocoapods/p/iOSEasyList.svg?style=flat)](http://cocoapods.org/pods/iOSEasyList)
Framework to simplify the setup and configuration of UITableView and UICollectionView data sources and cells. It allows a type-safe setup of (UITableView,UICollectionView) DataSource and Delegate. DataSource also provides out-of-the-box diffing and animated deletions, inserts, moves and changes.


Everything you need to implement your own lists:
- Easy to use UITableView and UICollectionView
- No more calling reloadData
- Diffable
- Configurable animations
- Sectioned
- Pagination
- Expandable
- Loading footer
- Various UICollectionView layouts
- Empty View
- Multiple data type

<img width="290" alt="animation" src="/screenshots/animation-ios.gif"> <img width="290" alt="expandable" src="/screenshots/expandable_ios.gif"> <img width="290" alt="filtering" src="/screenshots/filtering-ios.gif"> <img width="290" alt="message" src="/screenshots/message-ios.gif"> <img width="290" alt="layout" src="/screenshots/layout-ios.gif"> <img width="290" alt="pagination" src="/screenshots/pagination-ios.gif"> <img width="290" alt="sectioned" src="/screenshots/sectioned-ios.gif">


## Requirements

- Swift 4
- iOS 8+

## Usage
1. Define your model
```swift
struct Movie : Diffable {
    let id : String
    let title : String

    var diffIdentifier: String {
        return id
    }

    //optional
    func isEqual(to object: Any) -> Bool {
        guard let to = object as? Model else { return false }

        return self.id==to.id &&
        self.title==to.title
    }
}
```

2. Define `TableViewAdapter` in ViewController
```swift
let tableView: UITableView

override func viewDidLoad() {
    super.viewDidLoad()
    let adapter=TableViewAdapter(tableView: tableView) { (tv, ip, item) -> (UITableViewCell) in
        let cell = tv.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier, for: ip) as! MovieCell
        cell.data = item as? Movie
        return cell
    }

    adapter.animationConfig = AnimationConfig(reload: .fade, insert: .top, delete: .bottom)
}
```

3. Set Data
```swift
    adapter.setData(newData: items, animated: true)
```

4. That's it, for more samples please see example project

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

iOSEasyList is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
    pod 'iOSEasyList'
```

## Author

mostafa.taghipour@ymail.com, mostafa.taghipour@ymail.com

## License

iOSEasyList is available under the MIT license. See the LICENSE file for more info.

