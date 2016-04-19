//
//  PAThemeUtility.m
//  devMod
//
//  Created by Paolo Tagliani on 10/24/14.
//  Copyright (c) 2014 Paolo Tagliani. All rights reserved.
//

#import "PAThemeUtility.h"

@implementation PAThemeUtility

+ (void)switchToLightMode{
    CFPreferencesSetValue((CFStringRef)@"AppleInterfaceStyle", NULL, kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), (CFStringRef)@"AppleInterfaceThemeChangedNotification", NULL, NULL, YES);
}

+ (void)switchToDarkMode{
    CFPreferencesSetValue((CFStringRef)@"AppleInterfaceStyle", @"Dark", kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), (CFStringRef)@"AppleInterfaceThemeChangedNotification", NULL, NULL, YES);
}

@end
