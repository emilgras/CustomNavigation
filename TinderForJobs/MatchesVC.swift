//
//  MatchesVC.swift
//  TinderForJobs
//
//  Created by Emil Gräs on 25/06/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class MatchesVC: UIViewController {

    
    // MARK: - Constants
    
    
    let cellIdentifier = "MatchCell"
    
    
    // MARK: - IB Outlets
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Setup Methods
    
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.contentInset.top = 80
    }
    
    
}


extension MatchesVC: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MatchCell
        return cell
    }
    
    
}


extension MatchesVC: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.95, height: 90.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12.0
    }
    
    
}

