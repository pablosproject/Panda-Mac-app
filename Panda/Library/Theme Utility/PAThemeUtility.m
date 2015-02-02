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
    NSString *newMode = @"Light";
    CFPreferencesSetValue((CFStringRef)@"AppleInterfaceStyle", (__bridge CFPropertyListRef)(newMode), kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    CFPreferencesSetAppValue((CFStringRef)@"AppleInterfaceStyle", (__bridge CFPropertyListRef)(newMode), kCFPreferencesAnyApplication);
    CFPreferencesSynchronize(kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), (CFStringRef)@"AppleInterfaceThemeChangedNotification", NULL, NULL, YES);
}

+ (void)switchToDarkMode{
    NSString *newMode = @"Dark";
    CFPreferencesSetValue((CFStringRef)@"AppleInterfaceStyle", (__bridge CFPropertyListRef)(newMode), kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    CFPreferencesSetAppValue((CFStringRef)@"AppleInterfaceStyle", (__bridge CFPropertyListRef)(newMode), kCFPreferencesAnyApplication);
    CFPreferencesSynchronize(kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), (CFStringRef)@"AppleInterfaceThemeChangedNotification", NULL, NULL, YES);
}

@end
