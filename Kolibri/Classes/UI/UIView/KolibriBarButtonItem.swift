//
//  KolibriBarButtonItem.swift
//  Kolibri
//
//  Created by Slav Sarafski on 21/3/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit
import SDWebImage

class KolibriBarButtonItem: UIBarButtonItem {

    var normalImage:UIImage?
    var selectedImage:UIImage?
    
    var normalImageURL:String?
    var selectedImageURL:String?
    
    var isSelected:Bool = false {
        didSet {
            if isSelected {
                self.image = selectedImage
            }
            else {
                self.image = normalImage
            }
        }
    }
    
    override init() {
        super.init()
    }
    
    convenience init(normalImage:UIImage, selectedImage:UIImage, target:Any?, selector:Selector?) {
        self.init(title: "", style: .plain, target: target, action: selector)
        self.normalImage = normalImage
        self.selectedImage = selectedImage
    }

    convenience init(normalImageURL:String, selectedImageURL:String, target:Any?, selector:Selector?) {
        self.init(title: "", style: .plain, target: target, action: selector)
        self.normalImageURL = normalImageURL
        self.selectedImageURL = selectedImageURL
        let downloader = SDWebImageDownloader()
        
        downloader.downloadImage(with: URL(string: self.normalImageURL!), options: SDWebImageDownloaderOptions(), progress: { (a, b) in
            //here is the progress
        }) { (image, data, error, finished) in
            self.normalImage = image
            if !self.isSelected {
                self.image = self.normalImage
            }
        }
        downloader.downloadImage(with: URL(string: self.selectedImageURL!), options: SDWebImageDownloaderOptions(), progress: { (a, b) in
            //here is the progress
        }) { (image, data, error, finished) in
            self.selectedImage = image
            if self.isSelected {
                self.image = self.selectedImage
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
