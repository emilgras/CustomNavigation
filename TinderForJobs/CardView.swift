//
//  CardView.swift
//  TinderForJobs
//
//  Created by Emil Gräs on 25/06/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit


public protocol CardViewDataSource: class {
    func numberOfCards(in cardView: CardView) -> Int
    func cardView(_ cardView: CardView, viewForCardAt index: Int) -> UIView
    func cardView(_ cardView: CardView, viewForCardOverlayAt index: Int) -> UIView?
}


@objc public protocol CardViewDelegate: class {
    @objc optional func cardView(_ cardView: CardView, didSelectCardAt index: Int)
    @objc optional func cardView(_ cardView: CardView, didShowCardAt index: Int)
    @objc optional func didRunOutOfCards(in cardView: CardView)
    @objc optional func loadingView(in cardView: CardView) -> UIView
}


open class CardView: UIView {
    
    
    // MARK: - Properties
    
    
    weak var dataSource: CardViewDataSource? { didSet { setupDeckOfCards() } }
    weak var delegate: CardViewDelegate?
    
    
    // MARK: - Private
    
    
    fileprivate var countOfCards: Int = 0
    fileprivate var currentCardIndex: Int = 0
    fileprivate var queueOfCards = [DraggableCard]()
    
    
    // MARK: - Constants
    
    
    fileprivate let countOfVisibleCards: Int = 3
    fileprivate let topIndex: Int = 0
    fileprivate let bottomIndex: Int = 2
    private let defaultBackgroundCardsTopMargin: CGFloat = 4.0
    private let defaultBackgroundCardsScalePercent: CGFloat = 0.95
    private let defaultBackgroundCardsLeftMargin: CGFloat = 8.0
    
    
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
        super.layoutSubviews()
        
    }
    
    private func setup() {
    }
    
    
    // MARK: - Configurations
    
    
    private func setupDeckOfCards() {
        guard let dataSource = dataSource else { return }
        countOfCards = dataSource.numberOfCards(in: self)
        var countOfNeededCards = countOfCards - currentCardIndex
        
        if countOfNeededCards > 0 {
            countOfNeededCards = min(countOfVisibleCards, countOfNeededCards)
            
            for index in 0..<countOfNeededCards {
                let actualIndex = index + currentCardIndex
                let nextCard = createCard(at: actualIndex)
                let isTop = index == topIndex
                nextCard.isUserInteractionEnabled = isTop
                queueOfCards.append(nextCard)
                configureCard(nextCard, at: index)
                isTop ? addSubview(nextCard) : insertSubview(nextCard, belowSubview: queueOfCards[index - 1])
//                setupCardConstraints(for: nextCard)
            }
            delegate?.cardView?(self, didShowCardAt: currentCardIndex)
        }
    }
    
//    private func setupCardConstraints(for card: DraggableCard) {
//        card.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//        card.leadingAnchor.constraint(equalTo: leadingAnchor),
//        card.trailingAnchor.constraint(equalTo: trailingAnchor),
//        card.topAnchor.constraint(equalTo: topAnchor),
//        card.bottomAnchor.constraint(equalTo: bottomAnchor),])
//    }
    
    public func layoutDeck() {
        for (index, card) in queueOfCards.enumerated() {
            layoutCard(card, at: index)
        }
    }
    
    private func layoutCard(_ card: DraggableCard, at index: Int) {
        if index == 0 {
            card.layer.transform = CATransform3DIdentity
            card.frame = frameForTopCard()
        } else {
            let cardParameters = backgroundCardParametersForFrame(frameForCard(at: index))
            let scale = cardParameters.scale
            card.layer.transform = CATransform3DScale(CATransform3DIdentity, scale.width, scale.height, 1.0)
            card.frame = cardParameters.frame
        }
    }
    
    
    // MARK: Frame Configuations
    
    
    func frameForCard(at index: Int) -> CGRect {
        let bottomOffset: CGFloat = 0
        let topOffset = defaultBackgroundCardsTopMargin * CGFloat(countOfVisibleCards - 1)
        let scalePercent = defaultBackgroundCardsScalePercent
        let width = self.frame.width * pow(scalePercent, CGFloat(index))
        let xOffset = (self.frame.width - width) / 2
        let height = (self.frame.height - bottomOffset - topOffset) * pow(scalePercent, CGFloat(index))
        let multiplier: CGFloat = index > 0 ? 1.0 : 0.0
        let prevCardFrame = index > 0 ? frameForCard(at: max(index - 1, 0)) : .zero
        let yOffset = (prevCardFrame.height - height + prevCardFrame.origin.y + defaultBackgroundCardsTopMargin) * multiplier
        let frame = CGRect(x: xOffset, y: yOffset, width: width, height: height)
        
        return frame
    }
    
    func frameForTopCard() -> CGRect {
        return frameForCard(at: 0)
    }
    
    func backgroundCardParametersForFrame(_ initialFrame: CGRect) -> (frame: CGRect, scale: CGSize) {
        var finalFrame = frameForTopCard()
        finalFrame.origin = initialFrame.origin
        
        var scale = CGSize.zero
        scale.width = initialFrame.width / finalFrame.width
        scale.height = initialFrame.height / finalFrame.height
        
        return (finalFrame, scale)
    }
    
    
    // MARK: - Actions
    
    
    

    
    // MARK: - Public Methods
    
    
    public func reload() {
        
    }
    
    public func swipe(_ direcion: SwipeDirection) {

    }
    
    public func reusableViewForCard(at index: Int) -> UIView? {
        if queueOfCards.count + currentCardIndex > index && index >= currentCardIndex {
            print("count: \(queueOfCards.count)")
            print("content: \(queueOfCards[index - currentCardIndex])")
            return queueOfCards[index - currentCardIndex].contentView
        } else {
            return nil
        }
    }
    
    
    

}


extension CardView: DraggableCardDelegate {
    
    
    public func didSwipe(in direction: SwipeDirection) {
        switch direction {
        case .left: break
//            let card = queueOfCards.removeLast()
//            queueOfCards.insert(card, at: 0)
//            card.removeFromSuperview()direction
//            card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
//            insertSubview(card, at: 0)
            
//            guard let contentView = dataSource?.cardView(self, viewForCardAt: 0) else { return }
//            card.contentView = contentView

            
        case .right: print("unlike")
        case .none: print("none")
        }
    }
    
    
}


extension CardView {
    
    func createCard(at index: Int, frame: CGRect? = nil) -> DraggableCard {
//        let cardView = generateCard(frame ?? frameForTopCard())
        let cardView = generateCard(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
//        configureCard(cardView, at: index)
        
        return cardView
    }
    
    func generateCard(_ frame: CGRect) -> DraggableCard {
        let cardView = DraggableCard(frame: frame)
        cardView.delegate = self
        
        return cardView
    }
    
    func configureCard(_ card: DraggableCard, at index: Int) {
        guard let contentView = dataSource?.cardView(self, viewForCardAt: index) else { return }
        card.configure(contentView: contentView, andOverlayView: dataSource?.cardView(self, viewForCardOverlayAt: index))
    }
    
}
