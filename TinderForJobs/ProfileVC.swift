//
//  ProfileVC.swift
//  TinderForJobs
//
//  Created by Emil Gräs on 25/06/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    
    // MARK: - Properties
    
    
    
    
    
    // MARK: - IB Outlets
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    // MARK: - Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Setup Methods
    
    
    private func setupAppearance() {
        profileImageView.layer.cornerRadius = (view.frame.width * 0.38) / 2
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        profileImageView.layer.shadowColor = UIColor.lightGray.cgColor
        profileImageView.layer.shadowOpacity = 0.2
        profileImageView.layer.shadowRadius = 20
    }
    
    
}
