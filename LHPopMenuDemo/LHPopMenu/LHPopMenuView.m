//
//  LHPopMenuView.m
//  LHPopMenuDemo
//
//  Created by iDog on 2019/1/28.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHPopMenuView.h"
#import "LHPopMenuOverlay.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark LHPopMenuViewConfig
@implementation LHPopMenuViewConfig

+ (LHPopMenuViewConfig *)globalConfig
{
    static LHPopMenuViewConfig *config;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        config = [LHPopMenuViewConfig new];
    });
    
    return config;
}
- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.titleFontSize = 16; // 字体大小
        self.backgroundColor = [UIColor orangeColor]; // 背景颜色
        self.maskColor = [UIColor clearColor]; // 蒙版颜色
        self.itemNormalColor = [UIColor whiteColor];
        self.itemHighlightColor = [UIColor blueColor];
        self.itemDisabledColor = [UIColor lightGrayColor];
        self.titleNormalColor = [UIColor blackColor];
        self.titleHighlightColor = [UIColor orangeColor];
        self.titleDisabledColor = [UIColor grayColor];
    }
    return self;
}
@end

static const CGFloat kArrowSize = 12.f;
typedef enum {
    LHPopMenuViewArrowDirectionNone,
    LHPopMenuViewArrowDirectionUp,
    LHPopMenuViewArrowDirectionDown,
    LHPopMenuViewArrowDirectionLeft,
    LHPopMenuViewArrowDirectionRight,
    
} LHPopMenuViewArrowDirection;

@interface LHPopMenuView()
{
    LHPopMenuViewArrowDirection _arrowDirection;
    CGFloat                     _arrowPosition;
    UIView                      *_contentView;
    NSArray                     *_menuItems;
}

@end

@implementation LHPopMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectZero];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = YES;
        self.alpha = 0;
        
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeMake(2, 2);
        self.layer.shadowRadius = 2;
    }
    return self;
}


