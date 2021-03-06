//
//  ViewController.swift
//  Canvas Drawing
//
//  Created by phani srikar on 19/06/20.
//  Copyright © 2020 phani srikar. All rights reserved.
//

import UIKit

struct Line {
    let width : CGFloat
    let color : CGColor
    var points : [CGPoint]
}
class Canvas: UIView {
    
    var strokeColor : UIColor = UIColor.black
    var strokeWidth : Float = 1

    
    override func draw(_ rect: CGRect) {
        // Custom Drawing
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        lines.forEach { (line) in
            for (i, p) in line.points.enumerated() {
                context.setStrokeColor(line.color)
                context.setLineWidth(line.width)
                context.setLineCap(.round)
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
             context.strokePath()
        }
        
       
        
    }

    var lines = [Line]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(Line.init(width: CGFloat(strokeWidth), color: strokeColor.cgColor, points: []))
    }
    
    // track the finger as we move across screen
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {return}
//        print(point)
        
        guard var lastLine = lines.popLast() else { return }
        lastLine.points.append(point)
        lines.append(lastLine)

        setNeedsDisplay()
    }
    public func clearCanvas(){
        lines.removeAll()
    }
    
}

public enum ButtonTags : Int{
    case SaveButton = 0
    case ClearButton
    case UndoButton
    case ShareButton
}

class CanvasDrawVC: UIViewController {

    let canvas = Canvas()

    var CanvasBoard = NeumorphicVIew()
    
    let colorPalette : [UIColor] = [UIColor.black,UIColor.blue,UIColor.white,UIColor.green,UIColor.orange,UIColor.purple,UIColor.red,UIColor.yellow]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .offWhite
        

        let viewWidth : CGFloat = self.view.frame.width - 60, viewHeight :  CGFloat = 400
        let neumorphView = NeumorphicVIew(frame: CGRect(x: view.frame.width/2 - viewWidth / 2, y: self.view.frame.height/2 - viewHeight / 2, width: viewWidth, height: viewHeight))
        CanvasBoard = neumorphView
        // Ading the canvas view to neumorph View
        neumorphView.addSubview(canvas)
        view.addSubview(neumorphView)
        

