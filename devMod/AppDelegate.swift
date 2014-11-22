//
//  AppDelegate.swift
//  devMod
//
//  Created by Paolo Tagliani on 10/23/14.
//  Copyright (c) 2014 Paolo Tagliani. All rights reserved.
//

import Cocoa
import Appkit

enum currentInterface{
    case light
    case dark
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    @IBOutlet weak var appMenu: NSMenu!
    var statusItem:NSStatusItem?
    var statusButton:NSStatusBarButton?
    var preferenceWindow:NSPreferencePanelWindowController?
    var darkTime:NSDate?
    var lightTime:NSDate?
    var dateCheckTimer:NSTimer?
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {

        //Tira su le date dai default di sistema
        darkTime =  NSUserDefaults.standardUserDefaults().valueForKey("DarkTime") as? NSDate
        lightTime =  NSUserDefaults.standardUserDefaults().valueForKey("LightTime") as? NSDate
        dateCheckTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "checkTime", userInfo: nil, repeats: true)
        
        //Update icon with current interface state
        updateIconForCurrentMode()
        NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector:"updateIconForCurrentMode", name: "AppleInterfaceThemeChangedNotification", object: nil)
    }
    override func awakeFromNib() {
        var statusBar = NSStatusBar.systemStatusBar()
        statusItem = statusBar.statusItemWithLength(-1)
        
        statusButton = statusItem!.button!
        statusButton?.target = self;
        statusButton?.action = "barButtonMenuPressed:"
        statusButton?.sendActionOn(Int((NSEventMask.LeftMouseUpMask | NSEventMask.RightMouseUpMask).rawValue))
        
        appMenu.delegate = self
    }

    func currentInterfaceState () -> currentInterface{
        let interfaceValue:CFString = "AppleInterfaceStyle" as CFString
        let property:CFPropertyList? = CFPreferencesCopyValue(interfaceValue, kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)
        
        if let light:CFPropertyList = property{
            if light as NSString == "Light"{
                return currentInterface.light
            }
            else{
                return currentInterface.dark
            }
        }
        else{
            return currentInterface.light
        }
    }
    
    func activateDevMode(sender: AnyObject) {
        let currentInterfaceLight:currentInterface = currentInterfaceState()
        
        switch currentInterfaceLight{
        case .light:
            activateDarkInterface()
        case .dark:
            activateLightInterface()
        }
    }
  
   func updateIconForCurrentMode() {
        let currentInterfaceLight:currentInterface = currentInterfaceState()
        
        switch currentInterfaceLight{
        case .light:
            statusButton?.image = NSImage(named: "panda-white")
        case .dark:
            statusButton?.image = NSImage(named: "panda-dark")
        }
    }
    

    func activateLightInterface(){
        println("Switch to Light")
        DevModeInterfaceManager.switchToLightMode()
    }
    
    func activateDarkInterface(){
        println("Switch to Darks")
        DevModeInterfaceManager.switchToDarkMode()
    }
    
    func barButtonMenuPressed(sender: NSStatusBarButton!){
        var event:NSEvent! = NSApp.currentEvent!
        println (event.description)
        if (event.type == NSEventType.RightMouseUp) {
            statusItem?.menu = appMenu
            statusItem?.popUpStatusItemMenu(appMenu) //Force the menu to be shown, otherwise it'll not
        }
        else{
            activateDevMode(sender)
        }
    }
    
  //MARK: - NSMenuDelegate
    func menuDidClose(menu: NSMenu) {
        statusItem?.menu = nil
    }
    
  //MARK: -Action management
    @IBAction func preferencesPressed(sender: AnyObject) {
        preferenceWindow = NSPreferencePanelWindowController(windowNibName: "NSPreferencePanelWindowController")
        var window:NSWindow! = preferenceWindow?.window!
        window.makeKeyAndOrderFront(self)
        NSApp.activateIgnoringOtherApps(true)
    }
    
    //MARK: - Check timer
    func checkTime(){
        let now = NSDate()
        
        if (darkTime != nil) && (hasEqualHourAndMinutes(darkTime!, date2: now)){
            activateDarkInterface()
        }
        
        if (lightTime != nil) && (hasEqualHourAndMinutes(lightTime!, date2: now)){
            activateLightInterface()
        }
        
    }
    
    func hasEqualHourAndMinutes(date1:NSDate, date2:NSDate) -> (Bool){
        let calendar = NSCalendar.currentCalendar()
        let flag = (NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute)
        
        let components1 = calendar.components(flag, fromDate: date1)
        let components2 = calendar.components(flag, fromDate: date2)
        
        let equalminutes = components1.minute == components2.minute
        let equalHour = components1.hour == components2.hour
        
        return equalminutes && equalHour
    }
}

