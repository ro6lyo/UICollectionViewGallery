//
//  GalleryCollectionView.swift
//  Pods
//
//  Created by Mehmed Kadir on 11/23/16.
//
//

import UIKit

public enum FlowLayouts {
    case vertical
    case horizontal
}

public enum GalleryFlowStyle {
    case vertical         // vertical flow
    case horizontal       // horizontal flow
    case autoFixed        // flow based on initial aspeciRatio  eg. height > width = Vertical, 
                          //                                        heignt < width = Horizontal
    
    case autoDynamic      // auto flow based on dynamic aspect ratio: requares orientation change event to be catched
    
}
typealias Gallery = CustomCollectionViewGallery

open class CustomCollectionViewGallery {
    //Default implementation
    static let sharedInstance = CustomCollectionViewGallery()
    
    let verticalLayout = VerticalFlowLayout()
    let horizontalLayout = HorizontalFlowLayout()
    
    var minimumLineSpacing:CGFloat = 10
    var itemSize = CGSize(width: 200, height: 200)
    var minimumScaleFactor = 0.5
    
    var orientation:GalleryFlowStyle = .autoDynamic
    var orintationSupport = false
    
    open var shouldScrollInfinite = true   //  can be changed based on requared behaviour
    open var shouldScale = true     //  can be changed based on requared behaviour
}

extension UICollectionView {
    /**
     You should use this method to initialize UICollectionViewGallery
     it initializes both Vertical and Horizontal layouts with same parameter
     however if you want to initilizae Vertical and Horizontal layouts with different parameters
     you can initialize them seperatly
     by calling setGallery(forLayout layout: FlowLayouts,minLineSpacing:CGFloat,itemSize:CGSize,minScaleFactor scaleFactor:CGFloat)
     for both layouts and
     */
    public func setGallery(withStyle style:GalleryFlowStyle, minLineSpacing:CGFloat,itemSize:CGSize,minScaleFactor scaleFactor:CGFloat){
        
        switch style {
        case .vertical:
            setUpVerticalFlowLayout(withMinumimLineSpacing: minLineSpacing, andItemSize: itemSize,minScaleFactor: scaleFactor)
            
        case .horizontal:
            setUpHorizontalFlowLayout(withMinumimLineSpacing: minLineSpacing, andItemSize: itemSize,minScaleFactor: scaleFactor)
            
        case .autoFixed,.autoDynamic:
            setUpHorizontalFlowLayout(withMinumimLineSpacing: minLineSpacing, andItemSize: itemSize,minScaleFactor: scaleFactor)
            setUpVerticalFlowLayout(withMinumimLineSpacing: minLineSpacing, andItemSize: itemSize,minScaleFactor: scaleFactor)
        }
        setGalleryWithCustomFlows(andStyle: style)
    }
    /**
     use it only for seperate implementation of Vertical and Horizontal Layouts
     */
    public func setGallery(forLayout layout: FlowLayouts,minLineSpacing:CGFloat,itemSize:CGSize,minScaleFactor scaleFactor:CGFloat) {
        switch layout {
        case .vertical:
            setUpVerticalFlowLayout(withMinumimLineSpacing: minLineSpacing, andItemSize: itemSize,minScaleFactor: scaleFactor)
        case .horizontal:
            setUpHorizontalFlowLayout(withMinumimLineSpacing: minLineSpacing, andItemSize: itemSize,minScaleFactor: scaleFactor)
        }
    }
    /**
     use it only with custom Flows implementations
     */
    public func setGalleryWithCustomFlows(andStyle style:GalleryFlowStyle) {
        Gallery.sharedInstance.orientation = style
        Gallery.sharedInstance.orintationSupport = false
        self.isPagingEnabled = false
        self.decelerationRate = UIScrollViewDecelerationRateFast
        configureGallery()
    }
    /**
     Changes orientation flow from Veertical to Horizontal and vice versa
     Default implementations is to be used in func willRotate, so it can change
     flow based on device orientation
     */
    public func changeOrientation(){
        guard Gallery.sharedInstance.orintationSupport else {return}
    
        if self.collectionViewLayout.isKind(of: VerticalFlowLayout.self) && self.bounds.size.height > self.bounds.size.width {
            UIView.animate(withDuration: 0.2) { () -> Void in
                self.collectionViewLayout.invalidateLayout()
                self.setCollectionViewLayout(Gallery.sharedInstance.horizontalLayout, animated: false)
            }
            
        } else if self.collectionViewLayout.isKind(of: HorizontalFlowLayout.self) && self.bounds.size.width > self.bounds.size.height {
            UIView.animate(withDuration: 0.2) { () -> Void in
                self.collectionViewLayout.invalidateLayout()
                self.setCollectionViewLayout(Gallery.sharedInstance.verticalLayout, animated: false)
            }
            
        }
    }
    /**
     use it only in scrollViewDidScroll delegate method call
     */
    public func recenterIfNeeded() {
        if self.collectionViewLayout.isKind(of: VerticalFlowLayout.self) {
            let layout = self.collectionViewLayout as! VerticalFlowLayout
            layout.recenterIfNeeded()
            
        } else if self.collectionViewLayout.isKind(of: HorizontalFlowLayout.self) {
            let layout = self.collectionViewLayout as! HorizontalFlowLayout
            layout.recenterIfNeeded()
            
        }
    }
    public func setGaleryBehavior(forInfiniteScroll shouldScroll:Bool, andScalingElemnts shouldScale:Bool){
        Gallery.sharedInstance.shouldScrollInfinite = shouldScroll
        Gallery.sharedInstance.shouldScale = shouldScale
    }

    
    //
    //MARK:- Private Functions
    //
    private func setUpVerticalFlowLayout(withMinumimLineSpacing minLineSpacing:CGFloat,andItemSize itemSize:CGSize,minScaleFactor scaleFactor:CGFloat){
        Gallery.sharedInstance.verticalLayout.minimumLineSpacing = minLineSpacing
        Gallery.sharedInstance.verticalLayout.itemSize = itemSize
        Gallery.sharedInstance.verticalLayout.minimumScaleFactor = scaleFactor
        Gallery.sharedInstance.verticalLayout.inifiniteScroll = Gallery.sharedInstance.shouldScrollInfinite
        Gallery.sharedInstance.verticalLayout.scaleElements = Gallery.sharedInstance.shouldScale
    }
    
