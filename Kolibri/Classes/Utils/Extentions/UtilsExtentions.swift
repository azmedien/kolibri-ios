//
//  BaseViewController.swift
//  Kolibri
//
//  Created by Slav Sarafski on 11/4/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit

extension UIColor {
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    var isLight: Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white > 0.5
    }
}

extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
}

extension String {
    func getQueryStringParameter(param: String) -> String? {
        let urlComponents = NSURLComponents(string: self)
        if let queryItems = urlComponents?.queryItems {
            return queryItems.filter({ (item) in item.name == param }).first?.value
        }
        return nil
    }
    
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
    
    func slice(from: String, to: String, includeBounds:Bool = false) -> String? {
        if includeBounds {
            return (range(of: from)?.lowerBound).flatMap { substringFrom in
                (range(of: to, range: substringFrom..<endIndex)?.upperBound).map { substringTo in
                    substring(with: substringFrom..<substringTo)
                }
            }
        }
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                substring(with: substringFrom..<substringTo)
            }
        }
    }
    
    func removeHTTPSandWWW() -> String {
        var cleanString = self.replacingOccurrences(of: "www.", with: "")
        cleanString = cleanString.replacingOccurrences(of: "http://", with: "")
        cleanString = cleanString.replacingOccurrences(of: "https://", with: "")
        return cleanString
    }
    
    func parseMeta(sepparator:String="<meta") -> [Meta] {
        let trash = self.components(separatedBy: sepparator)
        var metas:[Meta] = []
        for meta in trash {
            let content = meta.slice(from: "content=\"", to: "\"") ?? ""
            var property = meta.slice(from: "property=\"", to: "\"") ?? ""
            if property == "" {
                property = meta.slice(from: "name=\"", to: "\"") ?? ""
            }
            metas.append(Meta(p: property, c: content))
        }
        return metas
    }
}


class Meta: NSObject {
    var property:String = ""
    var content:String = ""
    init(p:String, c:String) {
        self.property = p
        self.content = c
    }
}

extension Array where Element: Equatable {
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint{
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint{
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    func distance(point:CGPoint) -> CGFloat{
        let width = self.x - point.x
        let height = self.y - point.y
        return sqrt(height * height + width * width)
    }
}

class QueryBuilder: NSObject {
    struct QueryItem {
        var name:String?
        var value:String = ""
    }
    
    var url:String?
    var items:[QueryItem] = []
    
    init(url u:String? = nil) {
        self.url = u
    }
    
    func addItem(name:String?, value:String) {
        items.append(QueryItem(name: name, value: value))
    }
    
    func build() -> String {
        var u = url ?? ""
        var hasItem = false
        
        for item in self.items {
            if item.value != "" {
                if hasItem {
                    u.append("&")
                }
                else {
                    u.append("?")
                }
                if let name = item.name {
                    u.append("\(name)=\(item.value)")
                }
                else {
                    u.append(item.value)
                }
                hasItem = true
            }
        }
        
        return u
    }
}

class KolibriLog {
    static func printIt(message: String) {
        if KolibriSettings.logLevel == .All || KolibriSettings.logLevel == .Log {
            print("Kolibri Message: \(message)")
        }
    }
    static func printIt(error: String) {
        if KolibriSettings.logLevel == .All || KolibriSettings.logLevel == .Error {
            print("Kolibri Error: \(error)")
        }
    }
    static func printIt(warning: String) {
        if KolibriSettings.logLevel == .All || KolibriSettings.logLevel == .Warning {
            print("Kolibri Warning: \(warning)")
        }
    }
}
