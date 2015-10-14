#import <UIKit/UIKit.h>

@class H24ImageMeta;
@class H24ImageMetaViewController;

@protocol H24ImageMetaViewControllerDelegate <NSObject>

- (void)imageMetaViewController:(H24ImageMetaViewController *)controller didFinishEditingImageMeta:(H24ImageMeta *)imageMeta;

@end

/**
 A view controller that presents a simple form for editing `H24ImageMeta` properties.
 No consideration is given how a change in on property might affect related propreties
 and only serves to illustrate how changes to H24ImageMeta are reflected in the
 HTML source.
 */
@interface H24ImageMetaViewController : UIViewController

@property (nonatomic, weak) id<H24ImageMetaViewControllerDelegate>delegate;
@property (nonatomic, strong) H24ImageMeta *imageMeta;

@end
