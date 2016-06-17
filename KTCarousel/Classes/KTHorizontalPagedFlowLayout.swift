//
//  KTHorizontalPagedFlowLayout.swift
//  Pods
//
//  Created by Kevin Taniguchi on 6/13/16.
//
//

public class KTHorizontalPagedFlowLayout: UICollectionViewFlowLayout {
    
    private var minContentOffset: CGFloat {
        guard let cv = collectionView else { return 0.0 }
        return -cv.contentInset.left
    }
    
    private var maxContentOffset: CGFloat {
        guard let cv = collectionView else { return UIScreen.mainScreen().bounds.width }
        return minContentOffset + cv.contentSize.width - itemSize.width
    }
    
    private var snapStep: CGFloat {
        return itemSize.width + minimumLineSpacing
    }
    
    //    This offsets the cell's image so that a full image is shown on the left of the collectionview
    //    Modified from: http://stackoverflow.com/questions/13492037/targetcontentoffsetforproposedcontentoffsetwithscrollingvelocity-without-subcla
    override public func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let cv = collectionView else { return CGPointZero }
        var offSetAdjustment = CGFloat.max
        var proposedOffSet = proposedContentOffset
        let targetRect = CGRectMake(proposedContentOffset.x, 0.0, cv.bounds.width, cv.bounds.height)
        
        guard let unwrappedAttr = layoutAttributesForElementsInRect(targetRect) else { return CGPointZero }
        
        // TODO Replace this with a better convenience method first(where:) when swift 3 comes out
        let attr = unwrappedAttr.filter{ $0.representedElementCategory == UICollectionElementCategory.Cell }.first
        if let attribute = attr {
            let itemOriginX = attribute.frame.origin.x
            if abs(itemOriginX - proposedContentOffset.x) < abs(offSetAdjustment) {
                offSetAdjustment = itemOriginX - proposedContentOffset.x
            }
        }
        
        var nextOffSet: CGFloat = proposedContentOffset.x + offSetAdjustment - sectionInset.left
        
        repeat {
            proposedOffSet.x = nextOffSet
            let deltaX = proposedContentOffset.x - cv.contentOffset.x
            let velX = velocity.x
            
            if deltaX == 0.0 || velX == 0.0 || (velX > 0.0 && deltaX > 0.0) || (velX < 0 && deltaX < 0.0) {
                break
            }
            
            if velX > 0.0 {
                nextOffSet += snapStep
            }
            else {
                nextOffSet -= snapStep
            }
            
        } while isValidOffset(nextOffSet)
        
        proposedOffSet.y = 0.0
        return proposedOffSet
    }
    
    func isValidOffset(offSet: CGFloat) -> Bool {
        return offSet >= minContentOffset && offSet <= maxContentOffset
    }
    
}