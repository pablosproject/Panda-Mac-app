//
//  AppDelegate.swift
//  devMod
//
//  Created by Paolo Tagliani on 10/23/14.
//  Copyright (c) 2014 Paolo Tagliani. All rights reserved.
//

import Cocoa
import Appkit

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
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }

    override func awakeFromNib() {
        var statusBar = NSStatusBar.systemStatusBar()
        statusItem = statusBar.statusItemWithLength(-1)
        
        statusButton = statusItem!.button!
        statusButton?.title = "devMod"
        statusButton?.target = self;
        statusButton?.action = "barButtonMenuPressed:"
        statusButton?.sendActionOn(Int((NSEventMask.LeftMouseDownMask | NSEventMask.RightMouseDownMask | NSEventMask.RightMouseUpMask).rawValue))
        
        appMenu.delegate = self
    }

    func activateDevMode(sender: AnyObject) {
        var interfaceValue:CFString = "AppleInterfaceStyle" as CFString
        var property:CFPropertyList? = CFPreferencesCopyValue(interfaceValue, kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)
        
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
        if (event.type == NSEventType.RightMouseDown) || (event.type == NSEventType.RightMouseUp) {
            statusItem?.menu = appMenu
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
        preferenceWindow!.showWindow(self)
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

