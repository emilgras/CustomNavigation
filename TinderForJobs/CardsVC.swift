//
//  CardsVC.swift
//  TinderForJobs
//
//  Created by Emil Gräs on 25/06/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class CardsVC: UIViewController {

    var dummyColors = [
        UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0),
        UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0),
        UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
    ]
    
    @IBOutlet weak var cardView: CardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.dataSource = self
        cardView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


extension CardsVC: CardViewDataSource {
    
    
    func numberOfCards(in cardView: CardView) -> Int {
        return dummyColors.count
    }
    
    func cardView(_ cardView: CardView, viewForCardAt index: Int) -> UIView {
        guard let view = cardView.reusableViewForCard(at: index) else { print("Nooo");return UIView() }
        view.backgroundColor = dummyColors[index]
        return view
    }
    
    func cardView(_ cardView: CardView, viewForCardOverlayAt index: Int) -> UIView? {
        return UIView()
    }
    
    
}


extension CardsVC: CardViewDelegate {
    
    
    func didRunOutOfCards(in cardView: CardView) {
        
    }

    func cardView(_ cardView: CardView, didSelectCardAt index: Int) {
        
    }
    
    func loadingView(in cardView: CardView) -> UIView {
        return UIView()
    }

    
}
