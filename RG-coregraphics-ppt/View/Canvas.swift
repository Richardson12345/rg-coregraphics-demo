//
//  Canvas.swift
//  RG-coregraphics-ppt
//
//  Created by mac on 07/12/20.
//

import UIKit

class Canvas: UIView {
    
    // public func
    fileprivate var strokeColor = UIColor.black
    fileprivate var strokeWidth: Float = 1
    
    func setStrokeWidth(width: Float) {
        strokeWidth = width
    }
    
    func setStrokeColor(color: UIColor) {
        strokeColor = color
    }
    
    func undo() {
        _ = lines.popLast()
        setNeedsDisplay()
    }
    
    func clear () {
        lines.removeAll()
        setNeedsDisplay()
    }
    
    var line = [CGPoint]()
    
    var lines = [Line]()
    
    override func draw(_ rect: CGRect) {
        // custom drawing
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // here are my lines
        //        let startPoint = CGPoint(x: 0, y: 0)
        //        let endPoint = CGPoint(x: 100, y: 100)
        //
        //        context.move(to: startPoint)
        //        context.addLine(to: endPoint)
        //
        //        context.strokePath()
        
        lines.forEach { (line) in
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(CGFloat(line.strokeWidth))
            context.setLineCap(.round)
            for (i, p) in line.points.enumerated() {
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
            context.strokePath()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(Line(strokeWidth: strokeWidth, color: strokeColor, points: []))
    }
    
    // track the finger as we move across screen
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else { return }
        
        guard var lastLine = lines.popLast() else { return }
        lastLine.points.append(point)
        
        lines.append(lastLine)
        
        line.append(point)
        
        setNeedsDisplay()
    }
    
}

/* star
 {{ 5, 5},   {10, 15},// 7
 {10, 15},  {15, 5},
 {15, 5},   {2.5, 11},
 {2.5, 11}, {16.5, 11},
 {16.5, 11},{5, 5}};

 */
