//
//  API.swift
//  Kolibri
//
//  Created by Slav Sarafski on 9/2/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SystemConfiguration

class API: NSObject {

    // MARK: Share manager
    static let shared : API = {
        let instance = API()
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.urlCache = nil
        
        sessionManager = Alamofire.SessionManager(configuration: config)
        
        return instance
    }()
    
    static var sessionManager:SessionManager!
 
    // MARK: Get configurations
    func getSystemConfigurations(completion: @escaping (_ error:String) -> Void) {
        if !API.isInternetAvailable() {
            completion("No internet connection")
            return
        }
        
        Alamofire.request(AppSettings.configURL,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: nil).responseJSON { (response) in
            
            var error = ""
            
            if (response.result.isSuccess){
                let json = JSON(response.result.value!)
                
                DataController.shared.saveSystemConfigurations(json: json)
            }
            else {
                error = "Bad request"
            }
            
            completion(error)
        }
    }
    
    func getHEAD(for url:URL, completion: @escaping (_ header:[AnyHashable:Any]?, _ error:String?) -> Void) {
        if !API.isInternetAvailable() {
            completion(nil, "No Net")
            return
        }
        
        
        Alamofire.request(url,
                          method: HTTPMethod.get,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers: nil).responseString(completionHandler: { (response) in
                            completion(response.response?.allHeaderFields, nil)
                            
        })
    }
    
    // MARK: Check Internet connectivity
    static func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
