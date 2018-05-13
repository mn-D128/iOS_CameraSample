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
    
    private func drawLine(start: Int, end: Int, rate: CGFloat, offset: CGPoint, face: DLBFace, isClose: Bool = false) {
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
        
        if isClose {
            path.close()
        }
        
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
            self.drawLine(start: DLBPartPosition.jawStart.rawValue,
                          end: DLBPartPosition.jawEnd.rawValue,
                          rate: rate,
                          offset: offset,
                          face: face)
            // 左の眉毛
            self.drawLine(start: DLBPartPosition.leftEyebrowsStart.rawValue,
                          end: DLBPartPosition.leftEyebrowsEnd.rawValue,
                          rate: rate,
                          offset: offset,
                          face: face)
            // 右の眉毛
            self.drawLine(start: DLBPartPosition.rightEyebrowsStart.rawValue,
                          end: DLBPartPosition.rightEyebrowsEnd.rawValue,
                          rate: rate,
                          offset: offset,
                          face: face)
            
            // 鼻 縦
            self.drawLine(start: 27,
                          end: 30,
                          rate: rate,
                          offset: offset,
                          face: face)
            
            // 鼻 横
            self.drawLine(start: 31,
                          end: 35,
                          rate: rate,
                          offset: offset,
                          face: face)
            
            // 左目
            self.drawLine(start: DLBPartPosition.leftEyeStart.rawValue,
                          end: DLBPartPosition.leftEyeEnd.rawValue,
                          rate: rate,
                          offset: offset,
                          face: face,
                          isClose: true)
            
            // 右目
            self.drawLine(start: DLBPartPosition.rightEyeStart.rawValue,
                          end: DLBPartPosition.rightEyeEnd.rawValue,
                          rate: rate,
                          offset: offset,
                          face: face,
                          isClose: true)
            
            // 口 外周
            self.drawLine(start: 48,
                          end: 59,
                          rate: rate,
                          offset: offset,
                          face: face,
                          isClose: true)
            
            // 口 内周
            self.drawLine(start: 60,
                          end: 67,
                          rate: rate,
                          offset: offset,
                          face: face,
                          isClose: true)
            
            // 左目 右目
            print("左目 \(face.leftEyeOpeningDegree) 右目 \(face.rightEyeOpeningDegree)")
        }
    }
    
}
