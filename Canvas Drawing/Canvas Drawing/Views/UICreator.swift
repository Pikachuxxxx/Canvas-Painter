//
//  UICreator.swift
//  Canvas Drawing
//
//  Created by phani srikar on 21/06/20.
//  Copyright © 2020 phani srikar. All rights reserved.
//

import Foundation
import UIKit
// A custom class to manage and create UI Objects programatically
public class UICreator{
    //MARK:- Programatic UI Pre-Setup
       /**
           Draws a personalized UI label.

       - Parameter font: The font of the text in a UIFont object.
       - Parameter frame : The dimensions of the UILabel in a CGRect object.
       - Parameter textColor : The color of the text to display on the Label.
       - Parameter Text : The text to display.
       -  Parameter viewToAdd : The view in which the label should be added to.
        
       - Returns: (Void) Draws a UILabel with custom configurations in the view specified.
       */
       func AddLabel(font : UIFont, textColor : UIColor, Text : String, viewToAdd : UIView){
           let prgmLabel: UILabel = UILabel()
           prgmLabel.font = font
           prgmLabel.textColor = textColor
           prgmLabel.textAlignment = NSTextAlignment.center
           prgmLabel.text = Text
           prgmLabel.numberOfLines = 0
           prgmLabel.lineBreakMode = .byWordWrapping
           prgmLabel.translatesAutoresizingMaskIntoConstraints = true
           prgmLabel.sizeToFit()
           viewToAdd.addSubview(prgmLabel)
       }
       /**
           Creates and returns a personalized UI label.

       - Parameter font: The font of the text in a UIFont object.
       - Parameter frame : The dimensions of the UILabel in a CGRect object.
       - Parameter textColor : The color of the text to display on the Label.
       - Parameter Text : The text to display.
        
       - Returns: UILabel with custom configurations.
       */
       func GetLabel(font : UIFont, textColor : UIColor, Text : String) -> UILabel{
           let prgmLabel: UILabel = UILabel()
           prgmLabel.font = font
           prgmLabel.textColor = textColor
           prgmLabel.textAlignment = NSTextAlignment.center
           prgmLabel.text = Text
           prgmLabel.numberOfLines = 0
           prgmLabel.lineBreakMode = .byWordWrapping
           prgmLabel.translatesAutoresizingMaskIntoConstraints = true
           prgmLabel.sizeToFit()
           return prgmLabel
       }
}
