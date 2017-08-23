//
//  NavigationELement.swift
//  Kolibri
//
//  Created by Slav Sarafski on 11/2/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit
import SwiftyJSON

class NavigationELement: NSObject, NSCoding {
    
    enum NavigationElementType:String {
        case button = "button"
        case image = "image"
    }
    
    enum NavigationElementPosition:String {
        case left = "left"
        case center = "center"
        case right = "right"
    }
    
    var type:NavigationElementType!
    var position:NavigationElementPosition!
    var image1:String!
    var image2:String?
    var title:String?
    
    override init() {
        
    }
    
    required init(json:JSON, type:NavigationElementType) {
        self.type = type
        self.title = json["label"].string
        self.image1 = json["image"].string
        if self.image1 == nil {
            self.image1 = json["image-closed"].string
        }
        self.image2 = json["image-open"].string
        let pos = json["position"].string ?? "left"
        self.position = NavigationElementPosition(rawValue: pos)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.type = NavigationElementType(rawValue:aDecoder.decodeObject(forKey: "type") as! String)
        self.position = NavigationElementPosition(rawValue:aDecoder.decodeObject(forKey: "position") as! String)
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.image1 = aDecoder.decodeObject(forKey: "image1") as? String
        self.image2 = aDecoder.decodeObject(forKey: "image2") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.image1, forKey: "image1")
        aCoder.encode(self.image2, forKey: "image2")
        aCoder.encode(self.type.rawValue, forKey: "type")
        aCoder.encode(self.position.rawValue, forKey: "position")
    }
}
