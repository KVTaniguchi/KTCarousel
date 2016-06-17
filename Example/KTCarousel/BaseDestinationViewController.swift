//
//  BaseDestinationViewController.swift
//  KTCarousel
//
//  Created by Kevin Taniguchi on 6/13/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import KTCarousel

class BaseDestinationViewController: UIViewController, KTSynchronizingDelegate {
    let destinationCollectionView: UICollectionView
    var exampleData = UIImage.testingImages()
    var selectedPath: NSIndexPath?
    var dismissCallback: (Void -> Void)?
    
    init() {
        let layout = KTHorizontalPagedFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
        
        destinationCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK Sync Delegate
    func sourceIndexPath() -> NSIndexPath? {
        guard let path = selectedPath else { return NSIndexPath(forItem: 0, inSection: 0) }
        return path
    }
    
    func toCollectionView() -> UICollectionView? {
        return destinationCollectionView
    }
}