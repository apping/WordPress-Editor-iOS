#import "WPEditorFormatbarView.h"
#import "WPDeviceIdentification.h"
#import "WPEditorToolbarButton.h"
#import "ZSSBarButtonItem.h"

@interface WPEditorFormatbarView ()

@property (unsafe_unretained, nonatomic) IBOutlet UIToolbar *leftToolbar;
@property (unsafe_unretained, nonatomic) IBOutlet UIToolbar *rightToolbar;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *verticalBorder;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *horizontalBorder;

@property (unsafe_unretained, nonatomic) IBOutlet ZSSBarButtonItem *imageButton;
@property (unsafe_unretained, nonatomic) IBOutlet ZSSBarButtonItem *boldButton;
@property (unsafe_unretained, nonatomic) IBOutlet ZSSBarButtonItem *italicButton;
@property (unsafe_unretained, nonatomic) IBOutlet ZSSBarButtonItem *quoteButton;
@property (unsafe_unretained, nonatomic) IBOutlet ZSSBarButtonItem *unorderedListButton;
@property (unsafe_unretained, nonatomic) IBOutlet ZSSBarButtonItem *orderedListButton;
@property (unsafe_unretained, nonatomic) IBOutlet ZSSBarButtonItem *linkButton;
@property (unsafe_unretained, nonatomic) IBOutlet ZSSBarButtonItem *htmlButton;

@end

@implementation WPEditorFormatbarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)awakeFromNib {
    [self baseInit];
    return;
}

- (void)baseInit
{
    [self buildLeftToolbar];
    [self buildRightToolbar];
    [self buildBorders];
}

#pragma mark - Toolbar building helpers

- (void)buildLeftToolbar
{
    self.leftToolbar.barTintColor = self.backgroundColor;
    self.leftToolbar.translucent = NO;
    
    // We had some issues with the left toolbar not resizing properly - and we didn't realize
    // immediately.  Clipping to bounds is a good way to realize sooner and not later.
    //
    self.leftToolbar.clipsToBounds = YES;
    [self initBlockQuoteBarButton];
    [self initBoldBarButton];
    [self initImageBarButton];
    [self initLinkBarButton];
    [self initItalicBarButton];
    [self initOrderedListBarButton];
    [self initUnorderedListBarButton];
}

- (void)buildRightToolbar
{
    if (self.rightToolbar) {
        self.leftToolbar.barTintColor = self.backgroundColor;
        self.leftToolbar.translucent = NO;
        self.rightToolbar.clipsToBounds = YES;
        [self initShowSourceBarButton];
    }
}

- (void)buildBorders
{
    self.verticalBorder.backgroundColor = self.borderColor;
    self.horizontalBorder.backgroundColor = self.borderColor;
    
    if (self.verticalBorder) {
        self.verticalBorder.alpha = 0.7;
    }
}

#pragma mark - Setters

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    if (self.backgroundColor != backgroundColor) {
        super.backgroundColor = backgroundColor;
        self.leftToolbar.barTintColor = backgroundColor;
        self.rightToolbar.barTintColor = backgroundColor;
    }
}

- (void)setBorderColor:(UIColor *)borderColor
{
    if (_borderColor != borderColor) {
        _borderColor = borderColor;
        self.verticalBorder.backgroundColor = borderColor;
        self.horizontalBorder.backgroundColor = borderColor;
    }
}

- (void)setItemTintColor:(UIColor *)itemTintColor
{
    _itemTintColor = itemTintColor;
    
    for (UIBarButtonItem *item in self.leftToolbar.items) {
        if ([item isKindOfClass:[ZSSBarButtonItem class]]) {
            WPEditorToolbarButton *wpButton = (WPEditorToolbarButton*)item.customView;
            wpButton.normalTintColor = _itemTintColor;
        }
    }
    
    if (self.htmlButton) {
        WPEditorToolbarButton* wpEditorHtmlButton = (WPEditorToolbarButton*)self.htmlButton.customView;
        NSAssert([wpEditorHtmlButton isKindOfClass:[WPEditorToolbarButton class]],
                 @"Expected to have an HTML button of class WPEditorToolbarButton here.");
        
        wpEditorHtmlButton.normalTintColor = itemTintColor;
        self.htmlButton.tintColor = itemTintColor;
    }
}

- (void)setDisabledItemTintColor:(UIColor *)disabledItemTintColor
{
    _disabledItemTintColor = disabledItemTintColor;
    
    for (UIBarButtonItem *item in self.leftToolbar.items) {
        if ([item isKindOfClass:[ZSSBarButtonItem class]]) {
            WPEditorToolbarButton *wpButton = (WPEditorToolbarButton*)item.customView;
            wpButton.disabledTintColor = _disabledItemTintColor;
        }
    }
}

