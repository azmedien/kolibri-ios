//
//  Constants.swift
//  Kolibri
//
//  Created by Slav Sarafski on 4/4/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit

enum NotificationName:String{
    case SystemConfigurationLoaded = "SystemConfigurationLoaded"
    
    // Old MenuDidSelected
    case KolibriTargetSend = "KolibriTargetSend"
    
    case PageWillChanged = "PageWillChanged"
    case PageDidChanged  = "PageDidChanged"
    case ControllerDidOpened = "ControllerDidOpened"
    case MainViewControllerWillInit = "MainViewControllerWillInit"
    case MainViewControllerDidInit = "MainViewControllerDidInit"
    
    case MainViewControllerWillAppear = "MainViewControllerWillAppear"
    case MainViewControllerDidAppear = "MainViewControllerDidAppear"
    case MainViewControllerWillDisappear = "MainViewControllerWillDisappear"
    case MainViewControllerDidDisappear = "MainViewControllerDidDisappear"
}


public let METATAG_TITLE = "og:title"
public let METATAG_IMAGE = "og:image"
public let METATAG_DESCRIPTION = "og:description"
public let METATAG_URL = "og:url"
public let METATAG_CANONICAL_URL = "canonical"
public let METATAG_KOLIBRI_CATEGORY = "kolibri-category"
public let METATAG_THEME = "theme-color"
public let METATAG_SHAREABLE = "kolibri-shareable"
public let METATAG_FAVORIZABLE = "kolibri-favorizable"

