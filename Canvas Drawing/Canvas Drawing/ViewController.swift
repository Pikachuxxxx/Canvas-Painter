//
//  ViewController.swift
//  Canvas Drawing
//
//  Created by phani srikar on 19/06/20.
//  Copyright © 2020 phani srikar. All rights reserved.
//

import UIKit

class Canvas: UIView {
    
    override func draw(_ rect: CGRect) {
        // custom drawing
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }

        
        context.setStrokeColor(UIColor.yellow.cgColor)
        context.setLineWidth(10)
        context.setLineCap(.round)
        
        lines.forEach { (line) in
            for (i, p) in line.enumerated() {
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
        }
        
        context.strokePath()
        
    }

    var lines = [[CGPoint]]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append([CGPoint]())
    }
    
    // track the finger as we move across screen
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {return}
//        print(point)
        
        guard var lastLine = lines.popLast() else { return }
        lastLine.append(point)
        lines.append(lastLine)

        setNeedsDisplay()
    }
    public func clearCanvas(){
        lines.removeAll()
    }
    
}

class ViewController: UIViewController {

    let canvas = Canvas()

    var CanvasBoard = NeumorphicVIew()
    
    
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

        AddLabel(font: UIFont(name: "AvenirNext-DemiBold", size: 36)!, frame: CGRect(x: 20, y: 80, width: 200, height: 36), textColor: UIColor.black, Text: "Welcome!", viewToAdd: self.view)
        AddLabel(font: UIFont(name: "AvenirNext-Regular", size: 16)!, frame: CGRect(x: 25, y: 130, width: 300, height: 50), textColor: UIColor.black, Text: "Let your creativity flow, place your finger on the board to start drawing", viewToAdd: self.view)
        
        AddButton(titleColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), frame: CGRect(x: self.view.frame.width / 2 - 100, y: 700, width: 200, height: 50), titleText: "Save Canvas", viewToAdd: self.view)
        AddButton(titleColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), frame: CGRect(x: self.view.frame.width / 2 - 150, y: 650, width: 100, height: 30), titleText: "Clear", viewToAdd: self.view)
        AddButton(titleColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), frame: CGRect(x: self.view.frame.width / 2 + 50, y: 650, width: 100, height: 30), titleText: "Undo", viewToAdd: self.view)

    }

    
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
        }
        if(sender.titleLabel?.text == "Save Canvas"){
            sender.setTitle(sender.titleLabel?.text, for: .highlighted)
            CanvasBoard.saveImage()
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
    }
    
    @objc func released(sender: UIButton!) {
        print("Button released")
        print(sender.subviews)
        sender.subviews[1].removeFromSuperview()
        let buttonNeuView = NeumorphicVIew(frame: CGRect(x: 0, y: 0, width: sender.frame.width, height: sender.frame.height))
        buttonNeuView.isUserInteractionEnabled = false
        sender.addSubview(buttonNeuView)
        print(sender.subviews)
        sender.bringSubviewToFront(sender.subviews[0])
        if(sender.titleLabel?.text == "Save Canvas"){
            sender.setTitle(sender.titleLabel?.text, for: .highlighted)
        }
    }
    
    
    
    
    //MARK: - Programatic UI
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
    Creates a personalized UI Button in Neumorphic Style.

    - Parameter titleColor: The colour of the text.
    - Parameter frame : The dimensions of the button.
    - Parameter titleText : The text to display on the button.
    - Parameter viewToAdd : The view to which the UIButton should be added.
     
    - Returns: Draws a UIButton in the view specified with the given customisations.
    */
    func AddButton(titleColor : UIColor, frame : CGRect, titleText : String, viewToAdd : UIView){
        let saveButton = UIButton()
//        (red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        saveButton.setTitleColor(titleColor, for: .normal)
        saveButton.addTarget(self, action: #selector(ViewController.pressed(sender:)), for: [.touchDown])
        saveButton.addTarget(self, action: #selector(ViewController.released(sender:)), for: [.touchUpInside])
        let buttonNeuView = NeumorphicVIew(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        buttonNeuView.isUserInteractionEnabled = false
        saveButton.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: buttonNeuView.frame.width, height: buttonNeuView.frame.height)
        saveButton.addSubview(buttonNeuView)
        saveButton.setTitle(titleText, for: .normal)
        viewToAdd.addSubview(saveButton)
    }

}

