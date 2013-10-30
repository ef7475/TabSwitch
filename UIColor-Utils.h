//
//  UIColor-Utils.h
//  TabSwitch
//
//  Created by Eyal Flato on 10/30/13.
//  Copyright (c) 2013 Eyal Flato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (UIColor_Utils)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorWithRGBHex:(UInt32)hex ;

@end
