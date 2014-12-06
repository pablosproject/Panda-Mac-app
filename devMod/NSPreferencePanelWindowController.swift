//
//  NSPreferencePanelWindowController.swift
//  devMod
//
//  Created by Paolo Tagliani on 10/25/14.
//  Copyright (c) 2014 Paolo Tagliani. All rights reserved.
//

import Cocoa


class NSPreferencePanelWindowController: NSWindowController {

    @IBOutlet weak var launchAtStartupButton: NSButton!
    @IBOutlet weak var darkModeDatePicker: NSDatePicker!
    @IBOutlet weak var lightModeDatePicker: NSDatePicker!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
        self.window?.titleVisibility = NSWindowTitleVisibility.Hidden;

        //Set login item state
        launchAtStartupButton.state = DevModeLoginItemManager.isCurrentApplicatonInLoginItems() ? NSOnState : NSOffState
        
        darkModeDatePicker.bezeled = true;
        lightModeDatePicker.bezeled = true;
        
        //Set darkDate
        if let darkDate = NSUserDefaults.standardUserDefaults().objectForKey("DarkTime") as? NSDate {
            darkModeDatePicker.dateValue = darkDate
        }
        
        //Set light date
        if let lightDate = NSUserDefaults.standardUserDefaults().objectForKey("LightTime") as? NSDate{
            lightModeDatePicker.dateValue = lightDate
        }
    }
    
    @IBAction func launchLoginPressed(sender: NSButton) {
        if sender.state == NSOnState{
            DevModeLoginItemManager.addCurrentApplicatonToLoginItems()
        }
        else{
            DevModeLoginItemManager.removeCurrentApplicatonToLoginItems()
        }
    }
    
    @IBAction func darkTimeChange(sender: NSDatePicker) {
        let appDelegate = NSApplication.sharedApplication().delegate as AppDelegate
        appDelegate.darkTime = sender.dateValue
        var userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(sender.dateValue, forKey: "DarkTime")
        userDefaults.synchronize()
    }
    
    @IBAction func lightTimeChange(sender: NSDatePicker) {
        let appDelegate = NSApplication.sharedApplication().delegate as AppDelegate
        appDelegate.lightTime = sender.dateValue
        var userDefaults = NSUserDefaults.standardUserDefaults()
        NSUserDefaults.standardUserDefaults().setValue(sender.dateValue, forKey: "LightTime")
        userDefaults.synchronize()
    }
    
}
