import UIKit

open class VerticalLinearFlowLayout: UICollectionViewFlowLayout {
    
    fileprivate var lastCollectionViewSize: CGSize = CGSize.zero
    open var scalingOffset: CGFloat = 110
    open var minimumScaleFactor: CGFloat = 0.5
    open var scaleItems: Bool = true
    
    static func configureLayout(_ collectionView: UICollectionView, itemSize: CGSize, minimumLineSpacing: CGFloat) -> VerticalLinearFlowLayout {
        
        let layout = VerticalLinearFlowLayout()
        layout.scrollDirection = .vertical
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
        
        
        let proposedRect = CGRect(x: 0, y: proposedContentOffset.y, width: collectionViewSize.height, height: collectionViewSize.width) // news
        
        let layoutAttributes = self.layoutAttributesForElements(in: proposedRect)
        
        if layoutAttributes == nil {
            return proposedContentOffset
        }
        
        var candidateAttributes: UICollectionViewLayoutAttributes?
        let proposedContentOffsetCenterY = proposedContentOffset.y + collectionViewSize.height
        
        for attributes: UICollectionViewLayoutAttributes in layoutAttributes! {
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
        
        if candidateAttributes == nil {
            return proposedContentOffset
        }
        
        var newOffsetX = candidateAttributes!.center.y - self.collectionView!.bounds.size.height / 2
        let offset = newOffsetX - self.collectionView!.contentOffset.y
        
        if (velocity.y < 0 && offset > 0) || (velocity.y > 0 && offset < 0) {
            let pageWidth = self.itemSize.height + self.minimumLineSpacing
            newOffsetX += velocity.y > 0 ? pageWidth : -pageWidth
        }
        
        return CGPoint(x: proposedContentOffset.x, y: newOffsetX)
        
        
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
        let visibleCenterX = visibleRect.midY
        
        
        var newAttributesArray = Array<UICollectionViewLayoutAttributes>()
        for (_, attributes) in superAttributes!.enumerated() {
            let newAttributes = attributes.copy() as! UICollectionViewLayoutAttributes
            
            newAttributesArray.append(newAttributes)
            let distanceFromCenter = visibleCenterX - newAttributes.center.y
            let absDistanceFromCenter = min(abs(distanceFromCenter), self.scalingOffset)
            let scale = absDistanceFromCenter * (self.minimumScaleFactor - 1) / self.scalingOffset + 1
            newAttributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
            
        }
        return newAttributesArray;
    }
    
}
