//
//  CardView.swift
//  TinderForJobs
//
//  Created by Emil Gräs on 25/06/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit


public protocol CardViewDataSource: NSObjectProtocol {
    func cardViewNumberOfCards(_ cardView: CardView) -> Int
    func cardView(_ cardView: CardView, viewForCardAt index: Int) -> UIView
    func cardView(_ cardView: CardView, viewForCardOverlayAt index: Int) -> UIView?
}


public protocol CardViewDelegate: NSObjectProtocol {
    
}


open class CardView: UIView {
    
    
    // MARK: - Properties
    
    
    weak var dataSource: CardViewDataSource? { didSet { setupDeck() } }
    weak var delegate: CardViewDelegate?
    private var currentCardIndex: Int = 0
    private var loadedCards = [DraggableCardView]()
    
    
    
    // MARK: - Life Cycle
    
    
    open override func layoutSubviews() {
    }
    
    
    // MARK: - Setup Methods
    
    
    private func setupDeck() {
        guard let dataSource = dataSource else { return }
        
    }

    
}
