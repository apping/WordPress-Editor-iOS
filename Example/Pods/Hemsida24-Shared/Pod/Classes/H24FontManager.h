//
//  H24FontManager.h
//  Pods
//
//  Created by Mathias Amnell on 2015-10-14.
//
//

#import <Foundation/Foundation.h>

@interface H24FontManager : NSObject

+ (UIFont *)openSansLightFontOfSize:(CGFloat)size;
+ (UIFont *)openSansItalicFontOfSize:(CGFloat)size;
+ (UIFont *)openSansLightItalicFontOfSize:(CGFloat)size;
+ (UIFont *)openSansBoldFontOfSize:(CGFloat)size;
+ (UIFont *)openSansBoldItalicFontOfSize:(CGFloat)size;
+ (UIFont *)openSansSemiBoldFontOfSize:(CGFloat)size;
+ (UIFont *)openSansSemiBoldItalicFontOfSize:(CGFloat)size;
+ (UIFont *)openSansRegularFontOfSize:(CGFloat)size;

@end
