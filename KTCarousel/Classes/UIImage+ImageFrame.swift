//
//  UIImage+ImageFrame.swift
//  Pods
//
//  Created by Kevin Taniguchi on 6/13/16.
//
//

import Foundation

public extension UIImageView {
    static func KT_aspectFitSizeForImageSize(_ imageSize: CGSize, rect: CGRect) -> CGSize {
        let hfactor = imageSize.width / rect.width
        let vfactor = imageSize.height / rect.height
        
        let factor = fmax(hfactor, vfactor)
        
        let newW = imageSize.width / factor
        let newH = imageSize.height / factor
        
        return CGSize(width: newW, height: newH)
    }
    
    func KT_imageFrame() -> CGRect {
        guard let img = image else { return CGRect.zero }
        let imgSize = img.size
        let frameSize = frame.size
        
        var resultFrame = CGRect.zero
        
        let imageSmallerThanFrame = imgSize.width < frameSize.width && imgSize.height < frameSize.height
        
        if imageSmallerThanFrame {
            resultFrame.size = imgSize
        }
        else {
            let widthRatio = imgSize.width / frameSize.width
            let heightRatio = imgSize.height / frameSize.height
            let maxRatio = max(widthRatio, heightRatio)
            
            resultFrame.size = CGSize(width: round(imgSize.width / maxRatio), height: round(imgSize.height / maxRatio))
        }
        
        resultFrame.origin = CGPoint(x: round(center.x - resultFrame.size.width / 2), y: round(center.y - resultFrame.size.height / 2))
        return resultFrame
    }
}
