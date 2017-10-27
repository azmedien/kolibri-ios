//
//  UIExtentions.swift
//  Kolibri
//
//  Created by Slav Sarafski on 11/2/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit
import Alamofire
import SwiftGifOrigin
import AVKit

public class ReplaceSegue: UIStoryboardSegue {
    
    override public func perform() {
        UIApplication.shared.delegate?.window??.rootViewController = destination
    }
}


extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return KolibriSettings.style.statusBarStyle
    }
}

extension UIViewController {
    
    // Show loading into the view, without blocking the UI
    func showLoading(view:UIView? = nil) {
        var parentView = self.view
        if view != nil {
            parentView = view
        }
        
        let loadingView = UIView(frame: (parentView?.bounds)!)
        loadingView.backgroundColor = .white
        loadingView.tag = 99
        parentView?.addSubview(loadingView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.hideLoadingView()
        }
        
        if let gif = UIImage.gif(name: "Loading-icon") {
            let loaderAnimView = UIImageView(image: gif)
            loaderAnimView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            loaderAnimView.center = loadingView.center
            loadingView.addSubview(loaderAnimView)
        }
        else {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            indicator.color = KolibriSettings.style.primaryColor
            indicator.center = loadingView.center
            indicator.startAnimating()
            loadingView.addSubview(indicator)
        }
    }
    
    func hideLoading() {
        self.hideLoadingView()
    }
    
    private func hideLoadingView() {
        if let view = self.view.viewWithTag(99) {
            view.tag = 199
        }
        else {
            self.view.viewWithTag(199)?.removeFromSuperview()
        }
    }
    
    // PopUp Loading View, BLOCK the UI
    func showPopUpLoading() {
        let controller = UIViewController()
        controller.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        controller.modalPresentationStyle = .overCurrentContext
        
        let popup = UIView(frame: CGRect(x: 0, y: 0, width: 140, height: 80))
        popup.center = controller.view.center
        popup.backgroundColor = .white
        popup.cornerRadius = 8
        controller.view.addSubview(popup)
        
        if let gif = UIImage.gif(name: "Loading-icon") {
            let loaderAnimView = UIImageView(image: gif)
            loaderAnimView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            loaderAnimView.center = CGPoint(x: 70, y: 40)
            popup.addSubview(loaderAnimView)
        }
        else {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            indicator.color = KolibriSettings.style.primaryColor
            indicator.center = CGPoint(x: 70, y: 40)
            indicator.startAnimating()
            popup.addSubview(indicator)
        }
        
        self.present(controller, animated: false, completion: nil)
    }
    
    func hidePopUpLoading(completion:(()->Void)?) {
        self.dismiss(animated: false, completion: completion)
    }
    
    // Open Link External
    func openExternalURL (url:String) {
        if UIApplication.shared.canOpenURL(URL(string:url)!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL(string:url)!)
            }
        }
    }
    
    // Setting the home/hamburger button
    func setHomeButton() {
        self.navigationItem.hidesBackButton = true
        let hamburegImage = #imageLiteral(resourceName: "HamburgerIcon").withRenderingMode(.alwaysTemplate)
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 36, height: 24)
        button.setImage(hamburegImage, for: .normal)
        button.tintColor = KolibriSettings.style.navigationBarItemTint
        button.addTarget(MainViewController.share, action: #selector(MainViewController.share.showMenu), for: .touchUpInside)
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: button), animated: false)
    }
}

extension AVPlayerViewController {
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.bounds == contentOverlayView?.bounds {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func removeAllSubviews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
}

