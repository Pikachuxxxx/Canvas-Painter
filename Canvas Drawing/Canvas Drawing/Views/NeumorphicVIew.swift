//
//  NeumorphicVIew.swift
//  Canvas Drawing
//
//  Created by phani srikar on 19/06/20.
//  Copyright © 2020 phani srikar. All rights reserved.
//

import UIKit

class NeumorphicVIew: UIView {


    override init(frame: CGRect) {
        super.init(frame:frame)

        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.offWhite.cgColor
//      (red: 0.8823529412, green: 0.8823529412, blue: 0.9215686275, alpha: 1)
        let cornerRadius: CGFloat = 25
        let shadowRadius: CGFloat = 7

        let darkShadow = CALayer()
        darkShadow.frame = bounds
        darkShadow.backgroundColor = backgroundColor?.cgColor
        darkShadow.shadowColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.3).cgColor
        darkShadow.cornerRadius = cornerRadius
        darkShadow.shadowOffset = CGSize(width: 5, height: 5)
        darkShadow.shadowOpacity = 1
        darkShadow.shadowRadius = shadowRadius
        self.layer.insertSublayer(darkShadow, at: 0)

        let lightShadow = CALayer()
        lightShadow.frame = bounds
        lightShadow.backgroundColor = backgroundColor?.cgColor
        lightShadow.shadowColor = UIColor.white.cgColor
        lightShadow.cornerRadius = cornerRadius
        lightShadow.shadowOffset = CGSize(width: -5, height: -5)
        lightShadow.shadowOpacity = 0.9
        lightShadow.shadowRadius = shadowRadius
        self.layer.insertSublayer(lightShadow, at: 0)

    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func saveImage() {
        let selector = #selector(self.onImageSaved(_:error:contextInfo:))
        takeSnapshot()?.saveToPhotoLibrary(self, selector)
    }

    @objc private func onImageSaved(_ image: UIImage, error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            ac.present()
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            ac.present()
        }
    }
}
