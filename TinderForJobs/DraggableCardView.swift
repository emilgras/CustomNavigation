//
//  DraggableCardView.swift
//  TinderForJobs
//
//  Created by Emil Gräs on 25/06/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class DraggableCardView: UIView {

    
    // MARK: - Properties
    
    
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var centerLocation: CGPoint!
    
    
    // MARK: - Life Cycle
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        removeGestureRecognizer(panGestureRecognizer)
        removeGestureRecognizer(tapGestureRecognizer)
    }
    
    
    // MARK: - Setup Methods
    
    
    private func setup() {
        centerLocation = self.center
        setupGestureRecognizers()
    }
    
    private func setupGestureRecognizers() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DraggableCardView.handlePan))
        addGestureRecognizer(panGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DraggableCardView.handleTap))
        tapGestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    // MARK: - Gesture Methods
    
    
    @objc private func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self)
//        let location = gestureRecognizer.location(in: self)
        switch gestureRecognizer.state {
        case .began:
            break
            
        case .changed:
            self.center = CGPoint(x: (self.frame.width / 2) + translation.x, y: (self.frame.height / 2) + translation.y)
            
        case .ended:
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: [.curveEaseOut], animations: { 
                self.center = self.centerLocation
            }, completion: nil)
        
        default: break
        }
    }
    
    @objc private func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        
    }

}