#pragma mark Show and Dismiss
- (void)showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray <LHPopMenuItem *>*)menuItems
{
    _menuItems = menuItems;
    
    _contentView = [self mkContentView];
    [self addSubview:_contentView];
    
    [self setupFrameInView:view fromRect:rect];
    
    // 蒙版
    LHPopMenuOverlay *overlay = [[LHPopMenuOverlay alloc] initWithFrame:view.bounds];
    overlay.backgroundColor = [LHPopMenuViewConfig globalConfig].maskColor;
    [overlay addSubview:self];
    [view addSubview:overlay];
    
    _contentView.hidden = YES;
    const CGRect toFrame = self.frame;
    self.frame = (CGRect){self.arrowPoint, 1, 1};
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0f;
        self.frame = toFrame;
    } completion:^(BOOL finished) {
        _contentView.hidden = NO;
    }];
}
- (void)dismissMenuAnimated:(BOOL)animated
{
    if (self.superview) {
        if (animated) {
            _contentView.hidden = YES;
            const CGRect toFrame = (CGRect){self.arrowPoint, 1, 1};
            [UIView animateWithDuration:0.2 animations:^{
                self.alpha = 0;
                self.frame = toFrame;
            } completion:^(BOOL finished) {
                if ([self.superview isKindOfClass:[LHPopMenuOverlay class]])
                    [self.superview removeFromSuperview];
                [self removeFromSuperview];
            }];
        } else {
            if ([self.superview isKindOfClass:[LHPopMenuOverlay class]])
                [self.superview removeFromSuperview];
            [self removeFromSuperview];
        }
    }
}
#pragma mark Action
- (void)performAction:(UIButton *)sender
{
    [self dismissMenuAnimated:YES];
    
    UIButton *button = (UIButton *)sender;
    LHPopMenuItem *menuItem = _menuItems[button.tag];
    menuItem.handler(button.tag);
}
#pragma mark SetupUI
- (void)setupFrameInView:(UIView *)view fromRect:(CGRect)fromRect
{
    const CGSize contentSize = _contentView.frame.size;
    
    const CGFloat outerWidth = view.bounds.size.width;
    const CGFloat outerHeight = view.bounds.size.height;
    
    const CGFloat rectX0 = fromRect.origin.x;
    const CGFloat rectX1 = fromRect.origin.x + fromRect.size.width;
    const CGFloat rectXM = fromRect.origin.x + fromRect.size.width * 0.5f;
    const CGFloat rectY0 = fromRect.origin.y;
    const CGFloat rectY1 = fromRect.origin.y + fromRect.size.height;
    const CGFloat rectYM = fromRect.origin.y + fromRect.size.height * 0.5f;;
    
    const CGFloat widthPlusArrow = contentSize.width + kArrowSize;
    const CGFloat heightPlusArrow = contentSize.height + kArrowSize;
    const CGFloat widthHalf = contentSize.width * 0.5f;
    const CGFloat heightHalf = contentSize.height * 0.5f;
    
    const CGFloat kMargin = 5.f;
    
    if (heightPlusArrow < (outerHeight - rectY1)) {
        
        _arrowDirection = LHPopMenuViewArrowDirectionUp;
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY1
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        _arrowPosition = rectXM - point.x;
        //_arrowPosition = MAX(16, MIN(_arrowPosition, contentSize.width - 16));
        _contentView.frame = (CGRect){0, kArrowSize, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width,
            contentSize.height + kArrowSize
        };
        
    } else if (heightPlusArrow < rectY0) {
        
        _arrowDirection = LHPopMenuViewArrowDirectionDown;
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY0 - heightPlusArrow
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        _arrowPosition = rectXM - point.x;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width,
            contentSize.height + kArrowSize
        };
        
    } else if (widthPlusArrow < (outerWidth - rectX1)) {
        
        _arrowDirection = LHPopMenuViewArrowDirectionLeft;
        CGPoint point = (CGPoint){
            rectX1,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + kMargin) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        _arrowPosition = rectYM - point.y;
        _contentView.frame = (CGRect){kArrowSize, 0, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width + kArrowSize,
            contentSize.height
        };
        
    } else if (widthPlusArrow < rectX0) {
        
        _arrowDirection = LHPopMenuViewArrowDirectionRight;
        CGPoint point = (CGPoint){
            rectX0 - widthPlusArrow,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + 5) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        _arrowPosition = rectYM - point.y;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width  + kArrowSize,
            contentSize.height
        };
        
    } else {
        
        _arrowDirection = LHPopMenuViewArrowDirectionNone;
        
        self.frame = (CGRect) {
            
            (outerWidth - contentSize.width)   * 0.5f,
            (outerHeight - contentSize.height) * 0.5f,
            contentSize,
        };
    }
}
- (UIView *) mkContentView
{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    if (!_menuItems.count)
        return nil;
    
    const CGFloat kMinMenuItemHeight = 32.f;
    const CGFloat kMinMenuItemWidth = 32.f;
    const CGFloat kMarginX = 5.f;
    const CGFloat kMarginY = 0;
    
    
    UIFont *titleFont = [UIFont systemFontOfSize:[LHPopMenuViewConfig globalConfig].titleFontSize];
    CGFloat maxImageWidth = 0;
    CGFloat maxItemHeight = 0;
    CGFloat maxItemWidth = 0;
    
    for (LHPopMenuItem *menuItem in _menuItems) {
        
        const CGSize imageSize = menuItem.image.size;
        if (imageSize.width > maxImageWidth)
            maxImageWidth = imageSize.width;
    }
    
    if (maxImageWidth) {
        maxImageWidth += kMarginX;
    }
    
    for (LHPopMenuItem *menuItem in _menuItems) {
        const CGSize titleSize = [menuItem.title sizeWithAttributes:@{NSFontAttributeName : titleFont}];
        const CGSize imageSize = menuItem.image.size;
        
        const CGFloat itemHeight = MAX(titleSize.height, imageSize.height) + kMarginY * 2;
        const CGFloat itemWidth = ((!menuItem.image) ? titleSize.width : maxImageWidth + titleSize.width) + kMarginX * 4;
        
        if (itemHeight > maxItemHeight)
            maxItemHeight = itemHeight;
        
        if (itemWidth > maxItemWidth)
            maxItemWidth = itemWidth;
    }
    maxItemWidth  = MAX(maxItemWidth, kMinMenuItemWidth);
    maxItemHeight = MAX(maxItemHeight, kMinMenuItemHeight);
    
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.autoresizingMask = UIViewAutoresizingNone;
    contentView.backgroundColor = [UIColor clearColor];
    contentView.opaque = NO;
    
    CGFloat itemY = kMarginY * 2;
    NSUInteger itemNum = 0;
    
    for (LHPopMenuItem *menuItem in _menuItems) {
        
        const CGRect itemFrame = (CGRect){0, itemY, maxItemWidth, maxItemHeight};
        
        UIView *itemView = [[UIView alloc] initWithFrame:itemFrame];
        itemView.autoresizingMask = UIViewAutoresizingNone;
        itemView.backgroundColor = [UIColor clearColor];
        itemView.opaque = NO;
        
        [contentView addSubview:itemView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = itemNum;
        button.frame = itemView.bounds;
        button.enabled = !menuItem.disabled;
        button.highlighted = menuItem.highlight;
        button.backgroundColor = [UIColor clearColor];
        button.opaque = NO;
        button.autoresizingMask = UIViewAutoresizingNone;
        [button setTitle:menuItem.title forState:UIControlStateNormal];
        [button setBackgroundImage:[self colorToImageWithColor:[LHPopMenuViewConfig globalConfig].itemHighlightColor] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[self colorToImageWithColor:[LHPopMenuViewConfig globalConfig].itemDisabledColor] forState:UIControlStateDisabled];
        [button setBackgroundImage:[self colorToImageWithColor:[LHPopMenuViewConfig globalConfig].itemNormalColor] forState:UIControlStateNormal];
        
        [button setImage:menuItem.image forState:UIControlStateNormal];
        [button setTitleColor:[LHPopMenuViewConfig globalConfig].titleNormalColor forState:UIControlStateNormal];
        [button setTitleColor:[LHPopMenuViewConfig globalConfig].titleHighlightColor forState:UIControlStateHighlighted];
        [button setTitleColor:[LHPopMenuViewConfig globalConfig].titleDisabledColor forState:UIControlStateDisabled];
        button.titleLabel.font = titleFont;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [button addTarget:self
                   action:@selector(performAction:)
         forControlEvents:UIControlEventTouchUpInside];
        [itemView addSubview:button];
        
        if (itemNum < _menuItems.count - 1) {
            
            UIImageView *lineView = [[UIImageView alloc] initWithImage:[self colorToImageWithColor:[UIColor lightGrayColor]]];
            lineView.frame = (CGRect){kMarginX * 2, maxItemHeight + 1,maxItemWidth - kMarginX * 4, 1};
            lineView.contentMode = UIViewContentModeLeft;
            [itemView addSubview:lineView];
            
            itemY += 2;
        }
        
        itemY += maxItemHeight;
        ++itemNum;
    }
    
    contentView.frame = (CGRect){0, 0, maxItemWidth, itemY + kMarginY * 2};
    
    return contentView;
}

- (CGPoint) arrowPoint
{
    CGPoint point;
    
    if (_arrowDirection == LHPopMenuViewArrowDirectionUp) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMinY(self.frame) };
        
    } else if (_arrowDirection == LHPopMenuViewArrowDirectionDown) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMaxY(self.frame) };
        
    } else if (_arrowDirection == LHPopMenuViewArrowDirectionLeft) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition  };
        
    } else if (_arrowDirection == LHPopMenuViewArrowDirectionRight) {
        
        point = (CGPoint){ CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition  };
        
    } else {
        
        point = self.center;
    }
    
    return point;
}

