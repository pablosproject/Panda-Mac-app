//
//  PALoginItemUtility.h
//  devMod
//
//  Created by Paolo Tagliani on 10/25/14.
//  Copyright (c) 2014 Paolo Tagliani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PALoginItemUtility : NSObject

+ (BOOL)isCurrentApplicatonInLoginItems;
+ (void)addCurrentApplicatonToLoginItems;
+ (void)removeCurrentApplicatonToLoginItems;

@end
