//
//  UIColor+H24.h
//  Hemsida24
//
//  Created by Mathias Amnell on 2015-10-12.
//  Copyright © 2015 Apping AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (H24)

/** Returns an autoreleased UIColor instance with the hexadecimal color.
 
 @param hex A color in hexadecimal notation: `0xCCCCCC`, `0xF7F7F7`, etc.
 
 @return A new autoreleased UIColor instance. */
+ (UIColor *) colorWithHex:(int)hex;

@end
