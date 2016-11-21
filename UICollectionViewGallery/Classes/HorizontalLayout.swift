import UIKit

open class LGHorizontalLinearFlowLayout: UICollectionViewFlowLayout {
    
    fileprivate var lastCollectionViewSize: CGSize = CGSize.zero
    open var scalingOffset: CGFloat = 110
    open var minimumScaleFactor: CGFloat = 0.5
    open var scaleItems: Bool = true
    
    static func configureLayout(_ collectionView: UICollectionView, itemSize: CGSize, minimumLineSpacing: CGFloat) -> LGHorizontalLinearFlowLayout {
        
        let layout = LGHorizontalLinearFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = minimumLineSpacing
        layout.itemSize = itemSize
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.collectionViewLayout = layout
        
        return layout
    }
    
    override open func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        
        if self.collectionView == nil {
            return
        }
        
        let currentCollectionViewSize = self.collectionView!.bounds.size
        
        if !currentCollectionViewSize.equalTo(self.lastCollectionViewSize) {
            self.configureInset()
            self.lastCollectionViewSize = currentCollectionViewSize
        }
    }
    
    fileprivate func configureInset() -> Void {
        if self.collectionView == nil {
            return
        }
        
        let inset = self.collectionView!.bounds.size.width / 2 - self.itemSize.width / 2
        self.collectionView!.contentInset = UIEdgeInsetsMake(0, inset, 0, inset)
        self.collectionView!.contentOffset = CGPoint(x: -inset, y: 0)
    }
    
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if self.collectionView == nil {
            return proposedContentOffset
        }
        
        let collectionViewSize = self.collectionView!.bounds.size
        let proposedRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionViewSize.width, height: collectionViewSize.height)
        
        let layoutAttributes = self.layoutAttributesForElements(in: proposedRect)
        
        if layoutAttributes == nil {
            return proposedContentOffset
        }
        
        var candidateAttributes: UICollectionViewLayoutAttributes?
        let proposedContentOffsetCenterX = proposedContentOffset.x + collectionViewSize.width / 2
        
        for attributes: UICollectionViewLayoutAttributes in layoutAttributes! {
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
        
        if candidateAttributes == nil {
            return proposedContentOffset
        }
        
        var newOffsetX = candidateAttributes!.center.x - self.collectionView!.bounds.size.width / 2
        
        let offset = newOffsetX - self.collectionView!.contentOffset.x
        
        if (velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0) {
            let pageWidth = self.itemSize.width + self.minimumLineSpacing
            newOffsetX += velocity.x > 0 ? pageWidth : -pageWidth
        }
        print(CGPoint(x: newOffsetX, y: proposedContentOffset.y))
  print(collectionView?.contentOffset.x)

        if newOffsetX > 1870 {newOffsetX = 0}
        if newOffsetX < -200 {newOffsetX = 1856}
        return CGPoint(x: newOffsetX, y: proposedContentOffset.y)
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if !self.scaleItems || self.collectionView == nil {
            return super.layoutAttributesForElements(in: rect)
        }
        
        let superAttributes = super.layoutAttributesForElements(in: rect)
        
        if superAttributes == nil {
            return nil
        }
        
        let contentOffset = self.collectionView!.contentOffset
        let size = self.collectionView!.bounds.size
        
        let visibleRect = CGRect(x: contentOffset.x, y: contentOffset.y, width: size.width, height: size.height)
        let visibleCenterX = visibleRect.midX
        
        var newAttributesArray = Array<UICollectionViewLayoutAttributes>()
        for (_, attributes) in superAttributes!.enumerated() {
            let newAttributes = attributes.copy() as! UICollectionViewLayoutAttributes
            newAttributesArray.append(newAttributes)
            let distanceFromCenter = visibleCenterX - newAttributes.center.x
            let absDistanceFromCenter = min(abs(distanceFromCenter), self.scalingOffset)
            let scale = absDistanceFromCenter * (self.minimumScaleFactor - 1) / self.scalingOffset + 1
            newAttributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
            
        }
        
        return newAttributesArray;
    }
    
//    var position: CGFloat = rect.origin.x / collectionViewContentSize.width
//    var rectPosition: CGFloat = position - trunc(position)
//    var modifiedRect = CGRect(x: CGFloat(rectPosition * collectionViewContentSize.width), y: CGFloat(rect.origin.y), width: CGFloat(rect.size.width), height: CGFloat(rect.size.height))
//    
//    var secondRect = CGRect.zero
//    
//    if modifiedRect.maxX > collectionViewContentSize.width {
//    secondRect = CGRect(x: CGFloat(0), y: CGFloat(rect.origin.y), width: CGFloat(modifiedRect.maxX - collectionViewContentSize.width), height: CGFloat(rect.size.height))
//    modifiedRect.size.width = collectionViewContentSize.width - modifiedRect.origin.x
//    }
//    var attributes = self.newAttributes(for: modifiedRect, offset: trunc(position) * collectionViewContentSize.width)
//    var attributes2 = self.newAttributes(for: secondRect, offset: (trunc(position) + 1) * collectionViewContentSize.width)
//    var isResult = attributes + attributes2
//    
//    return isResult as![UICollectionViewLayoutAttributes]
//}
//
//override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
//    return super.layoutAttributesForItem(at: indexPath)!
//}
//
//func newAttributes(for rect: CGRect, offset: CGFloat) -> [Any] {
//    var attributes = super.layoutAttributesForElements(in: rect)!
//    
//    return self.modifyLayoutAttributes(attributes, offset: offset)
//}
//
//func modifyLayoutAttributes(_ attributes: [UICollectionViewLayoutAttributes], offset: CGFloat) -> [Any] {
//    var isResult = [Any]()
//    for attr in attributes {
//        var newAttr = attr
//        newAttr.center = CGPoint(x: CGFloat(attr.center.x + offset), y: CGFloat(attr.center.y))
//        isResult.append(newAttr)
//    }
//    return isResult
//}
////
////
//
//
}
