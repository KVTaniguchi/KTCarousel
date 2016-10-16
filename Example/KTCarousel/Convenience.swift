//
//  Convenience.swift
//  KTCarousel
//
//  Created by Kevin Taniguchi on 6/13/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import QuartzCore

extension UIColor {
    static var colors: [UIColor] {
        return [UIColor.red, UIColor.orange, UIColor.purple, UIColor.cyan, UIColor.blue, UIColor.green, UIColor.yellow]
    }
    
    static func colorForIndex(_ index: Int) -> UIColor {
        return colors[index]
    }
}

extension UIImage {
    static func imageFromView(_ view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0);
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    static func testingImages() -> [UIImage] {
        var data = [UIImage]()
        for index in 0...6 {
            let lbl = UILabel()
            lbl.font = UIFont(name: "Avenir", size: 120)
            lbl.text = "\(index)"
            lbl.backgroundColor = UIColor.colors[index]
            lbl.sizeToFit()
            if let image = UIImage.imageFromView(lbl) {
                data.append(image)
            }
        }
        
        return data
    }
}
