//
//  MenuHeader.swift
//  Kolibri
//
//  Created by Slav Sarafski on 19/3/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit
import SwiftyJSON

class MenuHeader: MenuItem, NSCoding {
    
    var title:String?
    var background:String?
    var image:String?
    var imagePosition:String = "bottomCenter"
    
    override init() {
        
    }
    
    required init(json:JSON) {
        self.title = json["title"].string
        self.background = json["background"].string
        self.image = json["image"].string
        self.imagePosition = json["imagePosition"].string ?? "center"
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.image = aDecoder.decodeObject(forKey: "image") as? String
        self.imagePosition = aDecoder.decodeObject(forKey: "imagePosition") as? String ?? "bottomCenter"
        self.imagePosition = self.imagePosition.lowercased()
        self.background = aDecoder.decodeObject(forKey: "background") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.background, forKey: "background")
        aCoder.encode(self.image, forKey: "image")
        aCoder.encode(self.imagePosition, forKey: "imagePosition")
    }
    
    func backgroundColor() -> UIColor {
        if  let b = self.background,
            b.contains("#")
        {
            return UIColor.hexStringToUIColor(hex: b)
        }
        return KolibriSettings.style.menuHeaderBackground
    }
}
