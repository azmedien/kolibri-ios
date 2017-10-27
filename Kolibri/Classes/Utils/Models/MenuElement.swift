//
//  MenuElement.swift
//  Kolibri
//
//  Created by Slav Sarafski on 11/2/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit
import SwiftyJSON

class MenuItem: NSObject {
    enum MenuItemType:String{
        case controller = "controller"
        case link = "link"
        case separator = "separator"
    }
    
    enum MenuItemTargets:String{
        case TargetSelf = "_self"
        case TargetInternal = "_internal"
        case TargetExternal = "_external"
        case VRController = "360player"
        case TargetController
    }
    
    var type:MenuItemType!
    var target:MenuItemTargets = .TargetSelf
}

class MenuElement: MenuItem, NSCoding {
    
    var title:String?
    var url:String?
    var id:String?
    var icon:String?
    var isDefault:Bool = false
    var isHasSearchIcon:Bool = false
    
    override init() {
        
    }
    
    required init(main json:JSON) {
        super.init()
        
        if let component = json["component"].string {
            switch component {
            case "kolibri://separator":
                self.type = .separator
                break
            case "kolibri://content/link":
                self.type = .link
                self.id = json["id"].string
                self.title = json["label"].string
                self.icon = self.constructAssetPath(asset: json["icon"].string ?? "")
                self.isHasSearchIcon = json["search"].boolValue
                if let url = json["url"].string {
                    self.url = url
                    if let target = url.getQueryStringParameter(param: "kolibri-target") {
                        self.target = MenuItemTargets(rawValue: target)!
                    }
                }
                break
            case "kolibri://content/360player":
                self.type = .controller
                self.id = json["id"].string
                self.title = json["label"].string
                self.icon = self.constructAssetPath(asset: json["icon"].string ?? "")
                self.isHasSearchIcon = json["search"].boolValue
                self.target = .VRController
                if let url = json["url"].string {
                    self.url = url
                }
                break
            default:
                self.type = .controller
                self.target = .TargetController
                self.id = json["id"].string
                self.title = json["label"].string
                self.icon = self.constructAssetPath(asset: json["icon"].string ?? "")
                self.url = component
                break
            }
        }
    }
    
    required init(footer json:JSON) {
        super.init()
        
        self.id = json["id"].string
        self.title = json["label"].string
        self.type = .link
        if let url = json["url"].string {
            self.url = url
            if let target = url.getQueryStringParameter(param: "kolibri-target") {
                self.target = MenuItemTargets(rawValue: target)!
            }
            else {
                if let domain = KolibriSettings.system.domain {
                    if URL(string:url)?.host == domain {
                        self.target = .TargetSelf
                    }
                }
            }
        }
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        if let type = aDecoder.decodeObject(forKey: "type") as? String{
            self.type = MenuItemType(rawValue:type)
        }
        if let target = aDecoder.decodeObject(forKey: "target") as? String{
            self.target = MenuItemTargets(rawValue:target)!
        }
        self.id = aDecoder.decodeObject(forKey: "id") as? String
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.icon = aDecoder.decodeObject(forKey: "icon") as? String
        self.url = aDecoder.decodeObject(forKey: "url") as? String
        self.isDefault = aDecoder.decodeBool(forKey: "default")
        self.isHasSearchIcon = aDecoder.decodeBool(forKey: "searchIcon")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.url, forKey: "url")
        aCoder.encode(self.icon, forKey: "icon")
        aCoder.encode(self.type.rawValue, forKey: "type")
        aCoder.encode(self.target.rawValue, forKey: "target")
        aCoder.encode(self.isDefault, forKey: "default")
        aCoder.encode(self.isHasSearchIcon, forKey: "searchIcon")
    }
    
    func constructAssetPath(asset:String) -> String {
        if asset.contains("http") {
            return asset
        }
        let assetLink = KolibriSettings.system.configURL.replacingOccurrences(of: "runtime", with: "assets")
        let core = assetLink.components(separatedBy: ".com")[1]
        if asset.contains("-png-") {
            let assetURL = "\(assetLink)/\(asset)/download"
            return assetURL
        }
        if asset.contains("-png") {
            let assetURL = "\(assetLink)/\(asset)/download"
            return assetURL
        }
        if var assetURL = KolibriSettings.system.assetsURL {
            assetURL = "\(assetURL)\(core)/\(asset).png"
            return assetURL
        }
        return ""
    }
}

