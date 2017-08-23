//
//  VRViewController.swift
//  Kolibri
//
//  Created by Slav Sarafski on 24/7/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit

class VRViewController: UIViewController {
    
    var urlString: String = ""
//    var vrView:GVRVideoView = GVRVideoView()
//    let loaderView:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.vrView = GVRVideoView(frame: self.view.frame)
//        self.view = self.vrView
//        self.vrView.delegate = self
//        self.vrView.enableInfoButton = false
//        self.vrView.enableCardboardButton = true
//        self.vrView.enableTouchTracking = true
//        self.vrView.backgroundColor = .black
//        
//        if let questionRange = self.urlString.range(of: "?") {
//            self.urlString.removeSubrange(questionRange.lowerBound..<self.urlString.endIndex)
//        }
//        if let url = URL(string: self.urlString) {
//            self.vrView.load(from: url)
//        }
//        
//        let button = UIButton()
//        button.setImage(#imageLiteral(resourceName: "VRBackButton"), for: .normal)
//        button.addTarget(self, action: #selector(back), for: .touchUpInside)
//        self.vrView.addSubview(button)
//        button.snp.makeConstraints { (make) in
//            make.width.height.equalTo(44)
//            make.top.equalTo(20)
//            make.left.equalTo(0)
//        }
//        
//        self.vrView.addSubview(loaderView)
//        self.loaderView.startAnimating()
//        self.loaderView.hidesWhenStopped = true
//        self.loaderView.center = self.vrView.center
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(viewControllerWasRotated),
//                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
//                                               object: nil)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//        
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
//        
//        if (self.isMovingFromParentViewController) {
//            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
//        }
//    }
//    
//    func viewControllerWasRotated() {
//        self.loaderView.center = self.vrView.center
//    }
//    
//    func back() {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    func widgetView(_ widgetView: GVRWidgetView!, didLoadContent content: Any!) {
//        self.vrView.pause()
//        self.vrView.play()
//    }
}