- (void)setSelectedItemTintColor:(UIColor *)selectedItemTintColor
{
    _selectedItemTintColor = selectedItemTintColor;
    
    for (UIBarButtonItem *item in self.leftToolbar.items) {
        if ([item isKindOfClass:[ZSSBarButtonItem class]]) {
            WPEditorToolbarButton *wpButton = (WPEditorToolbarButton*)item.customView;
            wpButton.selectedTintColor = _selectedItemTintColor;
        }
    }
    
    if (self.htmlButton) {
        WPEditorToolbarButton* htmlButton = (WPEditorToolbarButton*)self.htmlButton.customView;
        NSAssert([htmlButton isKindOfClass:[WPEditorToolbarButton class]],
                 @"Expected to have an HTML button of class WPEditorToolbarButton here.");
        
        htmlButton.selectedTintColor = _selectedItemTintColor;
    }
}

#pragma mark - Toolbar items

- (void)enableToolbarItems:(BOOL)enable
    shouldShowSourceButton:(BOOL)showSource
{
    NSArray *items = self.leftToolbar.items;
    
    for (ZSSBarButtonItem *item in items) {
        if (item.tag == kWPEditorViewControllerElementShowSourceBarButton) {
            item.enabled = showSource;
        } else {
            item.enabled = enable;
            
            if (!enable) {
                [item setSelected:NO];
            }
        }
    }
}

- (void)clearSelectedToolbarItems
{
    for (ZSSBarButtonItem *item in self.leftToolbar.items) {
        if (item.tag != kWPEditorViewControllerElementShowSourceBarButton) {
            [item setSelected:NO];
        }
    }
}

- (void)selectToolbarItemsForStyles:(NSArray*)styles
{
    NSArray *items = self.leftToolbar.items;
    
    for (UIBarButtonItem *item in items) {
        // Since we're using UIBarItem as negative separators, we need to make sure we don't try to
        // use those here.
        //
        if ([item isKindOfClass:[ZSSBarButtonItem class]]) {
            ZSSBarButtonItem* zssItem = (ZSSBarButtonItem*)item;
            
            if ([styles containsObject:zssItem.htmlProperty]) {
                zssItem.selected = YES;
            } else {
                zssItem.selected = NO;
            }
        }
    }
}

#pragma mark - Toolbar: buttons

- (void)initBarButtonItem:(ZSSBarButtonItem*)barButtonItem
                  withTag:(WPEditorViewControllerElementTag)tag
             htmlProperty:(NSString*)htmlProperty
                imageName:(NSString*)imageName
                   target:(id)target
                 selector:(SEL)selector
       accessibilityLabel:(NSString*)accessibilityLabel
{
    NSAssert(barButtonItem, @"ZSSBarButtonItem should not be nil here.");
    
    barButtonItem.tag = tag;
    barButtonItem.htmlProperty = htmlProperty;
    barButtonItem.accessibilityLabel = accessibilityLabel;
    
    UIImage* buttonImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    WPEditorToolbarButton* customButton = [[WPEditorToolbarButton alloc] initWithFrame:CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height)];
    [customButton setImage:buttonImage forState:UIControlStateNormal];
    customButton.normalTintColor = self.itemTintColor;
    customButton.selectedTintColor = self.selectedItemTintColor;
    customButton.disabledTintColor = self.disabledItemTintColor;
    [customButton addTarget:target
                     action:selector
           forControlEvents:UIControlEventTouchUpInside];
    barButtonItem.customView = customButton;
}

- (void)initBlockQuoteBarButton
{
    NSString* accessibilityLabel = NSLocalizedString(@"Block Quote",
                                                     @"Accessibility label for block quote button on formatting toolbar.");
    
    [self initBarButtonItem:self.quoteButton
                    withTag:kWPEditorViewControllerElementTagBlockQuoteBarButton
               htmlProperty:@"blockquote"
                  imageName:@"icon_format_quote"
                     target:self
                   selector:@selector(setBlockquote:)
         accessibilityLabel:accessibilityLabel];
}

- (void)initBoldBarButton
{
    NSString* accessibilityLabel = NSLocalizedString(@"Bold",
                                                     @"Accessibility label for bold button on formatting toolbar.");

    [self initBarButtonItem:self.boldButton
                    withTag:kWPEditorViewControllerElementTagBoldBarButton
               htmlProperty:@"bold"
                  imageName:@"icon_format_bold"
                     target:self
                   selector:@selector(setBold:)
         accessibilityLabel:accessibilityLabel];
}

