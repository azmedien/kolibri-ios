//
//  KolibriWebView.swift
//  Kolibri
//
//  Created by Slav Sarafski on 19/3/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit
import WebKit
import SDWebImage
import Localize_Swift

class KolibriWebView: UIView, WKNavigationDelegate {

    var webView: WKWebView!
    var warningView: UIView?
    
    var mainURL:String = ""
    var notLoadedURL:String = ""
    var loggedTitle:String = ""
    var isLoaded:Bool = false
    
    var navigationBarColor:UIColor?
    
    func createWebView() {
        self.backgroundColor = .white
        self.webView = WKWebView(frame: self.bounds)
        self.addSubview(self.webView)
        self.webView.navigationDelegate = self
        self.webView.scrollView.bounces = false
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createWebView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createWebView()
    }
    
    init() {
        super.init(frame: .zero)
        self.webView = WKWebView()
        self.addSubview(self.webView)
        self.webView.navigationDelegate = self
        self.webView.scrollView.bounces = false
        
        self.webView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(0)
        }
    }
    
    deinit {
        
    }
    
    func load(url:String) -> Void {
        if !KolibriAPI.isInternetAvailable() {
            self.notLoadedURL = url
            self.showWarning(warning: "message.warning.internetless");
            return
        }
        
        if  let urlPercentedLess = url.removingPercentEncoding,
            let urlPercented = urlPercentedLess.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let finalURL = URL(string: urlPercented) {
            
            let request = URLRequest(url: finalURL)
            self.webView.load(request)
            self.mainURL = url
            self.isLoaded = false
        }
    }
    
    func reload() {
        if let url = URL(string: self.mainURL) {
            let request = URLRequest(url: url)
            self.webView.load(request)
            self.isLoaded = false
        }
    }
    
    func openKolibriWebViewController(url:String, title:String? = nil) {
        let controller = WebPageViewController()
        controller.url = url
        controller.titleString = title
        controller.navigationBarColor = self.navigationBarColor
        self.parentViewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func openExternalURL (url:String) {
        if UIApplication.shared.canOpenURL(URL(string:url)!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL(string:url)!)
            }
        }
    }
    
    func openVRViewController (url:String) {
        let vr = VRViewController()
        vr.urlString = url
        self.parentViewController?.navigationController?.pushViewController(vr, animated: true)
    }
    
    func showWarning(warning:String) {
        self.buildWarningView()
        self.parentViewController?.hideLoading()
        
        self.warningView?.isHidden = false
        self.warningView?.isUserInteractionEnabled = true
        let label = self.warningView?.viewWithTag(11) as! UILabel
        label.text = warning.localized()
    }
    
    func hideWarning() {
        self.warningView?.isHidden = true
        self.warningView?.isUserInteractionEnabled = false
    }
    
    func logEvent() {
        if self.loggedTitle == "" {
            self.getMetaTags({ (metas) in
                self.loggedTitle = (metas.first(where: {$0.property == METATAG_KOLIBRI_CATEGORY})?.content) ?? ""
                KolibriAnalytics.logEvent(url: self.mainURL, title: self.loggedTitle)
            })
        }
        else {
            KolibriAnalytics.logEvent(url: self.mainURL, title: self.loggedTitle)
        }
    }
    
    func handleTheme() {
        if !isLoaded {return}
        self.getMetaTags({ (metas) in
            if let color = (metas.first(where: {$0.property == METATAG_THEME})?.content),
                color.contains("#")
            {
                self.navigationBarColor = UIColor.hexStringToUIColor(hex: color)
                self.parentViewController?.navigationController?.navigationBar.barTintColor = self.navigationBarColor
            }
            else {
                let color = self.navigationBarColor ?? KolibriSettings.style.navigationBarBackground
                self.parentViewController?.navigationController?.navigationBar.barTintColor = color
            }
        })
    }
    
    //
    // MARK: WKWebView Delegates
    //
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.hideWarning()
        self.parentViewController?.hideLoading()
        self.parentViewController?.showLoading(view: self.webView)
        self.removeShareButton()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        // START: Favorite stuff
        
        // END: Favorite stuff
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.parentViewController?.hideLoading()
        }
        
        self.isLoaded = true
        self.logEvent()
        self.handleTheme()
        
        // START: Share stuff
        self.addShareButton()
        // END: Share stuff
        
        // START: Basic search stuff
        
        // END: Basic search stuff
        
        // START: Search with options stuff
        
        // END: Search with options stuff
        
        // START: Favorite stuff
        
        // END: Favorite stuff
        
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard  let url = navigationAction.request.url?.absoluteString else {
            decisionHandler(.allow)
            return
        }
        
        // Check if request is not user interaction or it is main url
        if  navigationAction.navigationType != .linkActivated ||
            url == self.mainURL
        {
            decisionHandler(.allow)
            return
        }
        
        // Check if request is user interaction
        if  let nsurl = navigationAction.request.url,
            // Check for "kolibri://navigation/path" model of url
            (nsurl.scheme == "kolibri" || nsurl.scheme == KolibriSettings.system.scheme),
            nsurl.host == "navigation",
            nsurl.pathComponents.count > 1
        {
            NotificationCenter.default.post(name: Notification.Name(NotificationName.KolibriTargetSend.rawValue),
                                            object: nil,
                                            userInfo: ["url":nsurl])
            decisionHandler(.cancel)
            return
        }
        
        // Check is requeset has "kolibri-target"
        if let target = url.getQueryStringParameter(param: "kolibri-target") {
            switch target {
            case "_self":
                decisionHandler(.allow)
                return
            case "_internal":
                self.openKolibriWebViewController(url: url)
                decisionHandler(.cancel)
                return
            case "_external":
                self.openExternalURL(url: url)
                decisionHandler(.cancel)
                return
            case "360player":
                self.openVRViewController(url: url)
                decisionHandler(.cancel)
                return
            default: break
            }
        }
        else {
            // Check for is DOMAIN the same like KolibriSettings.domain
            if  let domain = KolibriSettings.system.domain?.removeHTTPSandWWW(),
                let host = navigationAction.request.url?.host?.removeHTTPSandWWW(),
                host == domain {
                self.openKolibriWebViewController(url: url)
                decisionHandler(.cancel)
                return
            }
            
            // In end it is opening in external Safari browser
            self.openExternalURL(url: url)
            decisionHandler(.cancel)
            return
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        // START: Share stuff
        
        // END: Share stuff
        
        // START: Favorite stuff
        
        // END: Favorite stuff
        
        decisionHandler(.allow)
    }
    
    func getMetaTags(_ complite:@escaping ([Meta])->Void) {
        self.webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                        completionHandler: { (html, error) in
                                            
                                            if let h = html as? String, let head = h.slice(from: "<head>", to: "</head>"){
                                                let metas = head.parseMeta()
                                                complite(metas)
                                            }
        })
    }
}


