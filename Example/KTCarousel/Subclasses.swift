//
//  Subclasses.swift
//  KTCarousel
//
//  Created by Kevin Taniguchi on 6/13/16.
//  Copyright © 2016 Kevin Taniguchi. All rights reserved.
//

import UIKit
import KTCarousel

class SampleCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let sourceCV: UICollectionView
    let data = UIImage.testingImages()
    var cellSelectedCallback: ((KTCarouselZoomableCell) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = KTHorizontalPagedFlowLayout()
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 249)
        sourceCV = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        sourceCV.translatesAutoresizingMaskIntoConstraints = false
        sourceCV.delegate = self
        sourceCV.dataSource = self
        sourceCV.register(KTCarouselZoomableCell.self, forCellWithReuseIdentifier: "URBNCarouselZoomableCell")
        contentView.addSubview(sourceCV)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[cv]|", options: [], metrics: nil, views: ["cv": sourceCV]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[cv]|", options: [], metrics: nil, views: ["cv": sourceCV]))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "URBNCarouselZoomableCell", for: indexPath) as? KTCarouselZoomableCell else { return KTCarouselZoomableCell() }
        cell.imageView.image = UIImage.testingImages()[(indexPath as NSIndexPath).item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? KTCarouselZoomableCell else { return }
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
        
        let views = ["imageView": imageView, "customLabel": customLabel] as [String : Any]
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        contentView.addSubview(customLabel)
        
        imageView.contentMode = .scaleToFill
        customLabel.textAlignment = .center
        customLabel.textColor = UIColor.white
        let metrics = ["imgSide": imgSide]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView(410)]-30-[customLabel]|", options: [.alignAllCenterX], metrics: metrics, views: views))
        imageView.widthAnchor.constraint(equalToConstant: imgSide).isActive = true
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    func configure(_ customText: String, customImage: UIImage) {
        customLabel.text = customText
        imageView.image = customImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

