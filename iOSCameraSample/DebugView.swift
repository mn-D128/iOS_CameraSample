//
//  DebugView.swift
//  iOSCameraSample
//
//  Created by mn(D128) on 2018/05/13.
//  Copyright © 2018年 mn(D128). All rights reserved.
//

import UIKit

class DebugView: UIView {

    // MARK: - Public
    
    var imageSize: CGSize? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var faces: [DLBFace] = [DLBFace]() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    // MARK: - Private
    
    private func drawLine(start: Int, end: Int, rate: CGFloat, offset: CGPoint, face: DLBFace) {
        let path: UIBezierPath = UIBezierPath();
        path.lineWidth = 1.0
        
        for index in start ... end {
            let point: CGPoint = face.parts[index].cgPointValue
            let ratePoint: CGPoint = CGPoint(x: offset.x + point.x * rate,
                                             y: offset.y + point.y * rate)
            
            switch index {
            case start:
                path.move(to: ratePoint)
                
            default:
                path.addLine(to: ratePoint)
            }
        }
        
        //path.close()
        path.stroke()
    }
    
    // MARK: - UIView
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let imageSize: CGSize = self.imageSize else {
            return
        }
        
        let rate: CGFloat = min(rect.size.width / imageSize.width,
                                rect.size.height / imageSize.height)
        
        let offset: CGPoint = CGPoint(x: (rect.size.width - imageSize.width * rate) / 2.0,
                                      y: (rect.size.height - imageSize.height * rate) / 2.0)
        
        UIColor.green.setStroke()
        
        for face: DLBFace in self.faces {
            // 顔の矩形
            let areaRect: CGRect = CGRect(x: offset.x + face.area.origin.x * rate,
                                          y: offset.y + face.area.origin.y * rate,
                                          width: face.area.size.width * rate,
                                          height: face.area.size.height * rate)
            
            let areaPath: UIBezierPath = UIBezierPath(rect: areaRect)
            areaPath.lineWidth = 1.0
            areaPath.stroke()
            
            // 顔の輪郭
            self.drawLine(start: DLBPartPosition.contourStart.rawValue,
                          end: DLBPartPosition.contourEnd.rawValue,
                          rate: rate,
                          offset: offset,
                          face: face)
            // 左の眉毛
            self.drawLine(start: DLBPartPosition.eyebrowsLeftStart.rawValue,
                          end: DLBPartPosition.eyebrowsLeftEnd.rawValue,
                          rate: rate,
                          offset: offset,
                          face: face)
            // 右の眉毛
            self.drawLine(start: DLBPartPosition.eyebrowsRightStart.rawValue,
                          end: DLBPartPosition.eyebrowsRightEnd.rawValue,
                          rate: rate,
                          offset: offset,
                          face: face)
        }
    }
    
}
