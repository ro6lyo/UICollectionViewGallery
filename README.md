# UICollectionViewGallery

[![CI Status](http://img.shields.io/travis/ro6lyo/UICollectionViewGallery.svg?style=flat)](https://travis-ci.org/ro6lyo/UICollectionViewGallery)
[![Swift Version](https://img.shields.io/badge/Swift-3.0.x-orange.svg)]()
[![Version](https://img.shields.io/cocoapods/v/UICollectionViewGallery.svg?style=flat)](http://cocoapods.org/pods/UICollectionViewGallery)
[![License](https://img.shields.io/cocoapods/l/UICollectionViewGallery.svg?style=flat)](http://cocoapods.org/pods/UICollectionViewGallery)
[![Platform](https://img.shields.io/cocoapods/p/UICollectionViewGallery.svg?style=flat)](http://cocoapods.org/pods/UICollectionViewGallery)
## Demo
### Vertical Infinite Scroll Layout
![Gif](http://i.giphy.com/l0Hlzlqj7rWyXgYFO.gif)
### Horizontal Infinite Scroll Layout
![Gif](http://i.giphy.com/3oz8xChgUeZLl5NjOM.gif)


## Usage
### General initialization 
UICollectionViewGallery has been implemented as UICollectionView extensions, all public functions are
accesible thru UICollectionView class instances.So basicly you need an instance of UICollectionView, which
can be created programaticly or via Storyboard.
```swift
import UICollectionViewGallery

...
    @IBOutlet weak var galleryCollectionView: UICollectionView!
```
### Basic usage
You can setup the basic UICollectionViewGallery with fallowing function and this propertis: `GalleryFlowStyle` which represents the `enum` for different styles, `minLineSpacing` represents space between cells, `itemSize` represents size of the cells, `minScaleFactor` represents scaling factor between the center cell and the rest of the visible cells.
```swift
galleryCollectionView.setGallery(withStyle: .autoDynamic, minLineSpacing: 10, itemSize: CGSize(width: 200, height: 200),minScaleFactor:0.6)
```
Note that this general approuch sets up the same cell properties for both Vertical and Horizontal flow layouts,howover if you need a more custom approuch you can setup both flow layout seperatly thru the fallowing methods.
```swift
galleryCollectionView.setGallery(forLayout: .vertical, minLineSpacing: 10, itemSize: CGSize(width: 200, height:200), minScaleFactor: 0.5)
galleryCollectionView.setGallery(forLayout: .horizontal, minLineSpacing: 20, itemSize: CGSize(width: 300, height:300), minScaleFactor: 0.8)
galleryCollectionView.setGalleryWithCustomFlows(andStyle: .autoDynamic)
```
### Behavior
You can disable `infinite scroll` and `scaling` by calling the fallowing function,they are enabled by default.
```swift
galleryCollectionView.setGaleryBehavior(forInfiniteScroll: false, andScalingElemnts: false)
```
### Supported Styles
```swift
public enum GalleryFlowStyle {
    case vertical         // vertical flow
    case horizontal       // horizontal flow
    case autoFixed        // flow based on initial aspeciRatio  eg. height > width = Vertical, 
                          //                                        heignt < width = Horizontal
    case autoDynamic      // auto flow based on dynamic aspect ratio: requares orientation change event to be catched   
}
```
### Final Touches
For `infinite scroll` and `.autoDynamic` style support, you have to handle properly 2 events, and call the appropriate functions.
```swift
 func scrollViewDidScroll(_ scrollView: UIScrollView) {
        galleryCollectionView.recenterIfNeeded()
    }
```

```swift
  override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        galleryCollectionView.changeOrientation()
    }
```
### Aditional methods
You can find the indexPath for the center element by using the fallowing UICollectionView extension public property `centerCellIndexPath`
```swift
galleryCollectionView.centerCellIndexPath
```
which retunrs an optional indexPath for the center element of the CollectionView

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- iOS 9.+ 
- Xcode 8.1+
- Swift 3.0+

## Installation

UICollectionViewGallery is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "UICollectionViewGallery"
```

## Author

ro6lyo, roshlyo@icloud.com

## License

UICollectionViewGallery is available under the MIT license. See the LICENSE file for more info.
