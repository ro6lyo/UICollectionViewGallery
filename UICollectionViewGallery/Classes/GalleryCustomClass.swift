//
//  GalleryCollectionView.swift
//  Pods
//
//  Created by Mehmed Kadir on 11/23/16.
//
//

import UIKit

public enum OrientationState {
    case vertical         // vertical flow
    case horizontal       // horizontal flow
    case autoFixed        // flow based on inital aspecRatio  eg. height > width = Vertical   heignt < withd = Horizontal
    case autoDynamic      // auto flow based on dynamic aspect ratio: requares orientation change event to be catched
}

open class CustomCollectionViewGallery {
    static let sharedInstance = CustomCollectionViewGallery()
    
    let verticalLayout = VerticalFlowLayout()
    let horizontalLayout = HorizontalFlowLayout()
    
    var  minimumLineSpacing:CGFloat = 10
    var  itemSize = CGSize(width: 200, height: 200)
    
    var orientation:OrientationState = .autoDynamic
    var orintationSupport = false
}

extension UICollectionView {
    
    
    public func setGallery(withStyle style:OrientationState, minLineSpacing:CGFloat,itemSize:CGSize){
        CustomCollectionViewGallery.sharedInstance.orientation = style
        CustomCollectionViewGallery.sharedInstance.orintationSupport = false
        CustomCollectionViewGallery.sharedInstance.verticalLayout.minimumLineSpacing = minLineSpacing
        CustomCollectionViewGallery.sharedInstance.verticalLayout.itemSize = itemSize
        
        CustomCollectionViewGallery.sharedInstance.horizontalLayout.minimumLineSpacing = minLineSpacing
        CustomCollectionViewGallery.sharedInstance.horizontalLayout.itemSize = itemSize
       
        self.isPagingEnabled = false
        self.decelerationRate = UIScrollViewDecelerationRateFast
        configureGallery()
    }
    
    private func configureGallery(){
        switch CustomCollectionViewGallery.sharedInstance.orientation {
        case .vertical:
            self.collectionViewLayout = CustomCollectionViewGallery.sharedInstance.verticalLayout
        case .horizontal:
            self.collectionViewLayout = CustomCollectionViewGallery.sharedInstance.horizontalLayout
            
        case .autoFixed:
            autoLayoutFixed()
            
        case .autoDynamic:
            CustomCollectionViewGallery.sharedInstance.orintationSupport = true
            autoLayoutFixed()
            
        }
        
    }
    /**
     flow based and inital aspect ratio
     */
    private func autoLayoutFixed(){
        if self.bounds.size.height > self.bounds.size.width {
            self.collectionViewLayout = CustomCollectionViewGallery.sharedInstance.verticalLayout
        }else {
            self.collectionViewLayout = CustomCollectionViewGallery.sharedInstance.horizontalLayout
        }
    }
    
    /**
     Changes orientation flow from Veertical to Horizontal and vice versa
     Default implementations is to be used in func willRotate, so it can change
     flow based on device orientation
     */
    public func changeOrientation(){
        guard CustomCollectionViewGallery.sharedInstance.orintationSupport else {return}
        print(self.bounds.size)
        if self.collectionViewLayout.isKind(of: VerticalFlowLayout.self) && self.bounds.size.height > self.bounds.size.width {
            UIView.animate(withDuration: 0.2) { () -> Void in
                self.collectionViewLayout.invalidateLayout()
                self.setCollectionViewLayout(CustomCollectionViewGallery.sharedInstance.horizontalLayout, animated: false)
            }
            
        } else if self.collectionViewLayout.isKind(of: HorizontalFlowLayout.self) && self.bounds.size.width > self.bounds.size.height {
            UIView.animate(withDuration: 0.2) { () -> Void in
                self.collectionViewLayout.invalidateLayout()
                self.setCollectionViewLayout(CustomCollectionViewGallery.sharedInstance.verticalLayout, animated: false)
            }
            
        }
    }
    
    /**
     use it only in scrollViewDidScroll delegate method call
     */
    open func recenterIfNeeded() {
        if self.collectionViewLayout.isKind(of: VerticalFlowLayout.self) {
            let layout = self.collectionViewLayout as! VerticalFlowLayout
            layout.recenterIfNeeded()
            
        } else if self.collectionViewLayout.isKind(of: HorizontalFlowLayout.self) {
            let layout = self.collectionViewLayout as! HorizontalFlowLayout
            layout.recenterIfNeeded()
            
        }
    }
}
