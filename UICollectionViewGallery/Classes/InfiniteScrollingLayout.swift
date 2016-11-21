//
//  InfiniteScrollingLayout.swift
//  Pods
//
//  Created by Paulina Simeonova on 11/21/16.
//
//

import UIKit

let MIN_NUMBER_OF_ITEMS_REQUIRED = 6

open class InfiniteHorizontalLayout2: UICollectionViewFlowLayout {
    var collectionViewOriginalSize = CGSize.zero
    var used = false
    func preferredContentOffsetForElement(at index: Int) -> CGPoint {
        
        
        var numberOfItems = self.collectionView?.numberOfItems(inSection: 0)
        if numberOfItems == 0 {
            return CGPoint(x: CGFloat(0), y: CGFloat(0))
        }
      
        var value: CGFloat = (self.itemSize.width + self.minimumLineSpacing) * CGFloat(index)
        
        if used {
            value += trunc(self.itemSize.width / 2) * collectionViewOriginalSize.width
        }
        return CGPoint(x: CGFloat(value - self.collectionView!.contentInset.left), y: CGFloat(self.collectionView!.contentOffset.y))
    }
    
   open func recenterIfNeeded() {
        if used {
            var page: CGFloat = self.collectionView!.contentOffset.x / collectionViewOriginalSize.width
            var residue: CGFloat = (self.collectionView!.contentOffset.x - trunc(page) * collectionViewOriginalSize.width) / collectionViewOriginalSize.width
            if residue >= 0.0 && residue <= 0.0002 && page >= self.itemSize.width / 2 + 40 {
                self.collectionView!.contentOffset = self.preferredContentOffsetForElement(at: 0)
            }
            if page < 1.0 {
                self.collectionView!.contentOffset = self.preferredContentOffsetForElement(at: 0)
            }
        }
}
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override open func prepare() {
        assert(self.collectionView!.numberOfSections <= 1, "You cannot use InfiniteLayout with more than 2 sections")
        self.used = self.collectionView!.numberOfItems(inSection: 0) >= MIN_NUMBER_OF_ITEMS_REQUIRED
        self.scrollDirection = .horizontal
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, self.minimumLineSpacing)
        self.collectionView!.showsHorizontalScrollIndicator = false
        self.collectionView!.showsVerticalScrollIndicator = false
        super.prepare()
        self.collectionViewOriginalSize = super.collectionViewContentSize
    }
    
    
    
    override open var collectionViewContentSize: CGSize {
        var size: CGSize
        if used {
            size = CGSize(width: CGFloat(collectionViewOriginalSize.width * self.itemSize.width), height: CGFloat(collectionViewOriginalSize.height))
        }
        else {
            size = collectionViewOriginalSize
        }
        print("\(size.width)")
        return size
    }
    
    
    func layoutAttributesForElements(in rect: CGRect) -> [Any] {
        if used == false {
            return super.layoutAttributesForElements(in: rect)!
        }
        var position: CGFloat = rect.origin.x / collectionViewContentSize.width
            var rectPosition: CGFloat = position - trunc(position)
            var modifiedRect = CGRect(x: CGFloat(rectPosition * collectionViewContentSize.width), y: CGFloat(rect.origin.y), width: CGFloat(rect.size.width), height: CGFloat(rect.size.height))
        
            var secondRect = CGRect.zero
        
            if modifiedRect.maxX > collectionViewContentSize.width {
            secondRect = CGRect(x: CGFloat(0), y: CGFloat(rect.origin.y), width: CGFloat(modifiedRect.maxX - collectionViewContentSize.width), height: CGFloat(rect.size.height))
            modifiedRect.size.width = collectionViewContentSize.width - modifiedRect.origin.x
            }
            var attributes = self.newAttributes(for: modifiedRect, offset: trunc(position) * collectionViewContentSize.width)
            var attributes2 = self.newAttributes(for: secondRect, offset: (trunc(position) + 1) * collectionViewContentSize.width)
            var isResult = attributes + attributes2
        
            return isResult as![UICollectionViewLayoutAttributes]
        }
        
        override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
            return super.layoutAttributesForItem(at: indexPath)!
        }
        
        func newAttributes(for rect: CGRect, offset: CGFloat) -> [Any] {
            var attributes = super.layoutAttributesForElements(in: rect)!
        
            return self.modifyLayoutAttributes(attributes, offset: offset)
        }
        
        func modifyLayoutAttributes(_ attributes: [UICollectionViewLayoutAttributes], offset: CGFloat) -> [Any] {
            var isResult = [Any]()
            for attr in attributes {
                var newAttr = attr
                newAttr.center = CGPoint(x: CGFloat(attr.center.x + offset), y: CGFloat(attr.center.y))
                isResult.append(newAttr)
            }
            return isResult
    
    }
    
}

