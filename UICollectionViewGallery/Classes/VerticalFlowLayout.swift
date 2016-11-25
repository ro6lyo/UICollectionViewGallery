//
//  File.swift
//  Pods
//
//  Created by Mehmed Kadir on 11/22/16.
//
//

import UIKit

open class VerticalFlowLayout: UICollectionViewFlowLayout {
    
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
        self.scrollDirection = .vertical
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, self.minimumLineSpacing)
        self.collectionView!.showsHorizontalScrollIndicator = false
        self.collectionView!.showsVerticalScrollIndicator = false
        super.prepare()
        self.collectionViewOriginalSize = super.collectionViewContentSize
    }
    
    override open var collectionViewContentSize: CGSize {
        guard used && inifiniteScroll else {return collectionViewOriginalSize}
        
        return CGSize(width: collectionViewOriginalSize.width, height: collectionViewOriginalSize.height * self.itemSize.height)
    }
    
    
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collection = self.collectionView else {return proposedContentOffset}
        
        let collectionViewSize = collection.bounds.size
        let proposedRect = CGRect(x: 0, y: proposedContentOffset.y, width: collectionViewSize.height, height: collectionViewSize.width)
        
        guard let layoutAttributes = self.layoutAttributesForElements(in: proposedRect) else {return proposedContentOffset}
        
        var candidateAttributes: UICollectionViewLayoutAttributes?
        let proposedContentOffsetCenterY = proposedContentOffset.y + collectionViewSize.height / 2
        
        for attributes: UICollectionViewLayoutAttributes in layoutAttributes {
            
            if attributes.representedElementCategory != .cell {
                continue
            }
            
            if candidateAttributes == nil {
                candidateAttributes = attributes
                continue
            }
            
            if fabs(attributes.center.y - proposedContentOffsetCenterY) < fabs(candidateAttributes!.center.y - proposedContentOffsetCenterY) {
               
                candidateAttributes = attributes
            }
        }
        guard (candidateAttributes != nil) else {return proposedContentOffset}
        
        
        var newOffsetX = candidateAttributes!.center.y - self.collectionView!.bounds.size.height / 2
        let offset = newOffsetX - self.collectionView!.contentOffset.y
        
        if (velocity.y < 0 && offset > 0) || (velocity.y > 0 && offset < 0) {
            let pageWidth = self.itemSize.height + self.minimumLineSpacing
            newOffsetX += velocity.y > 0 ? pageWidth : -pageWidth
        }
        return CGPoint(x: proposedContentOffset.x, y: newOffsetX)
    }
    
    
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard used  else {return super.layoutAttributesForElements(in: rect)!}

        let position = rect.origin.y / collectionViewOriginalSize.height
        let rectPosition = position - trunc(position)
        var modifiedRect = CGRect(x: rect.origin.x, y: rectPosition * collectionViewOriginalSize.height, width: rect.size.width, height: rect.size.height)
        var secondRect = CGRect.zero
        
        if modifiedRect.maxY > collectionViewOriginalSize.height {
            secondRect = CGRect(x: rect.origin.x, y: 0, width: rect.size.width, height: modifiedRect.maxY - collectionViewOriginalSize.height)
            modifiedRect.size.height = collectionViewOriginalSize.height - modifiedRect.origin.y
        }
        let attributes = self.newAttributes(for: modifiedRect, offset: trunc(position) * collectionViewOriginalSize.height)
        let attributes2 = self.newAttributes(for: secondRect, offset: (trunc(position) + 1) * collectionViewOriginalSize.height)
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
        let page = self.collectionView!.contentOffset.y / collectionViewOriginalSize.height
        let radius = (self.collectionView!.contentOffset.y - trunc(page) * collectionViewOriginalSize.height) / collectionViewOriginalSize.height
        if radius >= 0.0 && radius <= 0.0002 && page >= self.itemSize.width / 2 + 40 || page < 1.0 {
            return true
        }
        return false
    }
    
    private func preferredContentOffsetForElement(at index: Int) -> CGPoint {
        guard self.collectionView!.numberOfItems(inSection: 0) > 0 else { return CGPoint(x: CGFloat(0), y: CGFloat(0)) }
        
        if used && inifiniteScroll {
            return CGPoint(x:self.collectionView!.contentOffset.x, y:item(at: index)+tunc() - self.collectionView!.contentInset.bottom)
        }
        return CGPoint(x:self.collectionView!.contentOffset.x, y:item(at: index) - self.collectionView!.contentInset.bottom )
    }
    
    private func tunc()->CGFloat {
        return trunc(self.itemSize.height / 2) * collectionViewOriginalSize.height
    }
    
    private func item(at index: Int) -> CGFloat{
        return (self.itemSize.height + self.minimumLineSpacing) * CGFloat(index)
    }
    
   private func newAttributes(for rect: CGRect, offset: CGFloat) -> [UICollectionViewLayoutAttributes] {
        let attributes = super.layoutAttributesForElements(in: rect)
        return self.modifyLayoutAttributes(attributes!, offset: offset)
    }
    
   private func modifyLayoutAttributes(_ attributes: [UICollectionViewLayoutAttributes], offset: CGFloat) -> [UICollectionViewLayoutAttributes] {
        let contentOffset = self.collectionView!.contentOffset
        let size = self.collectionView!.bounds.size
        let visibleRect = CGRect(x: contentOffset.x, y: contentOffset.y, width: size.width, height: size.height)
    
    let mappedAttributes = attributes.flatMap({repositionAttributes(newAttr: $0,withOffset: offset,andCenter: visibleRect.midY)})
    return mappedAttributes

    }
    
    private func repositionAttributes(newAttr:UICollectionViewLayoutAttributes,withOffset offset:CGFloat,andCenter center:CGFloat) ->UICollectionViewLayoutAttributes {
    
        newAttr.center = CGPoint(x: newAttr.center.x , y: newAttr.center.y + offset)
        let absDistanceFromCenter = min(abs(center - newAttr.center.y), self.scalingOffset)

        guard scaleElements else {return newAttr}

        let scale = absDistanceFromCenter * (self.minimumScaleFactor - 1) / self.scalingOffset + 1
        newAttr.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        
        return newAttr
    }
    
}