- (void)initImageBarButton
{
    NSString* accessibilityLabel = NSLocalizedString(@"Insert Image",
                                                     @"Accessibility label for insert image button on formatting toolbar.");
    
    [self initBarButtonItem:self.imageButton
                    withTag:kWPEditorViewControllerElementTagInsertImageBarButton
               htmlProperty:@"image"
                  imageName:@"icon_format_media"
                     target:self
                   selector:@selector(insertImage:)
         accessibilityLabel:accessibilityLabel];
}

- (void)initLinkBarButton
{
    NSString* accessibilityLabel = NSLocalizedString(@"Insert Link",
                                                     @"Accessibility label for insert link button on formatting toolbar.");
    
    [self initBarButtonItem:self.linkButton
                    withTag:kWPEditorViewControllerElementTagInsertLinkBarButton
               htmlProperty:@"link"
                  imageName:@"icon_format_link"
                     target:self
                   selector:@selector(insertLink:)
         accessibilityLabel:accessibilityLabel];
}

- (void)initItalicBarButton
{
    NSString* accessibilityLabel = NSLocalizedString(@"Italic",
                                                     @"Accessibility label for italic button on formatting toolbar.");
    
    [self initBarButtonItem:self.italicButton
                    withTag:kWPEditorViewControllerElementTagItalicBarButton
               htmlProperty:@"italic"
                  imageName:@"icon_format_italic"
                     target:self
                   selector:@selector(setItalic:)
         accessibilityLabel:accessibilityLabel];
}

- (void)initOrderedListBarButton
{
    NSString* accessibilityLabel = NSLocalizedString(@"Ordered List",
                                                     @"Accessibility label for ordered list button on formatting toolbar.");
    
    [self initBarButtonItem:self.orderedListButton
                    withTag:kWPEditorViewControllerElementOrderedListBarButton
               htmlProperty:@"orderedList"
                  imageName:@"icon_format_ol"
                     target:self
                   selector:@selector(setOrderedList:)
         accessibilityLabel:accessibilityLabel];
}

- (void)initUnorderedListBarButton
{
    NSString* accessibilityLabel = NSLocalizedString(@"Unordered List",
                                                     @"Accessibility label for unordered list button on formatting toolbar.");
    
    [self initBarButtonItem:self.unorderedListButton
                    withTag:kWPEditorViewControllerElementUnorderedListBarButton
               htmlProperty:@"unorderedList"
                  imageName:@"icon_format_ul"
                     target:self
                   selector:@selector(setUnorderedList:)
         accessibilityLabel:accessibilityLabel];
}

- (void)initShowSourceBarButton
{
    NSString* accessibilityLabel = NSLocalizedString(@"HTML",
                                                     @"Accessibility label for HTML button on formatting toolbar.");
    
    [self initBarButtonItem:self.htmlButton
                    withTag:kWPEditorViewControllerElementShowSourceBarButton
               htmlProperty:@"source"
                  imageName:@"icon_format_html"
                     target:self
                   selector:@selector(showHTML:)
         accessibilityLabel:accessibilityLabel];
}

- (void)initStrikeThroughBarButton
{
//    NSString* accessibilityLabel = NSLocalizedString(@"Strike Through",
//                                                     @"Accessibility label for strikethrough button on formatting toolbar.");
//
//   [self initBarButtonItem:self.strikethroughButton
//                    withTag:kWPEditorViewControllerElementStrikeThroughBarButton
//               htmlProperty:@"strikeThrough"
//                  imageName:@"icon_format_strikethrough"
//                     target:self
//                   selector:@selector(setStrikeThrough:)
//         accessibilityLabel:accessibilityLabel];
}

#pragma mark - Required Delegate Calls

- (void)insertImage:(UIBarButtonItem *)barButtonItem
{
    [self.delegate editorToolbarView:self insertImage:barButtonItem];
}

- (void)setBold:(UIBarButtonItem *)barButtonItem
{
    [self.delegate editorToolbarView:self setBold:barButtonItem];
}

- (void)setItalic:(UIBarButtonItem *)barButtonItem
{
    [self.delegate editorToolbarView:self setItalic:barButtonItem];
}

- (void)setBlockquote:(UIBarButtonItem *)barButtonItem
{
    [self.delegate editorToolbarView:self setBlockquote:barButtonItem];
}

- (void)setUnorderedList:(UIBarButtonItem *)barButtonItem
{
    [self.delegate editorToolbarView:self setUnorderedList:barButtonItem];
}

- (void)setOrderedList:(UIBarButtonItem *)barButtonItem
{
    [self.delegate editorToolbarView:self setOrderedList:barButtonItem];
}

- (void)insertLink:(UIBarButtonItem *)barButtonItem
{
    [self.delegate editorToolbarView:self insertLink:barButtonItem];
}

- (void)showHTML:(UIBarButtonItem *)barButtonItem
{
    [self.delegate editorToolbarView:self showHTMLSource:barButtonItem];
}

@end