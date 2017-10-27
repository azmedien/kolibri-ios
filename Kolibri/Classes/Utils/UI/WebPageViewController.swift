//
//  WebPageViewController.swift
//  Kolibri
//
//  Created by Slav Sarafski on 19/3/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit

class WebPageViewController: UIViewController {

    var titleString:String?
    var url:String = ""
    var navigationBarColor:UIColor?
    
    var webView:KolibriWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = true
        
        //setHomeButton()
        
        self.webView = KolibriWebView()
        self.view.addSubview(self.webView)
        
        self.webView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(0)
        }
        
        self.webView.navigationBarColor = self.navigationBarColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.webView.handleTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !KolibriSettings.system.isSharing {
            self.webView.load(url: self.url)
        }
    }
    
    // Statusbar visibility
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}
