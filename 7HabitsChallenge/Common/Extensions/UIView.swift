//
//  UIView.swift
//  ECATALOGUE
//
//  Created by Bui V Chanh on 27/07/2021.
//

import UIKit

extension UIView {
    func makeCircular() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = max(self.frame.size.height, self.frame.size.width) / 2.0
        self.clipsToBounds = true
    }

    func makeBorderRadius(_ radius: CGFloat) {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }

    func createSegment(startAngle: CGFloat, endAngle: CGFloat, arcCenter: CGPoint, radius: CGFloat) -> UIBezierPath {
        return UIBezierPath(arcCenter: arcCenter,
                            radius: radius,
                            startAngle: startAngle.toRadians(),
                            endAngle: endAngle.toRadians(),
                            clockwise: true)
    }

    func createCircle(startAngle: CGFloat, endAngle: CGFloat, arcCenter: CGPoint, radius: CGFloat) {
        let segmentPath = self.createSegment(startAngle: startAngle, endAngle: endAngle, arcCenter: arcCenter, radius: radius)
        let segmentLayer = CAShapeLayer()
        segmentLayer.path = segmentPath.cgPath
        segmentLayer.lineWidth = 15
        // segmentLayer.strokeColor = UIColor(rgb: 0xDFE7F5).cgColor
        segmentLayer.fillColor = UIColor.clear.cgColor
        segmentLayer.lineCap = .round
        layer.addSublayer(segmentLayer)
    }

    func createInnerCircle(startAngle: CGFloat, endAngle: CGFloat, arcCenter: CGPoint, radius: CGFloat) {
        let segmentPath = self.createSegment(startAngle: startAngle, endAngle: endAngle, arcCenter: arcCenter, radius: radius)
        let segmentLayer = CAShapeLayer()
        segmentLayer.path = segmentPath.cgPath
        segmentLayer.lineWidth = 15
        // segmentLayer.strokeColor = AppColor.blue.cgColor
        segmentLayer.fillColor = UIColor.clear.cgColor
        segmentLayer.lineCap = .round
        layer.addSublayer(segmentLayer)
    }
}
