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
        
        //Tira su le date dai default di sistema
        darkTime =  NSUserDefaults.standardUserDefaults().valueForKey("DarkTime") as? NSDate
        lightTime =  NSUserDefaults.standardUserDefaults().valueForKey("LightTime") as? NSDate
        
        let interfaceStateForTime = interfaceStateForCurrentTime(translateDateToday(darkTime), lightDate: translateDateToday(lightTime), now: now)
        let currentInterface = currentInterfaceState()
        
        if interfaceStateForTime != currentInterface{
            switch interfaceStateForTime{
            case .light:
                activateLightInterface()
            case .dark:
                activateDarkInterface()
            }
        }
    }
    
    func translateDateToday(date:NSDate?) -> (NSDate?){
        if let date = date{
            let calendar = NSCalendar.currentCalendar()
            let calendarflag = (NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear)
            let hourFlag = (NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitSecond)
            let now = NSDate()
            let componentsCalendar = calendar.components(calendarflag, fromDate: now)
            let componentsHour = calendar.components(hourFlag, fromDate: date)
            
            var finalComponents = NSDateComponents()
            finalComponents = componentsCalendar
            finalComponents.hour = componentsHour.hour
            finalComponents.minute = componentsHour.minute
            finalComponents.second = componentsHour.second
            
            return calendar.dateFromComponents(finalComponents)
        }
        else{
            return nil
        }
    }
    
    func interfaceStateForCurrentTime(darkDate:NSDate?, lightDate:NSDate?, now:NSDate)->(currentInterface){
        if lightDate == nil && darkDate == nil{
            return currentInterfaceState()
        }
        else if darkTime == nil{
            return lightDate!.compare(now) == NSComparisonResult.OrderedAscending ? currentInterface.light : currentInterface.dark
        }
        else if lightDate == nil{
            let comparation = darkDate!.compare(now)
            return darkDate!.compare(now) == NSComparisonResult.OrderedAscending ? currentInterface.dark : currentInterface.light
        }
        else{
            let comparison = lightDate!.compare(darkDate!)
            if comparison == NSComparisonResult.OrderedDescending{ //Dark<Light
                let darkComparison = darkDate!.compare(now)
                let lightComparison = lightDate!.compare(now)
                
                //Now > Light || Now < Dark     ->light
                if darkComparison == NSComparisonResult.OrderedDescending || lightComparison == NSComparisonResult.OrderedAscending{
                    return currentInterface.light
                }
                //Now < Light && Now > Dark     ->dark
                if darkComparison == NSComparisonResult.OrderedAscending && lightComparison == NSComparisonResult.OrderedDescending{
                    return currentInterface.dark
                }
            }
            else{ //Dark>Light
                let darkComparison = darkDate!.compare(now)
                let lightComparison = lightDate!.compare(now)
                //Now > Dark || Now < Light     ->dark
                if darkComparison == NSComparisonResult.OrderedAscending || lightComparison == NSComparisonResult.OrderedDescending{
                    return currentInterface.dark
                }
                //Now < Dark && Now > Light     ->light
                if darkComparison == NSComparisonResult.OrderedDescending && lightComparison == NSComparisonResult.OrderedAscending{
                    return currentInterface.light
                }
            }
        }
        return currentInterfaceState()
    }
}

