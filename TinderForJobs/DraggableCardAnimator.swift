//
//  Animator.swift
//  TinderForJobs
//
//  Created by Emil Gräs on 01/07/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class DraggableCardAnimator {
    
    
    // MARK: - Properties
    
    
    private var cardView: DraggableCard
    private var centerOrigin: CGPoint
    private var screenWidth: CGFloat {
        get { return UIScreen.main.bounds.width }
    }
    private var screenCenter: CGPoint {
        get { return CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2) }
    }
    
    
    // MARK: - Constants
    
    
    private let threshold: CGFloat = 100.0
    
    
    // MARK: - Life Cycle
    
    
    init(view: DraggableCard) {
        cardView = view
        centerOrigin = view.center
    }
    
    
    // MARK: - Public Methods
    
    
    public func beganMoving(withTranslation translation: CGPoint) {
        
    }
    
    public func isMoving(withTranslation translation: CGPoint) {
        cardView.center = CGPoint(x: (cardView.frame.width / 2) + translation.x, y: (cardView.frame.height / 2) + translation.y)
    }
    
    public func endedMoving(withTranslation translation: CGPoint, direction: @escaping (_ direction: SwipeDirection) -> Void) {
        if translation.x > threshold {
            swipeRight(completion: { finished in
                if finished { direction(.right) }
            })
        }
            
        else if translation.x < -threshold {
            swipeLeft(completion: { finished in
                 if finished { direction(.left) }
            })
        }
            
        else {
            snapBack(completion: { finshed in
                if finshed { direction(.none) }
            })
        }
    }
    
    
    // MARK: - Private Methods
    
    
    private func snapBack(completion: @escaping (_ finished: Bool) -> Void) {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseOut], animations: {
            self.cardView.center = self.centerOrigin
        }, completion: { finished in
            completion(finished)
        })
    }
    
    private func swipeLeft(completion: @escaping (_ finished: Bool) -> Void) {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: [.curveEaseOut], animations: {
            self.cardView.center.x -= self.screenWidth
        }, completion: { finished in
            completion(finished)
        })
    }
    
    private func swipeRight(completion: @escaping (_ finished: Bool) -> Void) {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: [.curveEaseOut], animations: {
            self.cardView.center.x += self.screenWidth
        }, completion: { finished in
            completion(finished)
        })
    }
    
}
