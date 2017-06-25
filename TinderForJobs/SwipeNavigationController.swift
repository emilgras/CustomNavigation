//
//  ViewController.swift
//  SwipeNavigationController
//
//  Created by Emil Gräs on 20/06/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

protocol SwipeNavigationControllerDataSource: NSObjectProtocol {
    func swipeControllers() -> (left: UIViewController, center: UIViewController, right: UIViewController)
    func swipeNavigationBarImages() -> (left: UIImage, center: UIImage, right: UIImage)
}

@objc protocol SwipeNavigationControllerDelegate: NSObjectProtocol {
    @objc optional func swipeNavigationController(_ controller: SwipeNavigationController, didMoveToControllerWithIndex index: Int)
    @objc optional func swipeNavigationController(_ controller: SwipeNavigationController, didBeginSwipeWithProgress progress: CGFloat)
}

protocol SwipeNavigationControllerVisualEffectsDelegate: NSObjectProtocol {
    func gradientPoints() -> (startPoint: CGPoint, endPoint: CGPoint)
    func gradientColors() -> [CGColor]
}


open class SwipeNavigationController: UIViewController {

    
    // MARK: - Instance variables
    
    
    var viewControllers: (left: UIViewController, center: UIViewController, right: UIViewController)?
    var currentIndex: Int = 1
    var bounces: Bool = true
    var backgroundColor: UIColor = UIColor(red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1.0) {
        didSet {
            view.backgroundColor = backgroundColor
        }
    }
    
    
    // MARK: - Constants
    
    
    private let swipeNavigationBarHeight: CGFloat = 80
    private var swipeBackgroundEffectProportionalHeight: CGFloat { get { return view.frame.height * 0.32 } }
    
    
    // MARK: - DataSource & Delegates
    
    
    weak var delegate: SwipeNavigationControllerDelegate?
    weak var dataSource: SwipeNavigationControllerDataSource?
    weak var visualEffectsDelegate: SwipeNavigationControllerVisualEffectsDelegate?
    
    
    // MARK: - UI Components
    
    
    var backgroundEffectsView: SwipeNavigationBackgroundEffects = {
        let v = SwipeNavigationBackgroundEffects()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var swipeNavigationBar: SwipeNavigationBar = {
        let nav = SwipeNavigationBar()
        nav.translatesAutoresizingMaskIntoConstraints = false
        return nav
    }()
    
    var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.bounces = true
        sv.isPagingEnabled = true
        sv.backgroundColor = UIColor.clear
        sv.showsHorizontalScrollIndicator = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    // MARK: - Override Properties
    
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - Life Cycle
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Setup Methods
    
    
    private func setup() {
        setupSwipeBackgroundEffect()
        setupScrollView()
        setupSwipeViewControllers()
        setupSwipeNavigationBar()
        setupAppearance()
    }
    
    private func setupSwipeBackgroundEffect() {
        backgroundEffectsView.setupAppearance(visualEffectsDelegate)
        view.addSubview(backgroundEffectsView)
        NSLayoutConstraint.activate([
        backgroundEffectsView.topAnchor.constraint(equalTo: view.topAnchor),
        backgroundEffectsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        backgroundEffectsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        backgroundEffectsView.heightAnchor.constraint(equalToConstant: swipeBackgroundEffectProportionalHeight) ])
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        scrollView.topAnchor.constraint(equalTo: view.topAnchor),
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor) ])
        scrollView.layoutIfNeeded()
        scrollView.contentOffset.x = view.frame.width
        scrollView.delegate = self
    }
    
    
    private func setupSwipeViewControllers() {
        guard let viewControllers = dataSource?.swipeControllers() else { return }
        let leftVC = viewControllers.left
        let centerVC = viewControllers.center
        let rightVC = viewControllers.right
        self.viewControllers = (left: leftVC, center: centerVC, right: rightVC)
        
        var previousView: UIView! = nil
        for (index, vc) in [leftVC, centerVC, rightVC].enumerated() {
            let view = vc.view!
            scrollView.addSubview(view)
            addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            
            view.translatesAutoresizingMaskIntoConstraints = false
            var constraints:[NSLayoutConstraint] = []
            constraints.append(view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: swipeNavigationBarHeight))
            constraints.append(view.leadingAnchor.constraint(equalTo: index == 0 ? scrollView.leadingAnchor : previousView.trailingAnchor))
            constraints.append(view.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor))
            constraints.append(view.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor, constant: -swipeNavigationBarHeight))
            if index == 2 {
                constraints.append(view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor))
            }
            NSLayoutConstraint.activate(constraints)
            previousView = view
        }
    }

    private func setupSwipeNavigationBar() {
        swipeNavigationBar.dataSource = self
        swipeNavigationBar.delegate = self
        scrollView.addSubview(swipeNavigationBar)
        NSLayoutConstraint.activate([
        swipeNavigationBar.topAnchor.constraint(equalTo: view.topAnchor),
        swipeNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        swipeNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        swipeNavigationBar.heightAnchor.constraint(equalToConstant: swipeNavigationBarHeight) ])
    }
    
    private func setupAppearance() {
        view.backgroundColor = backgroundColor
    }

}

extension SwipeNavigationController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        let width = view.frame.width
        let progress = (contentOffsetX - width) / width
        delegate?.swipeNavigationController?(self, didBeginSwipeWithProgress: progress)
        backgroundEffectsView.updateProgress(progress)
        swipeNavigationBar.updateProgress(progress)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrolledTo = Int(scrollView.contentOffset.x / view.frame.width)
        if scrolledTo != currentIndex {
            currentIndex = scrolledTo
            delegate?.swipeNavigationController?(self, didMoveToControllerWithIndex: currentIndex)
        }
    }
}

extension SwipeNavigationController: SwipeNavigationBarDataSource {
    func swipeNavigationBarImages() -> (left: UIImage, center: UIImage, right: UIImage) {
        return dataSource!.swipeNavigationBarImages()
    }
}

extension SwipeNavigationController: SwipeNavigationBarDelegate {
    func swipeNavigationBar(_ navigationBar: SwipeNavigationBar, didSelectMenuWithIndex index: Int) {
        if currentIndex != index {
            scrollView.setContentOffset(pointFromIndex(index), animated: true)
            delegate?.swipeNavigationController?(self, didMoveToControllerWithIndex: currentIndex)
        }
    }
    
    private func pointFromIndex(_ index: Int) -> CGPoint {
        switch index {
        case 0: currentIndex = index; return CGPoint(x: 0, y: 0)
        case 1: currentIndex = index; return CGPoint(x: view.frame.width, y: 0)
        default: currentIndex = index; return CGPoint(x: view.frame.width * 2, y: 0)
        }
    }
}