// MARK: KolibriWebView SHARE functionality
extension KolibriWebView{
    func addShareButton() {
        self.getMetaTags { metas in
            if let shareable = metas.first(where: {$0.property == METATAG_SHAREABLE})?.content.boolValue, shareable {
                let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.shareAction(sender:)))
                shareButton.tintColor = .white
                shareButton.tag = 11
                if let items = self.parentViewController?.navigationItem.rightBarButtonItems {
                    if !items.contains(where: {$0.tag == 11}) {
                        self.parentViewController?.navigationItem.rightBarButtonItems?.append(shareButton)
                    }
                }else  {
                    self.parentViewController?.navigationItem.rightBarButtonItems = [shareButton]
                }
            }
        }
    }
    
    func removeShareButton() {
        if let items = self.parentViewController?.navigationItem.rightBarButtonItems {
            if let button = items.first(where: {$0.tag == 11}) {
                self.parentViewController?.navigationItem.rightBarButtonItems?.remove(object: button)
            }
        }
    }
    
    @objc func shareAction(sender:KolibriBarButtonItem) {
        self.getMetaTags { (metas) in
            let title = (metas.first(where: {$0.property == METATAG_TITLE})?.content) ?? ""
            let imageURL = (metas.first(where: {$0.property == METATAG_IMAGE})?.content) ?? ""
            let url =   (metas.first(where: {$0.property == METATAG_CANONICAL_URL})?.content) ??
                        (metas.first(where: {$0.property == METATAG_URL})?.content) ??
                        self.webView.url?.absoluteString ?? ""
            
            let downloader = SDWebImageDownloader()
            
            self.parentViewController?.showPopUpLoading()
            downloader.downloadImage(with: URL(string: imageURL), options: SDWebImageDownloaderOptions(), progress: { (a, b) in
                //here is the progress
            }) { (image, data, error, finished) in
                var activityItems = [title, url] as [Any]
                if image != nil {
                    activityItems.append(image!)
                }
                self.parentViewController?.hidePopUpLoading(completion: {
                    self.showShareController(activityItems: activityItems)
                })
            }
        }
    }
    
    func showShareController(activityItems:[Any]) {
        KolibriSettings.system.isSharing = true
        let shareController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        shareController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            KolibriSettings.system.isSharing = false
        }
        self.parentViewController?.present(shareController, animated: true, completion: nil)
    }
}


// MARK: KolibriWebView WARNING AND EROR MESSAGING
extension KolibriWebView {
    func buildWarningView() {
        if self.warningView == nil {
            self.warningView = UIView()
            self.warningView?.backgroundColor = .white
            self.addSubview(self.warningView!)
            self.warningView?.snp.makeConstraints({ (make) in
                make.top.left.bottom.right.equalTo(0)
            })
            
            let label = UILabel()
            label.font = UIFont.normalFont(size: 18)
            label.tag = 11
            label.numberOfLines = 0
            label.textAlignment = .center
            self.warningView?.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(60)
                make.right.equalTo(-60)
                make.centerY.equalTo(self.warningView!.snp.centerY)
            })
            
            let image = UIImageView()
            image.contentMode = .scaleAspectFit
            image.image = #imageLiteral(resourceName: "Warning Image")
            self.warningView?.addSubview(image)
            image.snp.makeConstraints({ (make) in
                make.height.width.equalTo(30)
                make.centerX.equalTo(self.warningView!.snp.centerX)
                make.bottom.equalTo(label.snp.top).offset(-35)
            })
            
            let button = UIButton()
            button.setTitle("button.reload".localized().uppercased(), for: .normal)
            button.setTitleColor(KolibriSettings.style.alternativeTextColor, for: .normal)
            button.borderColor = KolibriSettings.style.alternativeTextColor
            button.borderWidth = 1
            button.cornerRadius = 4
            button.titleLabel?.font = UIFont.normalFont(size: 14)
            button.addTarget(self, action: #selector(self.reloadNotLoaded), for: .touchUpInside)
            self.warningView?.addSubview(button)
            button.snp.makeConstraints({ (make) in
                make.height.equalTo(30)
                make.width.equalTo(96)
                make.centerX.equalTo(self.warningView!.snp.centerX)
                make.top.equalTo(label.snp.bottom).offset(35)
            })
        }
    }
    
    @objc func reloadNotLoaded() {
        self.load(url: self.notLoadedURL)
    }
}
