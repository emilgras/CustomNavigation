//
//  SwipeNavigationBar.swift
//  SwipeNavigationController
//
//  Created by Emil Gräs on 22/06/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

protocol SwipeNavigationBarDataSource: NSObjectProtocol {
    func swipeNavigationBarImages() -> (left: UIImage, center: UIImage, right: UIImage)
}

protocol SwipeNavigationBarDelegate: NSObjectProtocol {
    func swipeNavigationBar(_ navigationBar: SwipeNavigationBar, didSelectMenuWithIndex index: Int)
}

class SwipeNavigationBar: UIView {

    
    // MARK: - Properties
    
    
    var navigationBarImageViews = [UIImageView]()
    var animatableXConstraints = [NSLayoutConstraint]()
    var animatableWidthConstraints = [NSLayoutConstraint]()
    var animatableHeightConstraints = [NSLayoutConstraint]()
    var imageViewInterSpacing: CGFloat { get { return (frame.width / 2) - (imageViewBigWidth / 2) - spaceToEdge } }
    
    
    // MARK: - Constants
    
    
    let imageViewBigWidth: CGFloat = 30
    let imageViewSmallWidth: CGFloat = 22
    let spaceToEdge: CGFloat = 20

    
    // MARK: - Delegates
    
    
    weak var dataSource: SwipeNavigationBarDataSource? { didSet { setupSwipeNavigationBarImages() } }
    weak var delegate: SwipeNavigationBarDelegate?
    
    
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
        setupAppearance()
    }
    
    override func draw(_ rect: CGRect) {
    }
    
    
    // MARK: - Setup Methods

    
    private func setupSwipeNavigationBarImages() {
        guard let images = dataSource?.swipeNavigationBarImages() else { return }
        
        let wrapperView = UIView()
        addSubview(wrapperView)
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.backgroundColor = .clear
        NSLayoutConstraint.activate([
        wrapperView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
        wrapperView.leadingAnchor.constraint(equalTo: leadingAnchor),
        wrapperView.bottomAnchor.constraint(equalTo: bottomAnchor),
        wrapperView.trailingAnchor.constraint(equalTo: trailingAnchor)])
        
        for (index, image) in [images.left, images.center, images.right].enumerated() {
            let imageView = UIImageView()
            imageView.tag = index
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SwipeNavigationBar.handleTap)))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            wrapperView.addSubview(imageView)
        
            var constraints:[NSLayoutConstraint] = []
            
            if      index == 0  {
                let leadingConstraint = imageView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: spaceToEdge)
                let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: self.imageViewSmallWidth)
                let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: self.imageViewSmallWidth)
                constraints.append(leadingConstraint)
                constraints.append(widthConstraint)
                constraints.append(heightConstraint)
                animatableXConstraints.append(leadingConstraint)
                animatableWidthConstraints.append(widthConstraint)
                animatableHeightConstraints.append(heightConstraint)}
                
            else if index == 1  {
                let leadingConstraint = imageView.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor)
                let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: self.imageViewBigWidth)
                let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: self.imageViewBigWidth)
                constraints.append(leadingConstraint)
                constraints.append(widthConstraint)
                constraints.append(heightConstraint)
                animatableXConstraints.append(leadingConstraint)
                animatableWidthConstraints.append(widthConstraint)
                animatableHeightConstraints.append(heightConstraint)}
                
            else if index == 2  {
                let leadingConstraint = imageView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -spaceToEdge)
                let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: self.imageViewSmallWidth)
                let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: self.imageViewSmallWidth)
                constraints.append(leadingConstraint)
                constraints.append(widthConstraint)
                constraints.append(heightConstraint)
                animatableXConstraints.append(leadingConstraint)
                animatableWidthConstraints.append(widthConstraint)
                animatableHeightConstraints.append(heightConstraint)}
            
            constraints.append(imageView.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor))
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    private func setupAppearance() {
        backgroundColor = .clear
    }
    
    
    // MARK: - Helper Methods
    
    
    func updateProgress(_ progress: CGFloat) {
        // x-location
        animatableXConstraints[0].constant = spaceToEdge - imageViewInterSpacing * progress
        animatableXConstraints[1].constant = -imageViewInterSpacing * progress
        animatableXConstraints[2].constant = -spaceToEdge - imageViewInterSpacing * progress
        
        // width-scale
        animatableWidthConstraints[0].constant = min(imageViewBigWidth, imageViewSmallWidth + ((imageViewBigWidth - imageViewSmallWidth) * abs(progress)))
        animatableHeightConstraints[0].constant = min(imageViewBigWidth, imageViewSmallWidth + ((imageViewBigWidth - imageViewSmallWidth) * abs(progress)))
        animatableWidthConstraints[1].constant = max(imageViewSmallWidth, imageViewBigWidth - ((imageViewBigWidth - imageViewSmallWidth) * abs(progress)))
        animatableHeightConstraints[1].constant = max(imageViewSmallWidth, imageViewBigWidth - ((imageViewBigWidth - imageViewSmallWidth) * abs(progress)))
        animatableWidthConstraints[2].constant = min(imageViewBigWidth, imageViewSmallWidth + ((imageViewBigWidth - imageViewSmallWidth) * abs(progress)))
        animatableHeightConstraints[2].constant = min(imageViewBigWidth, imageViewSmallWidth + ((imageViewBigWidth - imageViewSmallWidth) * abs(progress)))
        layoutIfNeeded()
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }
        delegate?.swipeNavigationBar(self, didSelectMenuWithIndex: imageView.tag)
    }

}

