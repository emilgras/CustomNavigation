//
//  ViewController.swift
//  TinderForJobs
//
//  Created by Emil Gräs on 25/06/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class SwipeNavigationVC: UIViewController {

    private let swipeController = SwipeNavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwipeController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupSwipeController() {
        swipeController.dataSource = self
        swipeController.delegate = self
        swipeController.visualEffectsDelegate = self
        addChildViewController(swipeController)
        view.addSubview(swipeController.view)
        swipeController.didMove(toParentViewController: self)
    }
}


extension SwipeNavigationVC: SwipeNavigationControllerDataSource {
    func swipeControllers() -> (left: UIViewController, center: UIViewController, right: UIViewController) {
        let profileVC = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        let cardsVC = storyboard?.instantiateViewController(withIdentifier: "CardsVC") as! CardsVC
        let matchesVC = storyboard?.instantiateViewController(withIdentifier: "MatchesVC") as! MatchesVC
        return (left: profileVC, center: cardsVC, right: matchesVC)
    }
    
    func swipeNavigationBarImages() -> (left: UIImage, center: UIImage, right: UIImage) {
        return (left: UIImage(named: "icon")!, center: UIImage(named: "icon")!, right: UIImage(named: "icon")!)
    }
}

extension SwipeNavigationVC: SwipeNavigationControllerDelegate {
    func swipeNavigationController(_ controller: SwipeNavigationController, didMoveToControllerWithIndex index: Int) {
    }
    
    func swipeNavigationController(_ controller: SwipeNavigationController, didBeginSwipeWithProgress progress: CGFloat) {
    }
}

extension SwipeNavigationVC: SwipeNavigationControllerVisualEffectsDelegate {
    func gradientPoints() -> (startPoint: CGPoint, endPoint: CGPoint) {
        return (CGPoint(x: 0.4, y: -0.4), CGPoint(x: 1.0, y: 1.6))
    }
    
    func gradientColors() -> [CGColor] {
        return [
            UIColor(red: 190/255.0, green: 50/255.0, blue: 127/255.0, alpha: 1.0).cgColor,
            UIColor(red: 244/255.0, green: 44/255.0, blue: 103/255.0, alpha: 1.0).cgColor ]
    }
}

