//
//  KTZoomableCollectionViewCell.swift
//  Pods
//
//  Created by Kevin Taniguchi on 6/13/16.
//
//

import UIKit

/**
 
 This subclass of UICollectionViewCell has a zoomable UIImageView on top of a scrollView.
 
 */
open class KTCarouselZoomableCell: UICollectionViewCell, UIScrollViewDelegate {
    public let scrollView = UIScrollView()
    public let imageView = UIImageView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView.isUserInteractionEnabled = false
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 1.0
        scrollView.zoomScale = 1.0
        scrollView.delegate = self
        
        scrollView.setZoomScale(1.0, animated: true)
        contentView.frame = bounds
        scrollView.frame = contentView.bounds
        imageView.frame = contentView.bounds
        scrollView.contentSize = imageView.bounds.size
        
        contentView.addSubview(scrollView)
        
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KTCarouselZoomableCell {
    // MARK: UIScrollView Delegate
    @objc(viewForZoomingInScrollView:) public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @objc(scrollViewDidEndZooming:withView:atScale:) public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        guard let imgView = view else { return }
        UIView.animate(withDuration: 0.2, animations: {
            imgView.center = CGPoint(x: scrollView.bounds.size.width / 2 * scale, y: scrollView.bounds.size.height/2 * scale)
        }) 
    }
}
