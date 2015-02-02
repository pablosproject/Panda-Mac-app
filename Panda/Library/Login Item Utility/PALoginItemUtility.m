//
//  PALoginItemUtility.m
//  devMod
//
//  Created by Paolo Tagliani on 10/25/14.
//  Copyright (c) 2014 Paolo Tagliani. All rights reserved.
//

#import "PALoginItemUtility.h"

@implementation PALoginItemUtility

+ (BOOL)isCurrentApplicatonInLoginItems{
    LSSharedFileListRef sharedFileList = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    NSString *applicationPath = [NSBundle mainBundle].bundlePath;
    BOOL result = NO;
    
    if (sharedFileList) {
        NSArray *sharedFileListArray = nil;
        UInt32 seedValue;
        
        sharedFileListArray = CFBridgingRelease(LSSharedFileListCopySnapshot(sharedFileList, &seedValue));
        
        for (id sharedFile in sharedFileListArray) {
            LSSharedFileListItemRef sharedFileListItem = (__bridge LSSharedFileListItemRef)sharedFile;
            CFURLRef applicationPathURL = NULL;
        
            applicationPathURL = LSSharedFileListItemCopyResolvedURL(sharedFileListItem, 0, NULL);
            
            if (applicationPathURL != NULL) {
                NSString *resolvedApplicationPath = [(__bridge NSURL *)applicationPathURL path];
                
                CFRelease(applicationPathURL);
                
                if ([resolvedApplicationPath compare: applicationPath] == NSOrderedSame) {
                    result = YES;
                    
                    break;
                }
            }
        }
        
        CFRelease(sharedFileList);
    } else {
        NSLog(@"Unable to create the shared file list.");
    }
    
    return result;

}

+ (void)addCurrentApplicatonToLoginItems{
    LSSharedFileListRef sharedFileList = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    NSString *applicationPath = [NSBundle mainBundle].bundlePath;
    NSURL *applicationPathURL = [NSURL fileURLWithPath: applicationPath];
    
    if (sharedFileList) {
        LSSharedFileListItemRef sharedFileListItem = LSSharedFileListInsertItemURL(sharedFileList, kLSSharedFileListItemLast, NULL, NULL, (__bridge CFURLRef)applicationPathURL, NULL, NULL);
        
        if (sharedFileListItem) {
            CFRelease(sharedFileListItem);
        }
        
        CFRelease(sharedFileList);
    } else {
        NSLog(@"Unable to create the shared file list.");
    }
}

+ (void)removeCurrentApplicatonToLoginItems{
    LSSharedFileListRef sharedFileList = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    NSString *applicationPath = [NSBundle mainBundle].bundlePath;
    
    if (sharedFileList) {
        NSArray *sharedFileListArray = nil;
        UInt32 seedValue;
        
        sharedFileListArray = CFBridgingRelease(LSSharedFileListCopySnapshot(sharedFileList, &seedValue));
        
        for (id sharedFile in sharedFileListArray) {
            LSSharedFileListItemRef sharedFileListItem = (__bridge LSSharedFileListItemRef)sharedFile;
            CFURLRef applicationPathURL = NULL;
            applicationPathURL = LSSharedFileListItemCopyResolvedURL(sharedFileListItem, 0, NULL);

            if (applicationPathURL != NULL) {
                NSString *resolvedApplicationPath = [(__bridge NSURL *)applicationPathURL path];
                
                if ([resolvedApplicationPath compare: applicationPath] == NSOrderedSame) {
                    LSSharedFileListItemRemove(sharedFileList, sharedFileListItem);
                }
                
                CFRelease(applicationPathURL);
            }
        }
        
        CFRelease(sharedFileList);
    } else {
        NSLog(@"Unable to create the shared file list.");
    }

}

@end
