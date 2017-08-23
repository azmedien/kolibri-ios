//
//  MenuTableViewController.swift
//  Kolibri
//
//  Created by Slav Sarafski on 13/2/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit
import SideMenu

class MenuTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerBorderView: UIView!
    @IBOutlet weak var footerView: UIStackView!
    
    var menu:[MenuElement] = []
    var menuFooter:[MenuElement]?
    var menuHeader:MenuHeader?
    
    var isHeaderCreated:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let menu = DataController.shared.getMenu() {
            self.menu = menu
            self.tableView.reloadData()
        }
    }

    override func viewDidLayoutSubviews() {
        if !self.isHeaderCreated, let header = DataController.shared.getMenuHeader() {
            self.createMenuHeader(header: header)
        }
        if let footer = DataController.shared.getMenuFooter() {
            self.menuFooter = footer
            self.createMenuFooter(array: menuFooter!)
        }
    }
    
    func createMenuHeader(header:MenuHeader) {
        self.headerView.backgroundColor = header.backgroundColor()
        
        if  let haderBackgroundImage = header.background,
            !haderBackgroundImage.contains("#")
        {
            let backgroundImageView = UIImageView(frame: self.headerView.bounds)
            backgroundImageView.contentMode = .scaleAspectFill
            self.headerView.addSubview(backgroundImageView)
            backgroundImageView.sd_setImage(with: URL(string: haderBackgroundImage)) { (image, error, type, url) in
                if let size = image?.size {
                    self.headerView.frame.size.height = self.headerView.frame.size.width * size.height / size.width
                    backgroundImageView.frame = self.headerView.bounds
                    self.tableView.snp.remakeConstraints({ (make) in
                        make.top.equalTo(self.headerView.snp.bottom)
                        make.left.right.equalTo(0)
                        make.bottom.equalTo(self.footerBorderView.snp.top)
                    })
                    
                    self.createMenuHeaderLogo(header: header)
                }
            }
        }
        else {
            self.createMenuHeaderLogo(header: header)
        }
        
        if let headerBorderColor = AppSettings.menuHeaderBorder {
            let border = UIView()
            border.backgroundColor = headerBorderColor
            self.headerView.addSubview(border)
            border.snp.makeConstraints({ (make) in
                make.height.equalTo(1)
                make.left.right.bottom.equalTo(0)
            })
        }
        
        self.isHeaderCreated = true
    }
    
    func createMenuHeaderLogo(header:MenuHeader) {
        let size = self.headerView.frame.size
        let logoView = UIImageView(frame: CGRect(x: 10, y: size.height/2-10, width: size.width/2, height: size.height/2))
        logoView.contentMode = .scaleAspectFit
        logoView.sd_setImage(with: URL(string: header.image ?? ""))
        self.headerView.addSubview(logoView)
        self.headerView.bringSubview(toFront: logoView)
        logoView.snp.makeConstraints { (make) in
            make.width.equalTo(size.width/2)
            make.height.equalTo(size.height/2)
            if header.imagePosition == "center" {
                make.center.equalTo(self.headerView.snp.center)
            }
            if header.imagePosition.contains("bottom") {
                make.bottom.equalTo(-10)
            }
            if header.imagePosition.contains("top") {
                make.top.equalTo(10)
            }
            if header.imagePosition.contains("left") {
                make.left.equalTo(10)
            }
            if header.imagePosition.contains("right") {
                make.right.equalTo(-10)
            }
        }
    }
    
    func createMenuFooter(array:[MenuElement]) {
        if array.count < 1 {
            return
        }
        
        self.footerView.backgroundColor = AppSettings.menuFooterBackground
        self.footerBorderView.backgroundColor = AppSettings.menuFooterBorder
        
        self.footerView.removeAllSubviews()
        
        var tag = 0
        for item in array {
            let button = UIButton()
            button.tag = tag
            tag = tag + 1
            button.setTitle(item.title, for: .normal)
            button.setTitleColor(AppSettings.menuFooterItem, for: .normal)
            button.titleLabel?.font = UIFont.normalFont(size: 14)
            button.backgroundColor = .white
            button.addTarget(self, action: #selector(openMenuItem(sender:)), for: .touchUpInside)
            self.footerView.addArrangedSubview(button)
        }
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
    }
    
    func openMenuItem(sender:UIButton) {
        if let item = self.menuFooter?[sender.tag] {
            self.dismiss(animated: true) {
                MainViewController.selectMenuItem(item: item)
            }
        }
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuItemCellIdentifier", for: indexPath) as! MenuTableViewCell
        
        let item = self.menu[indexPath.row]
        
        cell.cellTitleLabel.text = item.title
        
        if MainViewController.selectedMenuItem?.id == item.id {
            // Selected row
            cell.cellTitleLabel.textColor = AppSettings.primaryColor
            cell.cellTitleLabel.font = UIFont.boldFont(size: 16)
            
            // TINT normal icon
            if let image = item.icon {
                cell.cellImageView.sd_setImage(with: URL(string: image), completed: { (img, error, type, url) in
                    cell.cellImageView.image = img?.maskWithColor(color: AppSettings.primaryColor)
                })
            }
        }
        else {
            // NON Selected row
            cell.cellTitleLabel.textColor = AppSettings.secondaryTextColor
            cell.cellTitleLabel.font = UIFont.normalFont(size: 16)
            if let image = item.icon {
                cell.cellImageView.sd_setImage(with: URL(string: image))
            }
        }
        
        if item.type != nil, item.type == .separator {
            cell.backgroundColor = .gray
        }

        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: true) {
            MainViewController.selectMenuItem(item: self.menu[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        let item = self.menu[indexPath.row]
        if item.type != nil, item.type == .separator {
            return false
        }
        return true
    }
    
}

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    
}
