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
        - Parameter viewToAdd : The view in which the label should be added to.
         
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
            prgmLabel.translatesAutoresizingMaskIntoConstraints = false
            prgmLabel.sizeToFit()
            viewToAdd.addSubview(prgmLabel)
        }
        /**
            Creates and returns a personalized UI label.

        - Parameter font: The font of the text in a UIFont object.
        - Parameter frame : The dimensions of the UILabel in a CGRect object.
        - Parameter textColor : The color of the text to display on the Label.
        - Parameter Text : The text to display.
        - Parameter viewToAdd : The view in which the label should be added to.

        - Returns: UILabel with custom configurations and adds it to the specified View.
        */
        func GetLabel(font : UIFont, textColor : UIColor, Text : String, viewToAdd : UIView) -> UILabel{
            let prgmLabel: UILabel = UILabel()
            prgmLabel.font = font
            prgmLabel.textColor = textColor
            prgmLabel.textAlignment = NSTextAlignment.center
            prgmLabel.text = Text
            prgmLabel.numberOfLines = 0
            prgmLabel.lineBreakMode = .byWordWrapping
            prgmLabel.adjustsFontSizeToFitWidth = true
            viewToAdd.addSubview(prgmLabel)
            // Auto layout configurations
            prgmLabel.translatesAutoresizingMaskIntoConstraints = false
            prgmLabel.sizeToFit()
            return prgmLabel
        }
        /**
            Draws a personalized UI Button in Neumorphic Style.

        - Parameter titleColor: The colour of the text.
        - Parameter frame : The dimensions of the button.
        - Parameter titleText : The text to display on the button.
        - Parameter viewToAdd : The view to which the UIButton should be added.
        - Parameter buttonBGColor : Set the background color of the button, nil defaults to view bg color.
        - Parameter autoAdjustFont : To either adjust the UIButton text dynamically or not.
         
        - Returns: (Void) Draws a UIButton in the view specified with the given customisations.
        */
        func AddButton(titleColor : UIColor, titleText : String, viewToAdd : UIView, buttonBGColor : UIColor?, buttongTag : Int,autoAdjustFont : Bool){
           let prgrmButton = UIButton()
            prgrmButton.tag = buttongTag
            prgrmButton.backgroundColor = UIColor.red
    //        (red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            prgrmButton.setTitleColor(titleColor, for: .normal)
            prgrmButton.titleLabel?.adjustsFontSizeToFitWidth = autoAdjustFont
            prgrmButton.titleLabel?.numberOfLines = 1
            prgrmButton.titleLabel?.minimumScaleFactor = 0.6
            prgrmButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            prgrmButton.addTarget(self, action: #selector(CanvasDrawVC.pressed(sender:)), for: [.touchDown])
            prgrmButton.addTarget(self, action: #selector(CanvasDrawVC.released(sender:)), for: [.touchUpInside])
            prgrmButton.setTitle(titleText, for: .normal)
            viewToAdd.addSubview(prgrmButton)
            prgrmButton.bringSubviewToFront(prgrmButton.titleLabel! )
            // Auto layout configurations
            prgrmButton.translatesAutoresizingMaskIntoConstraints = false
            //Neumoprphic Effect
            let buttonNeuView = NeumorphicVIew(frame: CGRect(x: 0, y: 0, width: prgrmButton.frame.width, height: prgrmButton.frame.height))
            buttonNeuView.isUserInteractionEnabled = false
            prgrmButton.addSubview(buttonNeuView)
            buttonNeuView.setNeedsDisplay()
            // Constraint the bunonNeuView to the superView
            
            prgrmButton.bringSubviewToFront(prgrmButton.titleLabel! )
        }
       /**
            Draws a personalized UI Button in Neumorphic Style.

        - Parameter titleColor: The colour of the text.
        - Parameter frame : The dimensions of the button.
        - Parameter titleText : The text to display on the button.
        - Parameter viewToAdd : The view to which the UIButton should be added.
        - Parameter buttonBGColor : Set the background color of the button, nil defaults to view bg color.
        - Parameter autoAdjustFont : To either adjust the UIButton text dynamically or not.
        - Parameter viewToAdd : The view in which the button should be added to.

        - Returns: UIButton with custom configurations and adds it to the specified View.
        */
        func GetButton(titleColor : UIColor, titleText : String, viewToAdd : UIView, buttonBGColor : UIColor?, buttongTag : Int,autoAdjustFont : Bool) -> UIButton{
            let prgrmButton = UIButton()
            prgrmButton.tag = buttongTag
    //        (red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            prgrmButton.setTitleColor(titleColor, for: .normal)
            prgrmButton.titleLabel?.adjustsFontSizeToFitWidth = autoAdjustFont
            prgrmButton.titleLabel?.numberOfLines = 1
            prgrmButton.titleLabel?.minimumScaleFactor = 0.6
            prgrmButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            prgrmButton.addTarget(self, action: #selector(CanvasDrawVC.pressed(sender:)), for: [.touchDown])
            prgrmButton.addTarget(self, action: #selector(CanvasDrawVC.released(sender:)), for: [.touchUpInside])
            prgrmButton.setTitle(titleText, for: .normal)
            viewToAdd.addSubview(prgrmButton)
            prgrmButton.bringSubviewToFront(prgrmButton.titleLabel! )
            // Auto layout configurations
            prgrmButton.translatesAutoresizingMaskIntoConstraints = false
            
            //Neumoprphic Effect
            let buttonNeuView = NeumorphicVIew(frame: CGRect(x: 0, y: 0, width: prgrmButton.frame.width, height: prgrmButton.frame.height))
            buttonNeuView.isUserInteractionEnabled = false
            prgrmButton.addSubview(buttonNeuView)
            
            prgrmButton.bringSubviewToFront(prgrmButton.titleLabel! )
            return prgrmButton
        }
}
