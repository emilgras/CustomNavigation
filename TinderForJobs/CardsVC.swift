//
//  CardsVC.swift
//  TinderForJobs
//
//  Created by Emil Gräs on 25/06/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class CardsVC: UIViewController {

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
    
    
    func cardViewNumberOfCards(_ cardView: CardView) -> Int {
        return 5
    }
    
    func cardView(_ cardView: CardView, viewForCardAt index: Int) -> UIView {
        return UIView()
    }
    
    func cardView(_ cardView: CardView, viewForCardOverlayAt index: Int) -> UIView? {
        return UIView()
    }
    
    
}


extension CardsVC: CardViewDelegate {
    
}
