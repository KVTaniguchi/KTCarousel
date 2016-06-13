//
//  UIImage+ImageFrame.swift
//  Pods
//
//  Created by Kevin Taniguchi on 6/13/16.
//
//

import Foundation

public extension UIImageView {
    static func KT_aspectFitSizeForImageSize(imageSize: CGSize, rect: CGRect) -> CGSize {
        let hfactor = imageSize.width / rect.width
        let vfactor = imageSize.height / rect.height
        
        let factor = fmax(hfactor, vfactor)
        
        let newW = imageSize.width / factor
        let newH = imageSize.height / factor
        
        return CGSizeMake(newW, newH)
    }
    
    func KT_imageFrame() -> CGRect {
        guard let img = image else { return CGRectZero }
        let imgSize = img.size
        let frameSize = frame.size
        
        var resultFrame = CGRectZero
        
        let imageSmallerThanFrame = imgSize.width < frameSize.width && imgSize.height < frameSize.height
        
        if imageSmallerThanFrame {
            resultFrame.size = imgSize
        }
        else {
            let widthRatio = imgSize.width / frameSize.width
            let heightRatio = imgSize.height / frameSize.height
            let maxRatio = max(widthRatio, heightRatio)
            
            resultFrame.size = CGSizeMake(round(imgSize.width / maxRatio), round(imgSize.height / maxRatio))
        }
        
        resultFrame.origin = CGPointMake(round(center.x - resultFrame.size.width / 2), round(center.y - resultFrame.size.height / 2))
        return resultFrame
    }
}