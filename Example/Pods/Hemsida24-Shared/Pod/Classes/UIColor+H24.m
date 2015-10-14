//
//  UIColor+H24.m
//  Hemsida24
//
//  Created by Mathias Amnell on 2015-10-12.
//  Copyright © 2015 Apping AB. All rights reserved.
//

#import "UIColor+H24.h"

@implementation UIColor (H24)

// http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
+ (UIColor *) colorWithHex:(int)hex {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

@end
