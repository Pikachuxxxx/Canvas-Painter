//
//  ViewController.swift
//  Canvas Drawing
//
//  Created by phani srikar on 19/06/20.
//  Copyright © 2020 phani srikar. All rights reserved.
//

import UIKit
import Firebase

// An enum to identify the Buttons in the view using tags.
public enum ButtonTags : Int{
    case SaveButton = 0
    case ClearButton
    case UndoButton
    case ShareButton
}
class CanvasDrawVC: UIViewController {

    let canvas = Canvas()
    // Neumorphic Canvas Board
    let neumorphCanvasBoard = NeumorphicVIew(frame: .zero)
    // UI creation  Object
    let createUI = UICreator()

    // UI objects
    var shareBtn : UIButton! = nil
    var clearBtn : UIButton! = nil
    var undoBtn : UIButton! = nil
    var saveBtn : UIButton! = nil
    let strokeSlider = UISlider()
    
    // Stack Views
    let paletteStack = UIStackView()
    let welcomeStack = UIStackView()
    let clearUndoStack = UIStackView()
    
    // The canvas colour palette colours
    let colorPalette : [UIColor] = [UIColor.black,UIColor.cyan,UIColor.green,UIColor.orange,UIColor.purple,UIColor.red,UIColor.yellow,UIColor.white]
    
    //MARK:- Firebase Initialisations
    
    // Get a reference to the storage service using the default Firebase App
    let storageVar : Storage = Storage.storage()

    
    //MARK:- View Lifecycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        /**
            View Settings such as title, and other
         */
        self.view.backgroundColor = .offWhite
        self.view.translatesAutoresizingMaskIntoConstraints = true

        

        neumorphCanvasBoard.translatesAutoresizingMaskIntoConstraints = false
        // Setting up canvas board settings
        canvas.translatesAutoresizingMaskIntoConstraints = false
        canvas.backgroundColor = neumorphCanvasBoard.backgroundColor
        // Adding the canvas view to neumorph View
        neumorphCanvasBoard.addSubview(canvas)
        // Adding the neumorphhic view to the main View
        view.addSubview(neumorphCanvasBoard)

    // MARK:- View UI Objects

        // Welcome Text
        let welcomeLabel = createUI.GetLabel(font: UIFont(name: "AvenirNext-DemiBold", size: 36)!, textColor: UIColor.black, Text: "Welcome!", viewToAdd: self.view)
        welcomeLabel.minimumScaleFactor = 0.6
        welcomeLabel.numberOfLines = 1
        welcomeLabel.adjustsFontSizeToFitWidth = true
        welcomeLabel.textAlignment = .center
        // Description Text
        let welcomeDescriptionLabel = createUI.GetLabel(font: UIFont(name: "AvenirNext-Regular", size: 14)!, textColor: UIColor.black, Text: "Let your creativity flow, place your finger on the board and start drawing!", viewToAdd: self.view)
        welcomeDescriptionLabel.minimumScaleFactor = 0.4
        welcomeDescriptionLabel.numberOfLines = 2
        welcomeDescriptionLabel.adjustsFontSizeToFitWidth = true
        