    private func setUpHorizontalFlowLayout(withMinumimLineSpacing minLineSpacing:CGFloat,andItemSize itemSize:CGSize,minScaleFactor scaleFactor:CGFloat){
        Gallery.sharedInstance.horizontalLayout.minimumLineSpacing = minLineSpacing
        Gallery.sharedInstance.horizontalLayout.itemSize = itemSize
        Gallery.sharedInstance.horizontalLayout.minimumScaleFactor = scaleFactor
        Gallery.sharedInstance.horizontalLayout.inifiniteScroll = Gallery.sharedInstance.shouldScrollInfinite
        Gallery.sharedInstance.horizontalLayout.scaleElements = Gallery.sharedInstance.shouldScale
    }
    
    private func configureGallery(){
        
        switch Gallery.sharedInstance.orientation {
        case .vertical:
            self.collectionViewLayout = Gallery.sharedInstance.verticalLayout
        case .horizontal:
            self.collectionViewLayout = Gallery.sharedInstance.horizontalLayout
            
        case .autoFixed:
            autoLayoutFixed()
            
        case .autoDynamic:
            Gallery.sharedInstance.orintationSupport = true
            autoLayoutFixed()
        }
    }
    /**
     flow based and inital aspect ratio
     */
    private func autoLayoutFixed(){
        if self.bounds.size.height > self.bounds.size.width {
            self.collectionViewLayout = Gallery.sharedInstance.verticalLayout
        }else {
            self.collectionViewLayout = Gallery.sharedInstance.horizontalLayout
        }
    }
}
extension UICollectionView {
    
    var centerPoint : CGPoint {
        
        get {
            return CGPoint(x: self.center.x + self.contentOffset.x, y: self.center.y + self.contentOffset.y);
        }
    }
    
    public var centerCellIndexPath: NSIndexPath? {
        
        if let centerIndexPath: NSIndexPath  = self.indexPathForItem(at: self.centerPoint) as NSIndexPath? {
            return centerIndexPath
        }
        return nil
    }
}

