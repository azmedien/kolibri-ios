//
//  NetMetrix.swift
//  Kolibri
//
//  Created by Slav Sarafski on 7/5/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import Foundation
import Alamofire
//import Firebase

class KolibriAnalytics {
    static func logEvent(url:String, title:String?) {
        NetMetrix.reportToNetmetrix(url)
        //FirebaseExtend.reportToFirebase(url: url, name: title)
    }
}

class NetMetrix: NSObject {
    
    static func reportToNetmetrix(_ referrer:String?) {
        guard var netMetrixURL = KolibriSettings.netMetrix.url,
            let type = KolibriSettings.netMetrix.type else {
                KolibriLog.printIt(error: "NetMetrix: offerKey was not found")
                return
        }
        
        let platform = "ios"
        let size = "\(Int(UIScreen.main.bounds.width))x\(Int(UIScreen.main.bounds.height))"
        let random = arc4random() % 1000000
        
        let system = type == "phone" ? "iPhone " : (type == "tablet" ? "iPad " : "")
        let agent = "Mozilla/5.0 (iOS-\(type); U; CPU \(system)OS like Mac OS X)"
        let headers:HTTPHeaders = ["User-Agent" : agent, "Accept-Language" : "[de]"]
        
        if netMetrixURL.characters.last != "/" {
            netMetrixURL.append("/")
        }
        
        netMetrixURL.append(platform)
        netMetrixURL.append("/")
        netMetrixURL.append(type)
        netMetrixURL.append("?d=\(random)")
        netMetrixURL.append("&x=\(size)")
        if referrer != nil {
            netMetrixURL.append("&r=\(referrer!.lowercased())")
        }
        
        if  let fixedURL = netMetrixURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: fixedURL) {
            Alamofire.request(url,
                              method: HTTPMethod.get,
                              parameters: nil,
                              encoding: URLEncoding.default,
                              headers: headers).response { (response) in
                                if let error = response.error {
                                    KolibriLog.printIt(error: "NetMetrix: Report to NetMetrix failed, error:\(error.localizedDescription)")
                                }
                                else {
                                    KolibriLog.printIt(message: "NetMetrix: Successfully report to NetMetrix")
                                }
            }
        }
    }
    
    static func platform() -> String {
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
}
