//
//  CustomDestinationViewController.swift
//  KTCarousel
//
//  Created by Kevin Taniguchi on 6/13/16.
//  Copyright © 2016 Kevin Taniguchi. All rights reserved.
//

import UIKit
import KTCarousel

class CustomDestinationViewController: BaseDestinationViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, KTCarouselTransitioning {
    
    var selectedCellForTransition: NonZoomingCustomLayoutCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        destinationCollectionView.register(NonZoomingCustomLayoutCollectionViewCell.self, forCellWithReuseIdentifier: "desCell")
        destinationCollectionView.frame = view.bounds
        destinationCollectionView.delegate = self
        destinationCollectionView.dataSource = self
        destinationCollectionView.frame = view.bounds
        view.addSubview(destinationCollectionView)
        destinationCollectionView.reloadData()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)
    }
    
    @objc func viewTapped() {
        guard let cell = destinationCollectionView.visibleCells.first as? NonZoomingCustomLayoutCollectionViewCell else { return }
        selectedCellForTransition = cell
        selectedPath = destinationCollectionView.indexPath(for: cell)
        dismissCallback?()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "desCell", for: indexPath) as? NonZoomingCustomLayoutCollectionViewCell else { return NonZoomingCustomLayoutCollectionViewCell() }
        
        cell.configure("Item: \((indexPath as NSIndexPath).item)", customImage: UIImage.testingImages()[(indexPath as NSIndexPath).item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 600)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exampleData.count
    }
    
    // MARK URBNSwCarouselTransitioning Delegate
    
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
        
        var targetRect = CGRect.zero
        
        if let protoTypeCell = destinationCollectionView.dequeueReusableCell(withReuseIdentifier: "desCell", for: IndexPath(item: 0, section: 0)) as? NonZoomingCustomLayoutCollectionViewCell {
            protoTypeCell.configure("Text", customImage: UIImage.testingImages()[0])
            protoTypeCell.layoutIfNeeded()
            targetRect = containerView.convert(protoTypeCell.imageView.frame, from: protoTypeCell)
        }
        
        let size = UIImageView.KT_aspectFitSizeForImageSize(sourceImageFrame.size, rect: targetRect)
        let originX = targetRect.midX - size.width/2
        let originY = targetRect.midY - size.height/2
        let frame = CGRect(x: originX, y: originY, width: targetRect.width, height: targetRect.height)
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

