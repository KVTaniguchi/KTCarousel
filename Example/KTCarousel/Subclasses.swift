//
//  Subclasses.swift
//  KTCarousel
//
//  Created by Kevin Taniguchi on 6/13/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import KTCarousel

class SampleCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let sourceCV: UICollectionView
    let data = UIImage.testingImages()
    var cellSelectedCallback: (KTCarouselZoomableCell -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        let layout = KTHorizontalPagedFlowLayout()
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSizeMake(150, 249)
        sourceCV = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        sourceCV.translatesAutoresizingMaskIntoConstraints = false
        sourceCV.delegate = self
        sourceCV.dataSource = self
        sourceCV.registerClass(KTCarouselZoomableCell.self, forCellWithReuseIdentifier: "URBNCarouselZoomableCell")
        contentView.addSubview(sourceCV)
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[cv]|", options: [], metrics: nil, views: ["cv": sourceCV]))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[cv]|", options: [], metrics: nil, views: ["cv": sourceCV]))
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("URBNCarouselZoomableCell", forIndexPath: indexPath) as? KTCarouselZoomableCell else { return KTCarouselZoomableCell() }
        cell.imageView.image = UIImage.testingImages()[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? KTCarouselZoomableCell else { return }
        cellSelectedCallback?(cell)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NonZoomingCustomLayoutCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    let customLabel = UILabel()
    let imgSide: CGFloat = 167
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let views = ["imageView": imageView, "customLabel": customLabel]
        
        for view in views.values {
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
        }
        
        imageView.contentMode = .ScaleToFill
        customLabel.textAlignment = .Center
        customLabel.textColor = UIColor.whiteColor()
        let metrics = ["imgSide": imgSide]
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView(410)]-30-[customLabel]|", options: [.AlignAllCenterX], metrics: metrics, views: views))
        imageView.widthAnchor.constraintEqualToConstant(imgSide).active = true
        imageView.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor).active = true
    }
    
    func configure(customText: String, customImage: UIImage) {
        customLabel.text = customText
        imageView.image = customImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
