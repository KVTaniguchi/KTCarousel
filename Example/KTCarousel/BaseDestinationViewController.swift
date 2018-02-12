//
//  BaseDestinationViewController.swift
//  KTCarousel
//
//  Created by Kevin Taniguchi on 6/13/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import KTCarousel

typealias EmptyHandler = () -> Void

class BaseDestinationViewController: UIViewController, KTSynchronizingDelegate {
    let destinationCollectionView: UICollectionView
    var exampleData = UIImage.testingImages()
    var selectedPath: IndexPath?
    var dismissCallback: EmptyHandler?
    
    init() {
        let layout = KTHorizontalPagedFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
        
        destinationCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK Sync Delegate
    func sourceIndexPath() -> IndexPath? {
        guard let path = selectedPath else { return IndexPath(item: 0, section: 0) }
        return path
    }
    
    func toCollectionView() -> UICollectionView? {
        return destinationCollectionView
    }
}
