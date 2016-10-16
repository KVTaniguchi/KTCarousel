//
//  KTCarouselTransitionController.swift
//  Pods
//
//  Created by Kevin Taniguchi on 6/13/16.
//
//

/**
 Animation controller built to handle transitions between two images in separate view controllers.
 By default, this class supports non-interactive transitions. To enable interactive transitions, register
 a view for them using the registration method provided.
 
 This class implements the UIViewControllerTransitioningDelegate protocol. As a consumer, you only need to implement
 the KTCarouselTransitioning protocol.
 
 For the time being, this controller only supports transitions between images.
 */


open class KTCarouselTransitionController: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    fileprivate weak var context: UIViewControllerContextTransitioning?
    fileprivate var transitionView = UIImageView()
    fileprivate var originalSelectedCellFrame = CGRect.zero
    fileprivate var springCompletionSpeed: CGFloat = 0.7
    fileprivate var sourceViewController: UIViewController?
    open var presentationController: KTPresentationController?
    fileprivate var isDismissing = false
    
    // MARK: UIViewControllerAnimatedTransitioning Delegate Methods - Non-Interactive
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from), let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {
                assertionFailure("Warning - transition context couldn't find view controllers..")
                return
        }
        
        let fromView = fromVC.view
        let toView = toVC.view
        toView?.alpha = 0.0
        
        guard let topToVC = trueContextViewControllerFromContext(transitionContext, key: UITransitionContextViewControllerKey.to.rawValue) as? KTCarouselTransitioning else {
            assertionFailure("Warning - couldn't find the true destination view controller.")
            return }
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: springCompletionSpeed, initialSpringVelocity: 0, options: [], animations: {
            fromView?.alpha = 0
            toView?.alpha = self.isDismissing ? 1.0 : 0.0
            if let vc = topToVC as? KTCarouselTransitioningImageView {
                vc.configureAnimatingTransitionImageView(self.transitionView)
            }
            
        }) { (finished) in
            toView?.alpha = 1.0
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    // MARK: UIViewControllerTransitioningDelegate methods
    open func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        presentationController = KTPresentationController(presentedViewController: presented, presenting: source)
        return presentationController
    }
    
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        sourceViewController = source
        isDismissing = false
        return self
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isDismissing = true
        return self
    }
    
    // MARK: Convenience
    /** This method finds the true view controller for a given context's key - sometimes iOS will pick the rootview controller or navigation controller of a presenting view controller. Override if necessary if you find you are having trouble accessing the correct view controllers as source or destination.
     */
    open func trueContextViewControllerFromContext(_ transitionContext: UIViewControllerContextTransitioning, key: String) -> UIViewController? {
        guard var vc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey(rawValue: key)) else {
            assertionFailure("Warning - passed in a bad key.")
            return nil
        }
        
        if let topVC = vc.navigationController?.topViewController {
            vc = topVC
        }
        else {
            guard let capturedVC = sourceViewController else {
                assertionFailure("Warning - A source view controller was not passed in.")
                return nil }
            vc = capturedVC
        }
        
        return vc
    }
    
}

