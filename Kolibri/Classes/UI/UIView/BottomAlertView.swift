//
//  BottomAlertView.swift
//  Kolibri
//
//  Created by Slav Sarafski on 24/3/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit
import SnapKit

class BottomAlertView: UIView {

    let height:CGFloat = 68
    
    var titleLabel:UILabel!
    var button:UIButton?
    
    var parent:UIView!
    var isShowed:Bool = false
    var buttonAction:(()->Void)? = nil
    
    init(view:UIView, title:String, buttonTitle:String = "", action: (() -> Void)?, show:Bool = true) {
        super.init(frame: CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height))
        
        self.isUserInteractionEnabled = true
        self.parent = view
        self.buttonAction = action
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        
        if buttonTitle != "" {
            self.button = UIButton()
            self.button?.setTitle(buttonTitle, for: .normal)
            self.button?.setTitleColor(UIColor.hexStringToUIColor(hex: "#9B9B9B"), for: .normal)
            self.button?.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
            self.addSubview(self.button!)
            
            self.button?.snp.makeConstraints({ (make) in
                make.right.top.bottom.equalTo(0)
                make.width.equalTo(90)
            })
        }
        
        self.titleLabel = UILabel()
        self.titleLabel.text = title
        self.titleLabel.textColor = .white
        self.titleLabel.numberOfLines = 3
        self.addSubview(self.titleLabel)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            
            if buttonTitle != "" {
                make.right.equalTo((self.button?.snp.left)!).offset(20)
            }
            else {
                make.right.equalTo(30)
            }
        }
        
        if show {
            self.show()
        }
    }
    
    func show(duration:Int = 30) {
        if !self.isShowed {
            self.isShowed = true
            UIView.animate(withDuration: 0.8) { 
                self.frame.origin.y = self.parent.frame.height - self.frame.height
            }
        }
        if duration > 0 {
            self.hide(delay: 30)
        }
    }
    
    func hide(delay:Int = 0)  {
        if self.isShowed {
            self.isShowed = true
            let deadlineTime = DispatchTime.now() + .seconds(delay)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                UIView.animate(withDuration: 0.8,
                               delay: 0,
                               options: .curveEaseIn,
                               animations: {
                                self.frame.origin.y = self.parent.frame.maxY
                }, completion: nil)
            })
            
        }
    }
    
    func action(sender:UIButton) {
        if self.buttonAction != nil {
            self.buttonAction!()
            self.hide()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
