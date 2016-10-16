//
//  KTPresentationController.swift
//  Pods
//
//  Created by Kevin Taniguchi on 6/13/16.
//
//

import UIKit

/**
 This subclass of UIPresentationController manages the UIImageView that zooms in and out between the source and destination view controllers.
 It also handles synchonizaton of the collection views
 */

open class KTPresentationController: UIPresentationController {
    
    // MARK: Public Variables
    open var maskingNavBarColor: UIColor?
    
    // MARK: Private Variables
    fileprivate var transitionView = UIImageView()
    
    fileprivate let assertionWarningCarouselTransitioning = "Warning : make sure  all VC's being passed in conform to the KTCarouselTransitioning protocol"
    
    lazy fileprivate var navBarCoverView = UIView()
    
    fileprivate var topFromVC: KTCarouselTransitioning? {
        let nav = presentingViewController as? UINavigationController
        return nav?.topViewController as? KTCarouselTransitioning
    }
    
    fileprivate var navBarOfPresentingViewController: UIView? {
        guard let nav = presentingViewController as? UINavigationController else { return nil }
        let snapShotOfNavbar = nav.navigationBar.snapshotView(afterScreenUpdates: true)
        snapShotOfNavbar?.translatesAutoresizingMaskIntoConstraints = false
        return snapShotOfNavbar
    }
    
