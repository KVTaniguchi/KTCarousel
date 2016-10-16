//
//  KTHorizontalPagedFlowLayout.swift
//  Pods
//
//  Created by Kevin Taniguchi on 6/13/16.
//
//

open class KTHorizontalPagedFlowLayout: UICollectionViewFlowLayout {
    
    fileprivate var minContentOffset: CGFloat {
        guard let cv = collectionView else { return 0.0 }
        return -cv.contentInset.left
    }
    
    fileprivate var maxContentOffset: CGFloat {
        guard let cv = collectionView else { return UIScreen.main.bounds.width }
        return minContentOffset + cv.contentSize.width - itemSize.width
    }
    
    fileprivate var snapStep: CGFloat {
        return itemSize.width + minimumLineSpacing
    }
    
    //    This offsets the cell's image so that a full image is shown on the left of the collectionview
    //    Modified from: http://stackoverflow.com/questions/13492037/targetcontentoffsetforproposedcontentoffsetwithscrollingvelocity-without-subcla
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let cv = collectionView else { return CGPoint.zero }
        var offSetAdjustment = CGFloat.greatestFiniteMagnitude
        var proposedOffSet = proposedContentOffset
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0.0, width: cv.bounds.width, height: cv.bounds.height)
        
        guard let unwrappedAttr = layoutAttributesForElements(in: targetRect) else { return CGPoint.zero }
        
        // TODO Replace this with a better convenience method first(where:) when swift 3 comes out
        let attr = unwrappedAttr.filter{ $0.representedElementCategory == UICollectionElementCategory.cell }.first
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
    
    func isValidOffset(_ offSet: CGFloat) -> Bool {
        return offSet >= minContentOffset && offSet <= maxContentOffset
    }
    
}
