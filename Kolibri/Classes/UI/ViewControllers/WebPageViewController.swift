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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.webView.handleTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !AppSettings.isSharing {
            self.webView.load(url: self.url)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Statusbar visibility
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}