- (void) drawRect:(CGRect)rect
{
    [self drawBackground:self.bounds
               inContext:UIGraphicsGetCurrentContext()];
}

- (void)drawBackground:(CGRect)frame
             inContext:(CGContextRef) context
{
    CGFloat R0 = 0.267, G0 = 0.303, B0 = 0.335;
    CGFloat R1 = 0.040, G1 = 0.040, B1 = 0.040;
    
    UIColor *tintColor = [LHPopMenuViewConfig globalConfig].backgroundColor;
    
    if (tintColor) {
        CGFloat a;
        [tintColor getRed:&R0 green:&G0 blue:&B0 alpha:&a];
    }
    
    CGFloat X0 = frame.origin.x;
    CGFloat X1 = frame.origin.x + frame.size.width;
    CGFloat Y0 = frame.origin.y;
    CGFloat Y1 = frame.origin.y + frame.size.height;
    
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    
    const CGFloat kEmbedFix = 3.f;
    
    if (_arrowDirection == LHPopMenuViewArrowDirectionUp) {
        
        const CGFloat arrowXM = _arrowPosition;
        const CGFloat arrowX0 = arrowXM - kArrowSize;
        const CGFloat arrowX1 = arrowXM + kArrowSize;
        const CGFloat arrowY0 = Y0;
        const CGFloat arrowY1 = Y0 + kArrowSize + kEmbedFix;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY0}];
        
        [[UIColor colorWithRed:R0 green:G0 blue:B0 alpha:1] set];
        
        Y0 += kArrowSize;
        
    } else if (_arrowDirection == LHPopMenuViewArrowDirectionDown) {
        
        const CGFloat arrowXM = _arrowPosition;
        const CGFloat arrowX0 = arrowXM - kArrowSize;
        const CGFloat arrowX1 = arrowXM + kArrowSize;
        const CGFloat arrowY0 = Y1 - kArrowSize - kEmbedFix;
        const CGFloat arrowY1 = Y1;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY1}];
        
        [[UIColor colorWithRed:R1 green:G1 blue:B1 alpha:1] set];
        
        Y1 -= kArrowSize;
        
    } else if (_arrowDirection == LHPopMenuViewArrowDirectionLeft) {
        
        const CGFloat arrowYM = _arrowPosition;
        const CGFloat arrowX0 = X0;
        const CGFloat arrowX1 = X0 + kArrowSize + kEmbedFix;
        const CGFloat arrowY0 = arrowYM - kArrowSize;;
        const CGFloat arrowY1 = arrowYM + kArrowSize;
        
        [arrowPath moveToPoint:    (CGPoint){arrowX0, arrowYM}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowYM}];
        
        [[UIColor colorWithRed:R0 green:G0 blue:B0 alpha:1] set];
        
        X0 += kArrowSize;
        
    } else if (_arrowDirection == LHPopMenuViewArrowDirectionRight) {
        
        const CGFloat arrowYM = _arrowPosition;
        const CGFloat arrowX0 = X1;
        const CGFloat arrowX1 = X1 - kArrowSize - kEmbedFix;
        const CGFloat arrowY0 = arrowYM - kArrowSize;;
        const CGFloat arrowY1 = arrowYM + kArrowSize;
        
        [arrowPath moveToPoint:    (CGPoint){arrowX0, arrowYM}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowYM}];
        
        [[UIColor colorWithRed:R1 green:G1 blue:B1 alpha:1] set];
        
        X1 -= kArrowSize;
    }
    
    [arrowPath fill];
    
    
    const CGRect bodyFrame = {X0, Y0, X1 - X0, Y1 - Y0};
    
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:bodyFrame
                                                          cornerRadius:8];
    
    const CGFloat locations[] = {0, 1};
    const CGFloat components[] = {
        R0, G0, B0, 1,
        R0, G0, B0, 1,
    };
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,
                                                                 components,
                                                                 locations,
                                                                 sizeof(locations)/sizeof(locations[0]));
    CGColorSpaceRelease(colorSpace);
    
    
    [borderPath addClip];
    
    CGPoint start, end;
    
    if (_arrowDirection == LHPopMenuViewArrowDirectionLeft ||
        _arrowDirection == LHPopMenuViewArrowDirectionRight) {
        
        start = (CGPoint){X0, Y0};
        end = (CGPoint){X1, Y0};
        
    } else {
        
        start = (CGPoint){X0, Y0};
        end = (CGPoint){X0, Y1};
    }
    
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    
    CGGradientRelease(gradient);
}


/**
 颜色转图片

 @param color 颜色
 @return 对应颜色的图片
 */
- (UIImage *)colorToImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
