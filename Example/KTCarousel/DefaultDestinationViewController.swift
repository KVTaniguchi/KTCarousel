//
//  DefaultDestinationViewController.swift
//  KTCarousel
//
//  Created by Kevin Taniguchi on 6/16/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import KTCarousel

/*
 This is an example class for a larger, "zoomed out" version of the image tapped in the source view controller.
 */

class DefaultDestinationViewController: BaseDestinationViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, KTCarouselTransitioning {
    
    var selectedCellForTransition: KTCarouselZoomableCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        destinationCollectionView.register(KTCarouselZoomableCell.self, forCellWithReuseIdentifier: "desCell")
        destinationCollectionView.delegate = self
        destinationCollectionView.dataSource = self
        destinationCollectionView.frame = view.bounds
        view.addSubview(destinationCollectionView)
        destinationCollectionView.reloadData()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)
    }
    
    @objc func viewTapped() {
        guard let cell = destinationCollectionView.visibleCells.first as? KTCarouselZoomableCell else { return }
        selectedCellForTransition = cell
        selectedPath = destinationCollectionView.indexPath(for: cell)
        dismissCallback?()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exampleData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "desCell", for: indexPath) as? KTCarouselZoomableCell else { return KTCarouselZoomableCell() }
        cell.imageView.image = UIImage.testingImages()[(indexPath as NSIndexPath).item]
        cell.scrollView.isUserInteractionEnabled = true
        return cell
    }
    
    // MARK KTSwCarouselTransitioning Delegate
    
    /*
     Required methods for transitioning
     */
    func imageForGalleryTransition() -> UIImage? {
        guard let img = selectedCellForTransition?.imageView.image else { return nil }
        return img
    }
    
    /*
     This is called when the destination view controller is being presented.  Here we are specifying the frame of the image we want to zoom out to.
     */
    func toImageFrameForGalleryTransitionWithContainerView(_ containerView: UIView, sourceImageFrame: CGRect) -> CGRect {
        let size = UIImageView.KT_aspectFitSizeForImageSize(sourceImageFrame.size, rect: view.bounds)
        let originX = view.bounds.midX - size.width/2
        let originY = view.bounds.midY - size.height/2
        let frame = CGRect(x: originX, y: originY, width: size.width, height: size.height)
        return frame
    }
    
    /*
     This is called when the destination view controller is being dismissed.  here we are specifying the frame of the image we are zooming from.
     */
    func fromImageFrameForGalleryTransitionWithContainerView(_ containerView: UIView) -> CGRect {
        guard let cell = selectedCellForTransition, let img = selectedCellForTransition?.imageView, let imgSize = img.image?.size else { return CGRect.zero }
        let size = UIImageView.KT_aspectFitSizeForImageSize(imgSize , rect: img.frame)
        var frame = cell.frame
        frame.origin.x = 0
        frame.origin.y = 0
        let originX = frame.midX - size.width/2
        let originY = frame.midY - size.height/2
        let xframe = CGRect(x: originX, y: originY, width: size.width, height: size.height)
        return xframe
    }
}
