//
//  BackgroundEffectsView.swift
//  SwipeNavigationController
//
//  Created by Emil Gräs on 21/06/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class SwipeNavigationBackgroundEffects: UIView {

    
    // MARK: - UI Components
    
    
    private var shapeLayer: CAShapeLayer = {
        return CAShapeLayer()
    }()
    
    private var gradientLayer: CAGradientLayer = {
        return CAGradientLayer()
    }()
    
    
    // MARK: - Life Cycle

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
    }
    
    override func draw(_ rect: CGRect) {
        setupLayer()
    }
    
    
    // MARK: - Helper Methods

    
    private func setupLayer() {
        shapeLayer.path = bezierPathForControlPoints(withProgress: 0.0).cgPath
        gradientLayer.frame = self.frame
        layer.addSublayer(gradientLayer)
        layer.mask = shapeLayer
    }
    
    private func bezierPathForControlPoints(withProgress progress: CGFloat) -> UIBezierPath {
        // static top positions
        let constraintedProgress = max(0, min(1, abs(progress)))
        let topLeft = CGPoint(x: 0, y: 0)
        let topRight = CGPoint(x: self.frame.width, y: 0)
        
        // update positions - bottomLeft
        let bottomLeftLower: CGFloat = 100
        let bottomLeftUpper: CGFloat = self.frame.height
        let bottomeLftY = ((bottomLeftUpper - bottomLeftLower) * constraintedProgress) + 100
        let bottomLeft = CGPoint(x: 0, y: bottomeLftY)
        
        // update positions - bottomRight
        let bottomRightLower: CGFloat = 100
        let bottomRightUpper: CGFloat = self.frame.height
        let bottomRightY = self.frame.height - ((bottomRightUpper - bottomRightLower) * constraintedProgress)
        let bottomRight = CGPoint(x: self.frame.width, y: bottomRightY)
        
        // update positions - controlPoint
        let controlPointXLower: CGFloat = (self.frame.width / 2) - 35
        let controlPointXUpper: CGFloat = (self.frame.width / 2) + 35
        let controlPointX = controlPointXUpper - ((controlPointXUpper - controlPointXLower) * constraintedProgress)
        let controlPoint = CGPoint(x: controlPointX, y: 130)

        // bezier path
        let path = UIBezierPath()
        path.move(to: topLeft)
        path.addLine(to: bottomLeft)
        path.addQuadCurve(to: bottomRight, controlPoint: controlPoint)
        path.addLine(to: topRight)
        path.close()
        return path
    }
    
    private func gradientWithProgress(_ progress: CGFloat) -> (startPoint: CGPoint, endPoint: CGPoint) {
        var startPoint = CGPoint()
        var endPoint = CGPoint()
        
        let startPointXMin: CGFloat = 0.4
        let startPointXMax: CGFloat = 0.6
        
        startPoint.x = (progress * (startPointXMax - startPointXMin) + startPointXMin)
        endPoint.x = 1 - (progress * 1)
        return (startPoint, endPoint)
    }
    
    
    // MARK: - Public Methods
    
    
    func updateProgress(_ progress: CGFloat) {
        // gradient layer
        let points = gradientWithProgress(abs(progress))
        gradientLayer.startPoint = CGPoint(x: points.startPoint.x, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: points.endPoint.x, y: 1.0)
        
        // shape layer
        shapeLayer.path = bezierPathForControlPoints(withProgress: abs(progress)).cgPath
        layer.mask = shapeLayer
    }
    
    func setupAppearance(_ delegate: SwipeNavigationControllerVisualEffectsDelegate?) {
        guard let delegate = delegate else { return }
        gradientLayer.startPoint = delegate.gradientPoints().startPoint
        gradientLayer.endPoint = delegate.gradientPoints().endPoint
        gradientLayer.colors = delegate.gradientColors()
        setupLayer()
    }


}