    // MARK: Public Overrides of UIPresentationController's view tracking methods
    override open func presentationTransitionWillBegin() {
        guard let destinationVC = presentedViewController as? KTCarouselTransitioning, let containingView = containerView, let transitionCoordinator = presentingViewController.transitionCoordinator
            else {
                assertionFailure(assertionWarningCarouselTransitioning)
                return
        }
        
        var sourceVC: KTCarouselTransitioning
        if let topVC = topFromVC {
            sourceVC = topVC
        }
        else {
            guard let vc = presentingViewController as? KTCarouselTransitioning else {
                assertionFailure(assertionWarningCarouselTransitioning)
                return
            }
            sourceVC = vc
        }
        
        let toView = presentedViewController.view
        
        toView?.frame = containingView.bounds
        toView?.setNeedsLayout()
        containingView.addSubview(toView!)
        
        setUpImageForTransition(sourceVC, destinationVC: destinationVC, containingView: containingView)
        synchronizeCollectionViews(sourceVC, destinationVC: destinationVC)
        
        transitionCoordinator.animate(alongsideTransition: { (context) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
                self.setFinalTransformForImage(sourceVC, destinationVC: destinationVC, containingView: containingView)
                }, completion: nil)
            }, completion: nil)
    }
    
    override open func presentationTransitionDidEnd(_ completed: Bool) {
        guard let sourceVC = topFromVC, let destinationVC = presentedViewController as? KTCarouselTransitioning, let containingView = containerView
            else {
                assertionFailure(assertionWarningCarouselTransitioning)
                return
        }
        exposeTransitionViewtoViewControllersIfNecessary(sourceVC, destinationVC: destinationVC)
        transitionView.removeFromSuperview()
    }
    
    override open func dismissalTransitionWillBegin() {
        guard let sourceVC = presentedViewController as? KTCarouselTransitioning, let destinationVC = topFromVC, let containingView = containerView, let transitionCoordinator = presentingViewController.transitionCoordinator else {
            assertionFailure(assertionWarningCarouselTransitioning)
            return
        }
        
        synchronizeCollectionViews(sourceVC, destinationVC: destinationVC)
        setUpImageForTransition(sourceVC, destinationVC: destinationVC, containingView: containingView)
        coverNavigationBarIfNecessary(containingView)
        
        transitionCoordinator.animate(alongsideTransition: { (context) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
                self.setFinalTransformForImage(sourceVC, destinationVC: destinationVC, containingView: containingView)
                }, completion: { (complete) in
                    if complete {
                        UIView.animate(withDuration: 0.2, animations: {
                            self.navBarCoverView.alpha = 0.0
                        })
                    }
            }   )
            }, completion: nil)
    }
    
    override open func dismissalTransitionDidEnd(_ completed: Bool) {
        guard let sourceVC = presentedViewController as? KTCarouselTransitioning, let destinationVC = topFromVC, let containingView = containerView else {
            assertionFailure(assertionWarningCarouselTransitioning)
            return
        }
        exposeTransitionViewtoViewControllersIfNecessary(sourceVC, destinationVC: destinationVC)
        transitionView.removeFromSuperview()
    }
    
    // MARK: Convenience
    /**
     *   These methods handle the image view that is animated during the zoom out / zoom transitions.
     */
    fileprivate func setUpImageForTransition(_ sourceVC: KTCarouselTransitioning, destinationVC: KTCarouselTransitioning, containingView: UIView) {
        let convertedStartingFrame = sourceVC.fromImageFrameForGalleryTransitionWithContainerView(containingView)
        let convertedEndingFrame = destinationVC.toImageFrameForGalleryTransitionWithContainerView(containingView, sourceImageFrame: convertedStartingFrame)
        
        // Set the view's frame to the final dimensions and transform it down to match starting dimensions.
        transitionView = UIImageView(frame: convertedEndingFrame)
        transitionView.contentMode = .scaleToFill
        
        guard let img = sourceVC.imageForGalleryTransition() else {
            assertionFailure("Your sourceVC must supply an image through this protocol")
            return
        }
        
        transitionView.image = img
        
        let scaleX = convertedStartingFrame.width / convertedEndingFrame.width
        let scaleY = convertedStartingFrame.height / convertedEndingFrame.height
        
        let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        transitionView.transform = transform
        transitionView.center = CGPoint(x: convertedStartingFrame.midX, y: convertedStartingFrame.midY)
        
        containingView.addSubview(transitionView)
    }
    
    fileprivate func setFinalTransformForImage(_ sourceVC: KTCarouselTransitioning, destinationVC: KTCarouselTransitioning, containingView: UIView) {
        let convertedStartingFrame = sourceVC.fromImageFrameForGalleryTransitionWithContainerView(containingView)
        let convertedEndingFrame = destinationVC.toImageFrameForGalleryTransitionWithContainerView(containingView, sourceImageFrame: convertedStartingFrame)
        
        var center = CGPoint()
        var transForm = CGAffineTransform()
        
        transForm = CGAffineTransform.identity
        center = CGPoint(x: convertedEndingFrame.midX, y: convertedEndingFrame.midY)
        
        // TODO REMOVE: THIS IS FOR DEBUGGING AND TESTING ONLY
        transitionView.layer.borderColor = UIColor.green.cgColor
        transitionView.layer.borderWidth = 10.0
        
        transitionView.center = center
        transitionView.transform = transForm
    }
    
    /**
     *    This method syncs the cells between collection views by taking in the index path of the cell selected for zooming.
     *    That index path is sent to the destination collection view which scrolls to that index path.
     */
    fileprivate func synchronizeCollectionViews(_ sourceVC: KTCarouselTransitioning, destinationVC: KTCarouselTransitioning) {
        guard let destSyncVC = destinationVC as? KTSynchronizingDelegate, let sourceSyncVC = sourceVC as? KTSynchronizingDelegate, let path = sourceSyncVC.sourceIndexPath(), let cv = destSyncVC.toCollectionView() else {
            assertionFailure(assertionWarningCarouselTransitioning)
            return }
        
        cv.scrollToItem(at: path as IndexPath, at: UICollectionViewScrollPosition(), animated: false)
        cv.reloadItems(at: [path as IndexPath])
        if let cell = cv.cellForItem(at: path as IndexPath) as? KTCarouselZoomableCell {
            destSyncVC.updateSourceSelectedCell?(cell)
        }
    }
    
    /**
     *    Sometimes the presentingViewController will be the navigation controller of the presenting view controller.
     *    If the selected collectionViewCell is underneath the navigation bar at the time of animation, upon return it will overlay the navigation bar.
     *     We get a screen shot of the navigation bar and use it as part of the animation transition so that the animating image view goes behind it.
     */
    fileprivate func coverNavigationBarIfNecessary(_ containingView: UIView) {
        guard let navBar = navBarOfPresentingViewController, let nav = presentingViewController as? UINavigationController else {
            assertionFailure(assertionWarningCarouselTransitioning)
            return }
        let rect = nav.view.convert(nav.navigationBar.frame, to: nil)
        if let color = maskingNavBarColor {
            navBar.backgroundColor = color
        }
        else {
            navBar.backgroundColor = UIColor.white
        }
        navBar.frame = rect
        navBarCoverView.addSubview(navBar)
        navBarCoverView.translatesAutoresizingMaskIntoConstraints = false
        containingView.addSubview(navBarCoverView)
        navBarCoverView.backgroundColor = UIColor.white
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[cover]|", options: [], metrics: nil, views: ["cover": navBarCoverView]))
        navBarCoverView.topAnchor.constraint(equalTo: containingView.topAnchor).isActive = true
        navBarCoverView.heightAnchor.constraint(equalToConstant: 20 + rect.height).isActive = true
    }
    
    /*
     Convenience
     */
    fileprivate func exposeTransitionViewtoViewControllersIfNecessary(_ sourceVC: KTCarouselTransitioning, destinationVC: KTCarouselTransitioning) {
        guard let svc = sourceVC as? KTCarouselTransitioningImageView, let dvc = destinationVC as? KTCarouselTransitioningImageView else {
            return }
        svc.willBeginGalleryTransitionWithImageView(transitionView, isToVC: false)
        dvc.willBeginGalleryTransitionWithImageView(transitionView, isToVC: true)
    }
}

