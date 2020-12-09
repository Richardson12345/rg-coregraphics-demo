//
//  DrawView.swift
//  RG-coregraphics-ppt
//
//  Created by mac on 08/12/20.
//

import UIKit

class DrawView: UIView {
    
    override func draw(_ rect: CGRect) {
        guard let currentContext = UIGraphicsGetCurrentContext() else { return }
        drawShape(with: currentContext)
    }
    
    private func drawShape(with context: CGContext) {
        let strokeDistance: CGFloat = 20
        
        let centerPoint = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        
        let lowerLeftCorner = CGPoint(x: centerPoint.x - strokeDistance, y: centerPoint.y + strokeDistance)
        
        let lowerRightCorner = CGPoint(x: centerPoint.x + strokeDistance, y: centerPoint.y + strokeDistance)
        
        let upperRightCorner = CGPoint(x: centerPoint.x + strokeDistance, y: centerPoint.y - strokeDistance * 2)
        
        let upperLeftCorner = CGPoint(x: centerPoint.x - strokeDistance, y: centerPoint.y - strokeDistance * 2)
        
        context.move(to: lowerLeftCorner)
        context.addLine(to: lowerLeftCorner)
        context.addLine(to: lowerRightCorner)
        context.addLine(to: upperRightCorner)
        context.addLine(to: upperLeftCorner)
        context.addLine(to: lowerLeftCorner)
        
        context.setLineCap(.round)
        context.setLineWidth(5)
        
        context.setFillColor(UIColor.green.cgColor)
        
        context.fillPath()
    }
    
    internal func startDraw() {
        setNeedsDisplay()
    }
}
