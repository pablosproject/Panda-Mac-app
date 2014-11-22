//
//  About.swift
//  Panda
//
//  Created by Paolo Tagliani on 11/22/14.
//  Copyright (c) 2014 Paolo Tagliani. All rights reserved.
//

import Cocoa

class About: NSWindowController {

    @IBOutlet weak var versionLabel: NSTextField!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
        self.window?.titleVisibility = NSWindowTitleVisibility.Hidden;
        
        versionLabel.editable = false
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String{
            versionLabel.stringValue = "Version \(version)"
        }
    }
    
}
