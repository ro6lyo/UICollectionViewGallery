//
//  InfiniteScrollingLayout.swift
//  Pods
//
//  Created by Mehmed Kadir on 11/21/16.
//
//

import UIKit

let MIN_NUMBER_OF_ITEMS_REQUIRED = 6

open class HorizontalFlowLayout: UICollectionViewFlowLayout {
    
    var collectionViewOriginalSize = CGSize.zero
    var used = false
    
    open var inifiniteScroll = true   //  can be changed based on requared behaviour
    open var scaleElements = true     //  can be changed based on requared behaviour
    
    open var scalingOffset: CGFloat = 110
    open var minimumScaleFactor: CGFloat = 0.5
    //MARK:-Open Functions
    public func recenterIfNeeded() {
        guard used && inifiniteScroll && isReachedEndOrBegining() else {return}
        self.collectionView!.contentOffset = self.preferredContentOffsetForElement(at: 0)
        
    }
    //
    //MARK:-Open overrides
    //
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override open func prepare() {
        
        assert(self.collectionView!.numberOfSections <= 1, "You cannot use UICollectionViewGallery with more than 2 sections")
        self.used = self.collectionView!.numberOfItems(inSection: 0) >= MIN_NUMBER_OF_ITEMS_REQUIRED
        self.scrollDirection = .horizontal
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, self.minimumLineSpacing)
        self.collectionView!.showsHorizontalScrollIndicator = false
        self.collectionView!.showsVerticalScrollIndicator = false
        super.prepare()
        self.collectionViewOriginalSize = super.collectionViewContentSize
    }
    /**
     increases the conted size of the collectionView for infinite scroll
     */
    override open var collectionViewContentSize: CGSize {
        guard used && inifiniteScroll else {return collectionViewOriginalSize}
        
        return CGSize(width: collectionViewOriginalSize.width * self.itemSize.width, height: collectionViewOriginalSize.height)
    }
    
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collection = self.collectionView else {return proposedContentOffset}

        
        let collectionViewSize = collection.bounds.size
        let proposedRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionViewSize.width, height: collectionViewSize.height)
        
        guard let layoutAttributes = self.layoutAttributesForElements(in: proposedRect) else {return proposedContentOffset}
        
        var candidateAttributes: UICollectionViewLayoutAttributes?
        let proposedContentOffsetCenterX = proposedContentOffset.x + collectionViewSize.width / 2
        
        for attributes: UICollectionViewLayoutAttributes in layoutAttributes {
            if attributes.representedElementCategory != .cell {
                continue
            }
            
            if candidateAttributes == nil {
                candidateAttributes = attributes
                continue
            }
            
            if fabs(attributes.center.x - proposedContentOffsetCenterX) < fabs(candidateAttributes!.center.x - proposedContentOffsetCenterX) {
                candidateAttributes = attributes
            }
        }
        
        guard (candidateAttributes != nil) else {return proposedContentOffset}

        var newOffsetX = candidateAttributes!.center.x - self.collectionView!.bounds.size.width / 2
        
        let offset = newOffsetX - self.collectionView!.contentOffset.x
        
        if (velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0) {
            let pageWidth = self.itemSize.width + self.minimumLineSpacing
            newOffsetX += velocity.x > 0 ? pageWidth : -pageWidth
        }
        return CGPoint(x: newOffsetX, y: proposedContentOffset.y)
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard used  else {return super.layoutAttributesForElements(in: rect)!}
        
       
        let position = rect.origin.x / collectionViewOriginalSize.width
        let rectPosition = position - trunc(position)
        var modifiedRect = CGRect(x: rectPosition * collectionViewOriginalSize.width, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
        var secondRect = CGRect.zero
        
        if modifiedRect.maxX > collectionViewOriginalSize.width {
            secondRect = CGRect(x: 0, y: rect.origin.y, width: modifiedRect.maxX - collectionViewOriginalSize.width, height: rect.size.height)
            modifiedRect.size.width = collectionViewOriginalSize.width - modifiedRect.origin.x
        }
        let attributes = self.newAttributes(for: modifiedRect, offset: trunc(position) * collectionViewOriginalSize.width)
        let attributes2 = self.newAttributes(for: secondRect, offset: (trunc(position) + 1) * collectionViewOriginalSize.width)
        guard inifiniteScroll else { return attributes}
        return attributes + attributes2
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        return super.layoutAttributesForItem(at: indexPath)!
    }
    //
    //MARK:-Private Function
    //
    /**
    Finds current scroll position
    returns true when it reaches end or begging of the scrollView
     */
    private func isReachedEndOrBegining()->Bool {
        let page = self.collectionView!.contentOffset.x / collectionViewOriginalSize.width
        let radius = (self.collectionView!.contentOffset.x - trunc(page) * collectionViewOriginalSize.width) / collectionViewOriginalSize.width
        if radius >= 0.0 && radius <= 0.0002 && page >= self.itemSize.width / 2 + 40 || page < 1.0 {
            return true
        }
        return false
    }
    /**
     */
    private  func preferredContentOffsetForElement(at index: Int) -> CGPoint {
        guard self.collectionView!.numberOfItems(inSection: 0) > 0 else { return CGPoint(x: CGFloat(0), y: CGFloat(0)) }
        
        var value = item(at: index)
        if used && inifiniteScroll {
            value += trunc(self.itemSize.width / 2) * collectionViewOriginalSize.width
        }
        return CGPoint(x:value - self.collectionView!.contentInset.left, y: self.collectionView!.contentOffset.y)
    }
    /**
     */
    private func item(at index: Int) -> CGFloat{
        return self.itemSize.width + (self.minimumLineSpacing * CGFloat(index))
    }
    /**
     */
    private  func newAttributes(for rect: CGRect, offset: CGFloat) -> [UICollectionViewLayoutAttributes] {
        let attributes = super.layoutAttributesForElements(in: rect)
        return self.modifyLayoutAttributes(attributes!, offset: offset)
    }
    /**
     */
    private func modifyLayoutAttributes(_ attributes: [UICollectionViewLayoutAttributes], offset: CGFloat) -> [UICollectionViewLayoutAttributes] {
        let contentOffset = self.collectionView!.contentOffset
        let size = self.collectionView!.bounds.size
        let visibleRect = CGRect(x: contentOffset.x, y: contentOffset.y, width: size.width, height: size.height)
        
        let mappedAttributes = attributes.flatMap({repositionAttributes(newAttr: $0,withOffset: offset,andCenter: visibleRect.midX)})
        return mappedAttributes
    }
    
    private func repositionAttributes(newAttr:UICollectionViewLayoutAttributes,withOffset offset:CGFloat,andCenter center:CGFloat) ->UICollectionViewLayoutAttributes {
        
        newAttr.center = CGPoint(x: newAttr.center.x + offset, y: newAttr.center.y)
        let absDistanceFromCenter = min(abs(center - newAttr.center.x), self.scalingOffset)
        
        guard scaleElements else {return newAttr}
        
        let scale = absDistanceFromCenter * (self.minimumScaleFactor - 1) / self.scalingOffset + 1
        newAttr.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        
        return newAttr
    }
}
