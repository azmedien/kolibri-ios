//
//  KolibriTask.swift
//  Kolibri
//
//  Created by Slav Sarafski on 30/8/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit

enum KolibriTaskType {
    case PushNotification
}

class KolibriTask: NSObject {

    func resolveTask() {
        
    }
    
}

class PushKolibriTask: KolibriTask {
    var url:String = ""
    
    init(url u:String) {
        super.init()
        
        self.url = u
        
        if AppSettings.system.isSystemConfigurationLoaded {
            self.resolveTask()
        }
        else {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.systemConfigurationsLoaded(notification:)),
                                                   name: Notification.Name(NotificationName.SystemConfigurationLoaded.rawValue),
                                                   object: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func systemConfigurationsLoaded(notification:Notification) {
        self.resolveTask()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func resolveTask() {
        Kolibri.shared.removeTask(task: self)
        
        let infoDict:[String: String] = ["url": url]
        NotificationCenter.default.post(name: Notification.Name(NotificationName.KolibriTargetSend.rawValue),
                                        object: nil,
                                        userInfo: infoDict)
    }
}
