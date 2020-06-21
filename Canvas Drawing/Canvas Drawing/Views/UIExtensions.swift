//
//  UIExtensions.swift
//  Canvas Drawing
//
//  Created by phani srikar on 21/06/20.
//  Copyright © 2020 phani srikar. All rights reserved.
//

import Foundation
import UIKit

// MARK:- UIColor Extensions
extension UIColor{
    // A Slight greyishshade of white for the creation of Neumoprphic effect
    static let offWhite = UIColor(red: 225 / 255, green: 225 / 255, blue: 235 / 255, alpha: 255 / 255)
}
// MARK:- UIImage Extensions
extension UIImage {
    /**
            To save an UIImage to photo library.
     
     - Returns: Saves the UIImage on which this method was called into the photo library.
    */
    func saveToPhotoLibrary(_ completionTarget: Any?, _ completionSelector: Selector?) {
        DispatchQueue.global(qos: .userInitiated).async {
            UIImageWriteToSavedPhotosAlbum(self, completionTarget, completionSelector, nil)
        }
    }
    /**
        Converts a normal UIImage with sharp conrner into smoothened out rounded corners.
     
     - Parameter radius : The radius of each edge of the rectanle of the UIImageVIew.
     
     - Returns:  UIImage with rounded corners.
     */
    public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
// MARK:- UIAlertController Extensions
extension UIAlertController {
    /**
        A method to present the UIAlert Controller in the current root view.
     */
    func present() {
        guard let controller = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController else {
            return
        }
        controller.present(self, animated: true)
    }
}
// MARK:- UIView Extensions
extension UIView{
    /**
            Converts the specified View on which this method was called into an UIImage with the same dimensions as the View.
     
     - Returns: UIImage snapshot of the View that we desire to capture.
    */
    public func takeSnapshot() -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: self.frame.size.width, height: self.frame.size.height - 5))
        let rect = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        drawHierarchy(in: rect, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    /**
        Creates the mask of  the given View (UIView) with the speicified CGRect bounds, or a inverse mask if specified.
     
      - Parameter withRect : The rectangle bounds of the View that we desire to mask.
      - Parameter inverse : Defaults to false, if true creates a inverse mask of the VIew.
    */
    public func mask(withRect rect: CGRect, inverse: Bool = false) {
        let path = UIBezierPath(rect: rect)
        let maskLayer = CAShapeLayer()

        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        }

        maskLayer.path = path.cgPath

        self.layer.mask = maskLayer
    }
    // Different inner shadow style options
       public enum innerShadowSide
       {
           case all, left, right, top, bottom,
        topAndLeft, topAndRight, bottomAndLeft, bottomAndRight,
        exceptLeft, exceptRight, exceptTop, exceptBottom
       }
       
       /**
            Created inner shadows for the View on the specified side(s) with maximim customisations and options. You can call this method multiple times to draw shadows on different sides with different customisations.
     
     - Parameter onSide : Specify the side on which you prefer to add the inner shadow, can also choose to add shadows on sides at the same time using the `innerShadowSide` Enum options.
     - Parameter shadowColor : The color of the inner shadow.
     - Parameter shafdowSize : The size of the inner shadow.
     - Parameter cornerRadius : The corner radius of the shadows layer inside the view.
     - Parameter shaodowOpacity : The alpha value of the inner shadows.
       */
       public func addInnerShadow(onSide: innerShadowSide, shadowColor: UIColor, shadowSize: CGFloat, cornerRadius: CGFloat = 0.0, shadowOpacity: Float)
       {
           // define and set a shaow layer
           let shadowLayer = CAShapeLayer()
           shadowLayer.frame = bounds
           shadowLayer.shadowColor = shadowColor.cgColor
           shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
           shadowLayer.shadowOpacity = shadowOpacity
           shadowLayer.shadowRadius = shadowSize
           shadowLayer.fillRule = CAShapeLayerFillRule.evenOdd
           
           // define shadow path
           let shadowPath = CGMutablePath()
           
           // define outer rectangle to restrict drawing area
           let insetRect = bounds.insetBy(dx: -shadowSize * 2.0, dy: -shadowSize * 2.0)
           
           // define inner rectangle for mask
           let innerFrame: CGRect = { () -> CGRect in
               switch onSide
               {
                   case .all:
                       return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
                   case .left:
                       return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
                   case .right:
                       return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
                   case .top:
                       return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
                   case.bottom:
                       return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
                   case .topAndLeft:
                       return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
                   case .topAndRight:
                       return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
                   case .bottomAndLeft:
                       return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
                   case .bottomAndRight:
                       return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
                   case .exceptLeft:
                       return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
                   case .exceptRight:
                       return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
                   case .exceptTop:
                       return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
                   case .exceptBottom:
                       return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
               }
           }()
           
           // add outer and inner rectangle to shadow path
           shadowPath.addRect(insetRect)
           shadowPath.addRect(innerFrame)
           
           // set shadow path as show layer's
           shadowLayer.path = shadowPath
           
           // add shadow layer as a sublayer
           layer.addSublayer(shadowLayer)
           
           // hide outside drawing area
           clipsToBounds = true
       }
}
