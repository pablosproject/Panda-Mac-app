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
    @IBOutlet weak var developerLabel: NSTextField!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
        self.window?.titleVisibility = NSWindowTitleVisibility.Hidden;
        
        versionLabel.editable = false
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String{
            versionLabel.stringValue = "Version \(version)"
        }
        
        let html = "Code by <a style =\"text-decoration: none; color:white;\" href=\"http://www.webpage.com\">@pablospoject</a>"
        let developerString = attributedStringFromHTML(html)
        developerLabel.selectable = true
        developerLabel.allowsEditingTextAttributes = true
        developerLabel.attributedStringValue = developerString
        developerLabel.sizeToFit()
    }
 
    func attributedStringFromHTML (HTML:NSString) -> NSAttributedString{
        let font = NSFont(name:"HelveticaNeue-Light", size: 20)
        let htmlString = "<span style=\"color: white; font-family:'\(font!.fontName)'; font-size:\(font!.pointSize)px;\">\(HTML)</span>"
        let data = htmlString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let string = NSAttributedString(data: data!,options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding],
            documentAttributes: nil, error: nil)
        return string!;
    }
}
