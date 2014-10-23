//
//  AppDelegate.swift
//  devMod
//
//  Created by Paolo Tagliani on 10/23/14.
//  Copyright (c) 2014 Paolo Tagliani. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var appMenu: NSMenu!
    var statusItem:NSStatusItem?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        var interfaceValue:CFString = "AppleInterfaceStyle" as CFString
        var property:CFPropertyList? = CFPreferencesCopyValue(interfaceValue, kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)
        
        println(property!)
        
        if let light: CFPropertyList = property{
            if light as NSString == "Light"{
                activateDarkInterface()
            }
            else{
                activateLightInterface()
            }
        }
        else{
            activateDarkInterface()
        }
        
        var notificationName:CFString = "AppleInterfaceThemeChangedNotification" as CFString
        var ok:Boolean = 0
        CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), notificationName, nil, nil, ok)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }

    override func awakeFromNib() {
        var statusBar = NSStatusBar.systemStatusBar()
        statusItem = statusBar.statusItemWithLength(-1)
        statusItem!.menu = appMenu
        statusItem?.title = "devMod"
    }

    @IBAction func activateDevMode(sender: AnyObject) {
        
        
    }
    
    func activateLightInterface(){
        let interfaceValue:CFString = "AppleInterfaceStyle" as CFString
        let mode:CFPropertyList! = "Light" as CFPropertyList
        CFPreferencesSetValue(interfaceValue, mode, kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)
    }
    
    func activateDarkInterface(){
        let interfaceValue:CFString = "AppleInterfaceStyle" as CFString
        let mode:CFPropertyList! = "Dark" as CFPropertyList
        CFPreferencesSetValue(interfaceValue, mode, kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)
    }
}

