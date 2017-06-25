//
//  MatchCell.swift
//  TinderForJobs
//
//  Created by Emil Gräs on 25/06/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class MatchCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance()
    }
    
    private func setupAppearance() {
        layer.cornerRadius = 8
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8
    }

}