        canvas.backgroundColor = neumorphView.backgroundColor
        canvas.layer.cornerRadius = neumorphView.layer.cornerRadius
        canvas.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)

        // Welcome Text
        AddLabel(font: UIFont(name: "AvenirNext-DemiBold", size: 36)!, frame: CGRect(x: 0, y: 80, width: 200, height: 36), textColor: UIColor.black, Text: "Welcome!", viewToAdd: self.view)
        AddLabel(font: UIFont(name: "AvenirNext-Regular", size: 16)!, frame: CGRect(x: 25, y: 130, width: 300, height: 50), textColor: UIColor.black, Text: "Let your creativity flow, place your finger on the board to start drawing", viewToAdd: self.view)
        // Save button
        AddButton(titleColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), frame: CGRect(x: self.view.frame.width / 2 - 100, y: 750, width: 200, height: 40), titleText: "Save Canvas", viewToAdd: self.view, buttonBGColor: nil, buttongTag: ButtonTags.SaveButton.rawValue, autoAdjustFont: false)
        // Clear Button
        AddButton(titleColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), frame: CGRect(x: self.view.frame.width / 2 - 150, y: 700, width: 100, height: 30), titleText: "Clear", viewToAdd: self.view, buttonBGColor: nil, buttongTag: ButtonTags.ClearButton.rawValue, autoAdjustFont: false)
        // Undo Button
        AddButton(titleColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), frame: CGRect(x: self.view.frame.width / 2 + 50, y: 700, width: 100, height: 30), titleText: "Undo", viewToAdd: self.view, buttonBGColor:  nil, buttongTag: ButtonTags.UndoButton.rawValue, autoAdjustFont: false)
        
        // Share Button
        AddButton(titleColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), frame: CGRect(x: self.view.frame.width / 2 + 40, y: 80, width: 100, height: 40), titleText: "  Share Canvas  ", viewToAdd: self.view, buttonBGColor: nil, buttongTag: ButtonTags.ShareButton.rawValue, autoAdjustFont: true)

        
        // Adding color palatte buttons here
        // TODO: Embed the palette buttons in a Stack View
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
        
        //Let's customise the 'track' and 'thumb' of the slider to neumorphic view
        
        //Stroke Slider Events
        strokeSlider.addTarget(self, action: #selector(CanvasDrawVC.sliderValueChanged(_:)), for: .valueChanged)
    }


    //MARK:- Programatic UI
    /**
    Draws a personalized UI label.

    - Parameter font: The font of the text in a UIFont object.
    - Parameter frame : The dimensions of the UILabel in a CGRect object.
    - Parameter textColor : The color of the text to display on the Label.
    - Parameter Text : The text to display.
    -  Parameter viewToAdd : The view in which the label should be added to.
     
    - Returns: (Void) Draws a UILabel with custom configurations in the view specified.
    */
    func AddLabel(font : UIFont, frame : CGRect, textColor : UIColor, Text : String, viewToAdd : UIView){
        let prgmLabel: UILabel = UILabel()
        prgmLabel.font = font
        prgmLabel.frame = frame
        prgmLabel.textColor = textColor
        prgmLabel.textAlignment = NSTextAlignment.center
        prgmLabel.text = Text
        prgmLabel.numberOfLines = 0
        prgmLabel.lineBreakMode = .byWordWrapping
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
    func GetLabel(font : UIFont, frame : CGRect, textColor : UIColor, Text : String) -> UILabel{
        let prgmLabel: UILabel = UILabel()
        prgmLabel.font = font
        prgmLabel.frame = frame
        prgmLabel.textColor = textColor
        prgmLabel.textAlignment = NSTextAlignment.center
        prgmLabel.text = Text
        prgmLabel.numberOfLines = 0
        prgmLabel.lineBreakMode = .byWordWrapping
        return prgmLabel
    }
    /**
    Draws a personalized UI Button in Neumorphic Style.

    - Parameter titleColor: The colour of the text.
    - Parameter frame : The dimensions of the button.
    - Parameter titleText : The text to display on the button.
    - Parameter viewToAdd : The view to which the UIButton should be added.
    - Parameter buttonBGColor : Set the background color of the button, nil defaults to view bg color
    - Parameter autoAdjustFont : To either adjust the UIButton text dynamically or not
     
    - Returns: (Void) Draws a UIButton in the view specified with the given customisations.
    */
    func AddButton(titleColor : UIColor, frame : CGRect, titleText : String, viewToAdd : UIView, buttonBGColor : UIColor?, buttongTag : Int,autoAdjustFont : Bool){
        let prgrmButton = UIButton()
        prgrmButton.tag = buttongTag
//        (red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        prgrmButton.setTitleColor(titleColor, for: .normal)
        prgrmButton.titleLabel?.adjustsFontSizeToFitWidth = autoAdjustFont
        prgrmButton.titleLabel?.numberOfLines = 1
        prgrmButton.titleLabel?.minimumScaleFactor = 0.6
        prgrmButton.addTarget(self, action: #selector(CanvasDrawVC.pressed(sender:)), for: [.touchDown])
        prgrmButton.addTarget(self, action: #selector(CanvasDrawVC.released(sender:)), for: [.touchUpInside])
        let buttonNeuView = NeumorphicVIew(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        buttonNeuView.isUserInteractionEnabled = false
        prgrmButton.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: buttonNeuView.frame.width, height: buttonNeuView.frame.height)
        prgrmButton.addSubview(buttonNeuView)
        prgrmButton.setTitle(titleText, for: .normal)
        viewToAdd.addSubview(prgrmButton)
        prgrmButton.bringSubviewToFront(prgrmButton.titleLabel! )
    }
    // MARK:- Event handling functions
    /**
    The event function when any of the button is pressed
    */
    @objc func pressed(sender: UIButton!) {
        print("Button pressed")
        sender.subviews[0].removeFromSuperview()
        if(sender.isHighlighted){
            let innerNueView = UIView()
            innerNueView.frame = CGRect(x: 0, y: 0, width: sender.frame.width, height: sender.frame.height)
            innerNueView.layer.cornerRadius = 25
            innerNueView.addInnerShadow(onSide: .bottomAndRight, shadowColor: UIColor.white, shadowSize: 10, shadowOpacity: 0.7)
            innerNueView.addInnerShadow(onSide: .topAndLeft, shadowColor: UIColor.black, shadowSize: 10, shadowOpacity: 0.2)
            innerNueView.isUserInteractionEnabled = false
            sender.addSubview(innerNueView)
       sender.setTitle(sender.titleLabel?.text, for: .highlighted)
        }
        
        else if(sender.titleLabel?.text == "Clear"){
            print("Clearing Canvas....")
            canvas.clearCanvas()
            canvas.setNeedsDisplay()
        }
        else if(sender.titleLabel?.text == "Undo"){
            print("Undoing last line in Canvas....")
            if(canvas.lines.count > 0){
                canvas.lines.removeLast()
            }
            canvas.setNeedsDisplay()
        }
        // MARK:- Sender based handling
        switch sender.tag {
        case ButtonTags.SaveButton.rawValue:
            do {
                self.CanvasBoard.saveImage()
                break
            }
        case ButtonTags.ClearButton.rawValue:
            do {
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
                break
            }
        default:
            break
        }
    }
    /**
    The event function when any of the button is released
    */
    @objc func released(sender: UIButton!) {
        print("Button released")
        print(sender.subviews)
        sender.subviews[1].removeFromSuperview()
        let buttonNeuView = NeumorphicVIew(frame: CGRect(x: 0, y: 0, width: sender.frame.width, height: sender.frame.height))
        buttonNeuView.isUserInteractionEnabled = false
        sender.addSubview(buttonNeuView)
        print(sender.subviews)
        sender.bringSubviewToFront(sender.subviews[0])
        sender.setTitle(sender.titleLabel?.text, for: .highlighted)
        if(sender.titleLabel?.text == "Save Canvas"){
            sender.setTitle(sender.titleLabel?.text, for: .highlighted)
        }
    }/**
    The event function when the slider is moved
    */
    @objc func sliderValueChanged(_ sender:UISlider){
        canvas.strokeWidth = sender.value
    }
    /**
    The event function when any of the color is pressed
    */
    @objc func colorSelected(sender : UIButton){
    canvas.strokeColor  = colorPalette[sender.tag]
}
}