        // Share Button
        shareBtn = createUI.GetButton(titleColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), titleText: "Share Canvas", viewToAdd: self.view, buttonBGColor: nil, buttongTag: ButtonTags.ShareButton.rawValue, autoAdjustFont: true)
        shareBtn.titleLabel!.minimumScaleFactor = 0.4
        shareBtn.titleLabel!.numberOfLines = 1
        shareBtn.titleLabel!.adjustsFontSizeToFitWidth = true

        // Clear Button
        clearBtn = createUI.GetButton(titleColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), titleText: "Clear", viewToAdd: self.view, buttonBGColor: nil, buttongTag: ButtonTags.ClearButton.rawValue, autoAdjustFont: true)
        // Undo Button
        undoBtn = createUI.GetButton(titleColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), titleText: "Undo", viewToAdd: self.view, buttonBGColor: nil, buttongTag: ButtonTags.UndoButton.rawValue, autoAdjustFont: true)
        // Save Button
        saveBtn = createUI.GetButton(titleColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), titleText: "Save Canvas", viewToAdd: self.view, buttonBGColor: nil, buttongTag: ButtonTags.SaveButton.rawValue, autoAdjustFont: true)
        
        // Adding color palatte buttons here
        for (index,color) in colorPalette.enumerated(){
            let circlePalette = UIButton(type: .roundedRect)
            circlePalette.showsTouchWhenHighlighted = true
            circlePalette.layer.cornerRadius = 8
            circlePalette.backgroundColor = color
            circlePalette.addTarget(self, action: #selector(CanvasDrawVC.colorSelected(sender:)), for: [.touchDown])
            paletteStack.addArrangedSubview(circlePalette)
            circlePalette.tag = index
        }
        self.view.addSubview(paletteStack)
    
    // MARK:- UI Objects Configurations

        
        // Palette Stack View configurations here
        paletteStack.translatesAutoresizingMaskIntoConstraints = false
        paletteStack.spacing = 10
        paletteStack.distribution = .fillEqually
        
        
    // Slider (Neumorphic style)
        strokeSlider.minimumValue = 1
        strokeSlider.maximumValue = 10
        strokeSlider.isContinuous = true
        strokeSlider.tintColor = UIColor.black
        strokeSlider.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(strokeSlider)
        
        //Let's customise the `track` and `thumb` of the slider to neumorphic view
        
        //Stroke Slider Events
        strokeSlider.addTarget(self, action: #selector(CanvasDrawVC.sliderValueChanged(_:)), for: .valueChanged)
        
    // MARK:-  View UI Objects Constraints
        
        welcomeStack.addArrangedSubview(welcomeLabel)
        welcomeStack.addArrangedSubview(shareBtn)
        welcomeStack.translatesAutoresizingMaskIntoConstraints = false
        welcomeStack.spacing = 20
        paletteStack.distribution = .fillProportionally
        self.view.addSubview(welcomeStack)
        welcomeStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        welcomeStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        welcomeStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        welcomeStack.heightAnchor.constraint(equalToConstant: 30).isActive = true
        welcomeStack.layoutIfNeeded()
        welcomeStack.setNeedsLayout()

        // Description Text Constraints
        welcomeDescriptionLabel.topAnchor.constraint(equalTo: welcomeStack.bottomAnchor, constant: 8).isActive = true
        welcomeDescriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        welcomeDescriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        welcomeDescriptionLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        welcomeDescriptionLabel.setNeedsLayout()
        welcomeDescriptionLabel.layoutIfNeeded()
        
        
        
        // Neumorph Canvas Board Constraints
        neumorphCanvasBoard.topAnchor.constraint(equalTo: welcomeDescriptionLabel.bottomAnchor, constant: 10).isActive = true
        neumorphCanvasBoard.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        neumorphCanvasBoard.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        neumorphCanvasBoard.heightAnchor.constraint(greaterThanOrEqualToConstant: 220).isActive = true
        neumorphCanvasBoard.heightAnchor.constraint(lessThanOrEqualToConstant: 450).isActive = true
//        neumorphCanvasBoard.heightAnchor.constraint(equalToConstant: 280).isActive = true
        canvas.backgroundColor = UIColor.clear
        
        canvas.topAnchor.constraint(equalTo: neumorphCanvasBoard.topAnchor).isActive = true
        canvas.leadingAnchor.constraint(equalTo: neumorphCanvasBoard.leadingAnchor).isActive = true
        canvas.trailingAnchor.constraint(equalTo: neumorphCanvasBoard.trailingAnchor).isActive = true
        canvas.bottomAnchor.constraint(equalTo: neumorphCanvasBoard.bottomAnchor).isActive = true
        

        // Palette Stack Constraints
        paletteStack.topAnchor.constraint(equalTo: neumorphCanvasBoard.bottomAnchor, constant: 20).isActive = true
        paletteStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        paletteStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        paletteStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        paletteStack.heightAnchor.constraint(lessThanOrEqualToConstant: 40).isActive = true

        paletteStack.setNeedsLayout()
        paletteStack.layoutIfNeeded()
        
        // Slider Constraints
        strokeSlider.topAnchor.constraint(equalTo: paletteStack.bottomAnchor, constant: 20).isActive = true
        strokeSlider.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        strokeSlider.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        strokeSlider.heightAnchor.constraint(greaterThanOrEqualToConstant: 15).isActive = true
        strokeSlider.heightAnchor.constraint(lessThanOrEqualToConstant: 30).isActive = true
        strokeSlider.setNeedsLayout()
        strokeSlider.layoutIfNeeded()
        
        // Clear and Undo Stack
        self.view.addSubview(clearUndoStack)
        clearUndoStack.translatesAutoresizingMaskIntoConstraints = false
        clearUndoStack.addArrangedSubview(clearBtn)
        clearUndoStack.addArrangedSubview(undoBtn)
        clearUndoStack.axis = .horizontal
        clearUndoStack.distribution = .fillEqually
        clearUndoStack.spacing = 80
        // Constraints for clear undo stack
        clearUndoStack.topAnchor.constraint(equalTo: strokeSlider.bottomAnchor, constant: 20).isActive = true
        clearUndoStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        clearUndoStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        clearUndoStack.heightAnchor.constraint(equalToConstant: 30).isActive = true
        clearUndoStack.setNeedsLayout()
        clearUndoStack.layoutIfNeeded()
        
        // Save Button Constraints
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.topAnchor.constraint(equalTo: clearUndoStack.bottomAnchor, constant: 20).isActive = true
        saveBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80).isActive = true
        saveBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -80).isActive = true
        saveBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        saveBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        saveBtn.setNeedsLayout()
        saveBtn.layoutIfNeeded()
    }
    //MARK:- Did Finish Laying out SubViews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        released(sender: shareBtn)
        released(sender: clearBtn)
        released(sender: undoBtn)
        released(sender: saveBtn)
        canvas.layer.cornerRadius = neumorphCanvasBoard.layer.cornerRadius
        canvas.frame = CGRect(x: 0, y: 0, width: neumorphCanvasBoard.frame.width, height: neumorphCanvasBoard.frame.height)
        canvas.setNeedsLayout()
        canvas.layoutIfNeeded()
        neumorphCanvasBoard.setNeedsLayout()
        neumorphCanvasBoard.layoutIfNeeded()
        neumorphCanvasBoard.UpdateCustomisations()
        self.view.bringSubviewToFront(neumorphCanvasBoard)

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
            innerNueView.layer.cornerRadius = 15
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
                if(canvas.lines.count > 0) {
                    print("Saving Canvas....")
                    self.neumorphCanvasBoard.saveImage()
                }
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
                if(canvas.lines.count > 0) {
                    print("Sharing Canvas....")
                    presentWithInputAndUpload()
                }
                break
            }
        default:
            break
        }
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
    
    // MARK:- Firebase Implementations
    /**
     This Function manages Firebase(FB uploading into firebase storage
     */
    func FBUploadManager(userID customUID : String, imageToUpload uploadImg : UIImage){
        
        if(InternetConnectionManager.isConnectedToNetwork()){
            
            // Create a storage reference from our storage service
            let storageRef  : StorageReference = storageVar.reference()
            
            // Data in memory
             let data = uploadImg.pngData() 

            // Create a reference to the file you want to upload
            let feedImagesRef = storageRef.child("FeedImages/\(customUID).png")

        let uploadTask = feedImagesRef.putData(data!, metadata: nil) { (metadata, error) in
                if error != nil{
                 //Uh-oh, an error occurred!
    //                print("Error uploading... \(error.debugDescription)")
                    let ac = UIAlertController(title: "Upload Failed!", message: "Your   canvas was failed to upload please try again. Error : \(error!.localizedDescription)", preferredStyle: .alert)
                                           ac.addAction(UIAlertAction(title: "OK", style: .default))
                                           ac.present()
                }else{
                    // Congrats on successful upload
                    print("Upload Successful !!!!")
                    
                    let ac = UIAlertController(title: "Upload Successful!", message: "Your canvas has been succesfully uploaded and will be shared with others.", preferredStyle: .alert)
                              ac.addAction(UIAlertAction(title: "OK", style: .default))
                              ac.present()
                }
            }
        _ = uploadTask.observe(.progress) { (taskSnapshot) in
                print("Progress : \(taskSnapshot.debugDescription)")
            }
        _ = uploadTask.observe(.failure) { (taskSnapshot) in
                print("Failure Snapshot : \(taskSnapshot.debugDescription)")
            }
       }else{
        let ac = UIAlertController(title: "Upload Failed!", message: "Your Canvas will be automatically uploaded when connected to internet.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        ac.present()
        }
    }
    
    func presentWithInputAndUpload(){
        var textField : UITextField?
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Nice Work!!!", message: "Enter a name for your canvas Drawing", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            if(textField.text == nil){
                
            }
            textField.text = "Canvas Title..."
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(String(describing: textField!.text!))")
            
            self.FBUploadManager(userID: "\(String(describing: textField!.text!))", imageToUpload: self.neumorphCanvasBoard.takeSnapshot()!)
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
}

