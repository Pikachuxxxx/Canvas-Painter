//
//  ViewController.swift
//  Canvas Drawing
//
//  Created by phani srikar on 19/06/20.
//  Copyright © 2020 phani srikar. All rights reserved.
//

import UIKit

public enum ButtonTags : Int{
    case SaveButton = 0
    case ClearButton
    case UndoButton
    case ShareButton
}

class CanvasDrawVC: UIViewController {

    let canvas = Canvas()
    var CanvasBoard = NeumorphicVIew() // Getter kinda property Class Object for the Neumorphic View.
    
    
    var shareBtn : UIButton! = nil
    // The canvas colour palette colours
    let colorPalette : [UIColor] = [UIColor.black,UIColor.cyan,UIColor.green,UIColor.orange,UIColor.purple,UIColor.red,UIColor.yellow,UIColor.white]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        /**
            View Settings such as title, and other
         */
        self.view.backgroundColor = .offWhite
        self.view.translatesAutoresizingMaskIntoConstraints = true
        self.tabBarItem.title = "Canvas"
        tabBarItem.image = UIImage(named: "Canvas Icon")
        
        // Neumorphic Canvas Board
        let viewWidth : CGFloat = self.view.frame.width - 60, viewHeight :  CGFloat = 400
        let neumorphView = NeumorphicVIew(frame: CGRect(x: view.frame.width/2 - viewWidth / 2, y: self.view.frame.height/2 - viewHeight / 2, width: viewWidth, height: viewHeight))
        
        // TODO : Refactor Neumorphic view to a global property with public get adn private set.
        
        // A gloabl instance of Neumprphic Cavas board to get it's configuration basiacally acting as a getter property
        CanvasBoard = neumorphView
        // Setting up canvas board settings
        canvas.backgroundColor = neumorphView.backgroundColor
        canvas.layer.cornerRadius = neumorphView.layer.cornerRadius
        canvas.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        // Adding the canvas view to neumorph View
        neumorphView.addSubview(canvas)
        // Adding the neumorphhic view to the main View
        view.addSubview(neumorphView)

    // MARK:- View UI Objects

        // Welcome Text
        let welcomeLabel = GetLabel(font: UIFont(name: "AvenirNext-DemiBold", size: 36)!, textColor: UIColor.black, Text: "Welcome!", viewToAdd: self.view)
//        AddLabel(font: UIFont(name: "AvenirNext-Regular", size: 16)!, textColor: UIColor.black, Text: "Let your creativity flow, place your finger on the board and start drawing", viewToAdd: self.view)
        
        // Share Button
        shareBtn = GetButton(titleColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), titleText: "   Share Canvas   ", viewToAdd: self.view, buttonBGColor: nil, buttongTag: ButtonTags.ShareButton.rawValue, autoAdjustFont: true)
        print("The subviews are : \(shareBtn.subviews)")

        
        // Adding color palatte buttons here
    // TODO : Embed the palette buttons in a Stack View
        for (index,color) in colorPalette.enumerated(){
            let circlePalette = UIButton(type: .custom)
            circlePalette.layer.cornerRadius = 15
            circlePalette.showsTouchWhenHighlighted = true
            circlePalette.backgroundColor = color
            circlePalette.addTarget(self, action: #selector(CanvasDrawVC.colorSelected(sender:)), for: [.touchDown])
            circlePalette.frame = CGRect(x: 30 + (40*index), y: 620 , width: 30, height: 30)
            self.view.addSubview(circlePalette)
            circlePalette.tag = index
        }
        
    // Slider (Neumorphic style)
        // TODO : Make a customisable standalone function
        let strokeSlider = UISlider()
        strokeSlider.minimumValue = 1
        strokeSlider.maximumValue = 10
        strokeSlider.isContinuous = true
        strokeSlider.tintColor = UIColor.black
        strokeSlider.frame = CGRect(x: 30 , y: 660 , width: 300, height: 30)
        self.view.addSubview(strokeSlider)
        
        //Let's customise the `track` and `thumb` of the slider to neumorphic view
        
        //Stroke Slider Events
        strokeSlider.addTarget(self, action: #selector(CanvasDrawVC.sliderValueChanged(_:)), for: .valueChanged)
        
    // MARK:-  View UI Objects Constraints
        
        // Weclome Text Constraints
        welcomeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive = true
        welcomeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        
        // Share Button Constraints
        shareBtn.leadingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor, constant: 40).isActive = true
        shareBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
//        shareBtn.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive = true
        shareBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        released(sender: shareBtn)
        print("The subviews after first release : \(shareBtn.subviews)")
    }
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
    // MARK:- Event handling functions
    /**
        The event handling function when any of the button is pressed.
    */
    @objc func pressed(sender: UIButton!) {
        sender.subviews[0].removeFromSuperview()
        if(sender.isHighlighted){
            let innerNueView = UIView()
            innerNueView.frame = CGRect(x: 0, y: 0, width: sender.frame.width, height: sender.frame.height)
            innerNueView.layer.cornerRadius = 25
            innerNueView.addInnerShadow(onSide: .bottomAndRight, shadowColor: UIColor.white, shadowSize: 10, shadowOpacity: 0.7)
            innerNueView.addInnerShadow(onSide: .topAndLeft, shadowColor: UIColor.black, shadowSize: 10, shadowOpacity: 0.2)
            innerNueView.isUserInteractionEnabled = false
            sender.addSubview(innerNueView)
            sender.bringSubviewToFront(sender.titleLabel! )
            sender.setTitle(sender.titleLabel?.text, for: .highlighted)
        }
        // MARK:- Sender based handling
        switch sender.tag {
        case ButtonTags.SaveButton.rawValue:
            do {
                print("Saving Canvas....")
                self.CanvasBoard.saveImage()
                break
            }
        case ButtonTags.ClearButton.rawValue:
            do {
                print("Clearing Canvas....")
                self.canvas.clearCanvas()
                self.canvas.setNeedsDisplay()
                break
            }
        case ButtonTags.UndoButton.rawValue:
            do{
                print("Undoing last line in Canvas....")
                if(canvas.lines.count > 0){
                    canvas.lines.removeLast()
                }
                canvas.setNeedsDisplay()
                break
            }
        case ButtonTags.ShareButton.rawValue:
            do {
                // Sharing the canvas logic here
                print("Sharing Canvas....")
                break
            }
        default:
            break
        }
        print("The subviews after pressing : \(sender.subviews)")
    }
    /**
        The event function when any of the button is released.
    */
    @objc func released(sender: UIButton!) {
        sender.subviews[0].removeFromSuperview()
        let buttonNeuView = NeumorphicVIew(frame: CGRect(x: 0, y: 0, width: sender.frame.width, height: sender.frame.height))
        buttonNeuView.isUserInteractionEnabled = false
        sender.addSubview(buttonNeuView)
        sender.bringSubviewToFront(sender.titleLabel! )
        sender.setTitle(sender.titleLabel?.text, for: .highlighted)
        print("The subviews after releasing : \(sender.subviews)")
    }
    /**
        The event function when the slider is moved.
    */
    @objc func sliderValueChanged(_ sender:UISlider){
        canvas.strokeWidth = sender.value
    }
    /**
        The event function when any of the color is pressed.
    */
    @objc func colorSelected(sender : UIButton){
    canvas.strokeColor  = colorPalette[sender.tag]
    }
}
