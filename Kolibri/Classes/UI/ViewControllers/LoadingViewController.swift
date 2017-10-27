//
//  LoadingViewController.swift
//  Kolibri
//
//  Created by Slav Sarafski on 11/2/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    // AdTech
    
    // End AdTech
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let launchScreenName = Bundle.splashScreen() ?? "LaunchScreen"
        let launchStoryboard = UIStoryboard.init(name: launchScreenName, bundle: nil)
        let launchViewController = launchStoryboard.instantiateViewController(withIdentifier: "LaunchViewController")
        self.view.addSubview(launchViewController.view)
        
        KolibriAPI.shared.getSystemConfigurations { (error) in
            // AdTech
            
            // End AdTech
            self.performToMainViewController()
        }
    }

    func performToMainViewController() {
        self.performSegue(withIdentifier: "homeSeque", sender: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
