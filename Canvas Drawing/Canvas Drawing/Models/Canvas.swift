//
//  Canvas.swift
//  Canvas Drawing
//
//  Created by phani srikar on 21/06/20.
//  Copyright © 2020 phani srikar. All rights reserved.
//

import Foundation
import UIKit

/**
    A UIView class  to to draw any kinds of drawings.
 
        - Parameter:  we can set the size, color, width of the brush to draw on the canvas.
 */
class Canvas: UIView {
    var strokeColor : UIColor = UIColor.black
    var strokeWidth : Float = 1
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
        guard var lastLine = lines.popLast() else { return }
        lastLine.points.append(point)
        lines.append(lastLine)

        setNeedsDisplay()
    }
    /**
        Clears the canvas clean and makes it ready start drawing again.
     */
    public func clearCanvas(){
        lines.removeAll()
    }
}
