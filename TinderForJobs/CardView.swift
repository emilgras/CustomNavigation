//
//  CardView.swift
//  TinderForJobs
//
//  Created by Emil Gräs on 25/06/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit


public protocol CardViewDataSource: class {
    func cardViewNumberOfCards(_ cardView: CardView) -> Int
    func cardView(_ cardView: CardView, viewForCardAt index: Int) -> UIView
    func cardView(_ cardView: CardView, viewForCardOverlayAt index: Int) -> UIView?
}


public protocol CardViewDelegate: class {
    
}


open class CardView: UIView {
    
    
    // MARK: - Properties
    
    
    weak var dataSource: CardViewDataSource? { didSet { setupDeck() } }
    weak var delegate: CardViewDelegate?
    private var numberOfCards: Int = 0
    private var currentCardIndex: Int = 0
    private var loadedCards = [DraggableCardView]()
    
    
    
    // MARK: - Life Cycle
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open override func layoutSubviews() {
    }
    
    
    // MARK: - Setup Methods
    
    
    private func setup() {
        setupDeck()
        createCard()
    }
    
    private func setupDeck() {
        guard let dataSource = dataSource else { return }
    }
    
    private func createCard() {
        let card = DraggableCardView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        card.backgroundColor = .white
        card.layer.cornerRadius = 8
        card.layer.masksToBounds = false
        card.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        card.layer.shadowColor = UIColor.lightGray.cgColor
        card.layer.shadowOpacity = 0.2
        card.layer.shadowRadius = 8
        addSubview(card)
    }

    
}
