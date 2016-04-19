//
//  About.swift
//  Panda
//
//  Created by Paolo Tagliani on 11/22/14.
//  Copyright (c) 2014 Paolo Tagliani. All rights reserved.
//

import Cocoa

class About: NSWindowController, NSTextFieldDelegate {

    @IBOutlet weak var versionLabel: NSTextField!
    @IBOutlet weak var developerLabel: NSTextField!
    @IBOutlet weak var graphicLabel: NSTextField!
    @IBOutlet weak var developerLabelWidth: NSLayoutConstraint!

    @IBOutlet weak var graphicLabelWidth: NSLayoutConstraint!
    override func windowDidLoad() {
        super.windowDidLoad()

        self.window?.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
        self.window?.titleVisibility = NSWindowTitleVisibility.Hidden;

        versionLabel.editable = false
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String {
            versionLabel.stringValue = "Version \(version)"
        }

        let html = "<a style =\"text-decoration: none; color:white;\" href=\"http://pablosproject.com/\">@PablosPoject</a>"
        let developerString = attributedStringFromHTML(html)
        developerLabel.selectable = true
        developerLabel.allowsEditingTextAttributes = true
        developerLabel.editable = false
        developerLabel.attributedStringValue = developerString
        let size = developerLabel.sizeThatFits(NSSize(width: 10000, height: 1100));
        developerLabelWidth.constant = size.width

        let html_graphic = "<a style =\"text-decoration: none; color:white;\" href=\"http://www.beatricevivaldi.graphics/\">@BeatriceVivaldi</a>"
        let graphicString = attributedStringFromHTML(html_graphic)
        graphicLabel.selectable = true
        graphicLabel.allowsEditingTextAttributes = true
        graphicLabel.editable = false
        graphicLabel.attributedStringValue = graphicString
        let size_graphic = graphicLabel.sizeThatFits(NSSize(width: 10000, height: 1100));
        graphicLabelWidth.constant = size_graphic.width

    }

    func attributedStringFromHTML(HTML: NSString) -> NSAttributedString {
        let font = NSFont(name: "HelveticaNeue-Light", size: 24)
        let htmlString = "<span style=\"color: white; font-family:'\(font!.fontName)'; font-size:\(font!.pointSize)px;\">\(HTML)</span>"
        let data = htmlString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let string = try? NSAttributedString(data: data!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                               NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding],
                documentAttributes: nil)
        return string!;
    }
}

