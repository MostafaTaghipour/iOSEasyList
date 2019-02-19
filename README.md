# iOSEasyList

[![CI Status](http://img.shields.io/travis/mostafa.taghipour@ymail.com/iOSEasyList.svg?style=flat)](https://travis-ci.org/mostafa.taghipour@ymail.com/iOSEasyList)
[![Version](https://img.shields.io/cocoapods/v/iOSEasyList.svg?style=flat)](http://cocoapods.org/pods/iOSEasyList)
[![License](https://img.shields.io/cocoapods/l/iOSEasyList.svg?style=flat)](http://cocoapods.org/pods/iOSEasyList)
[![Platform](https://img.shields.io/cocoapods/p/iOSEasyList.svg?style=flat)](http://cocoapods.org/pods/iOSEasyList)

## [Android version is here](https://github.com/MostafaTaghipour/AndroidEasyList)

Framework to simplify the setup and configuration of UITableView and UICollectionView data sources and cells. It allows a type-safe setup of (UITableView,UICollectionView) DataSource and Delegate. DataSource also provides out-of-the-box diffing and animated deletions, inserts, moves and changes.


Everything you need to implement your own lists:
- Easy to use UITableView and UICollectionView
- No more calling reloadData
- Diffable
- Configurable animations
- Sectioned
- Pagination
- Collapsible
- Loading footer
- Various UICollectionView layouts
- Empty View
- Filterable
- Multiple data type

<img width="290" alt="animation" src="https://raw.githubusercontent.com/MostafaTaghipour/iOSEasyList/master/screenshots/animation-ios.gif"> <img width="290" alt="expandable" src="https://raw.githubusercontent.com/MostafaTaghipour/iOSEasyList/master/screenshots/expandable_ios.gif"> <img width="290" alt="filtering" src="https://raw.githubusercontent.com/MostafaTaghipour/iOSEasyList/master/screenshots/filtering-ios.gif"> <img width="290" alt="message" src="https://raw.githubusercontent.com/MostafaTaghipour/iOSEasyList/master/screenshots/message-ios.gif"> <img width="290" alt="layout" src="https://raw.githubusercontent.com/MostafaTaghipour/iOSEasyList/master/screenshots/layout-ios.gif"> <img width="290" alt="pagination" src="https://raw.githubusercontent.com/MostafaTaghipour/iOSEasyList/master/screenshots/pagination-ios.gif"> <img width="290" alt="sectioned" src="https://raw.githubusercontent.com/MostafaTaghipour/iOSEasyList/master/screenshots/sectioned-ios.gif">


## Requirements

- Swift 4
- iOS 8+

## Installation

iOSEasyList is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'iOSEasyList'
```


## Usage
1. Define your model
```swift
struct Movie{
    let id : String
    let title : String
}

//optional: If you want to use Diffable capabilities (e.g. automatic animations like delete, insert, move , reload)
//           inherit 'Diffable' ptotocol
extension Movie:Diffable{
    var diffIdentifier: String {
        return id
    }

    //optional: this function need for automatic reload
    func isEqual(to object: Any) -> Bool {
        guard let to = object as? Model else { return false }

        return self.id==to.id &&
               self.title==to.title
    }
}
```

2. Define `TableViewAdapter` in ViewController
```swift
lazy var adapter: TableViewAdapter = { [unowned self] in
    let adapter=TableViewAdapter(tableView: tableView) { (tv, ip, item) -> (UITableViewCell) in
        let cell = tv.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier, for: ip) as! MovieCell
        cell.data = item as? Movie
        return cell
    }
    
    //optional
    adapter.animationConfig = AnimationConfig(reload: .fade, insert: .top, delete: .bottom)
    
    return adapter
}()
```

3. Set Data
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    adapter.setData(newData: items, animated: true)
}
```

4. That's it, for more samples please see example project

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Thanks for

- [AlignedCollectionViewFlowLayout](https://github.com/mischa-hildebrand/AlignedCollectionViewFlowLayout)


## Author

Mostafa Taghipour, mostafa@taghipour.me

## License

iOSEasyList is available under the MIT license. See the LICENSE file for more info.

