//
//  DraggableCard.swift
//  TinderForJobs
//
//  Created by Emil Gräs on 25/06/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit


public enum SwipeDirection {
    case none
    case left
    case right
}


public protocol DraggableCardDelegate: class {
    func didSwipe(in direction: SwipeDirection)
}


class DraggableCard: UIView {

    
    // MARK: - Properties
    
    
    weak var delegate: DraggableCardDelegate?
    private var animator: DraggableCardAnimator!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var tapGestureRecognizer: UITapGestureRecognizer!
    
    
    // MARK: - Constants
    
    
    let threshold: CGFloat = 150.0
    
    
    // MARK: - UI Components
    
    
    var contentView: UIView?
    var overlayView: UIView?
    
    
    // MARK: - Life Cycle
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        removeGestureRecognizer(panGestureRecognizer)
        removeGestureRecognizer(tapGestureRecognizer)
    }
    
    
    // MARK: - Setup Methods
    
    
    private func setup() {
        animator = DraggableCardAnimator(view: self)
        setupGestureRecognizers()
        setupAppearance()
    }
    
    private func setupGestureRecognizers() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DraggableCard.handlePan))
        addGestureRecognizer(panGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DraggableCard.handleTap))
        tapGestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupOverlayView(_ overlay: UIView) {
        NSLayoutConstraint.activate([
        overlay.topAnchor.constraint(equalTo: topAnchor),
        overlay.leadingAnchor.constraint(equalTo: leadingAnchor),
        overlay.bottomAnchor.constraint(equalTo: bottomAnchor),
        overlay.trailingAnchor.constraint(equalTo: trailingAnchor)])
    }
    
    private func setupContentView(_ view: UIView) {
        NSLayoutConstraint.activate([
        view.topAnchor.constraint(equalTo: topAnchor),
        view.leadingAnchor.constraint(equalTo: leadingAnchor),
        view.bottomAnchor.constraint(equalTo: bottomAnchor),
        view.trailingAnchor.constraint(equalTo: trailingAnchor)])
    }
    
    private func setupAppearance() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8
    }
    
    
    // MARK: - Gesture Methods
    
    
    @objc private func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self)
        switch gestureRecognizer.state {
        
        case .began:
            animator.beganMoving(withTranslation: translation)
            
        case .changed:
            animator.isMoving(withTranslation: translation)
            
        case .ended:
            animator.endedMoving(withTranslation: translation, direction: { direction in
                
                self.delegate?.didSwipe(in: direction)
                
            })
  
        default: break
        }
    }
    
    @objc private func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        
    }
    
    
    // MARK: - Configurations
    
    
    func configure(contentView view: UIView, andOverlayView overlay: UIView?) {
        self.overlayView?.removeFromSuperview()
        self.contentView?.removeFromSuperview()
        
        if let overlay = overlayView {
            self.overlayView = overlay
            overlay.alpha = 0;
            self.addSubview(overlay)
            setupOverlayView(overlay)
            self.insertSubview(view, belowSubview: overlay)
        } else {
            self.addSubview(view)
        }

        self.contentView = view
        setupContentView(view)
    }


}
