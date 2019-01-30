//
//  LHPopMenuView.h
//  LHPopMenuDemo
//
//  Created by iDog on 2019/1/28.
//  Copyright © 2019 iDog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHPopMenuItem.h"
@interface LHPopMenuViewConfig : NSObject

+ (LHPopMenuViewConfig *) globalConfig;

@property (nonatomic, assign) CGFloat titleFontSize; // 字体大小
@property (nonatomic, strong) UIColor *backgroundColor; // 背景颜色
@property (nonatomic, strong) UIColor *maskColor; // 蒙版颜色
@property (nonatomic, strong) UIColor *itemNormalColor; // 默认item背景颜色
@property (nonatomic, strong) UIColor *itemHighlightColor; // 高亮item背景颜色
@property (nonatomic, strong) UIColor *itemDisabledColor; // 失效item背景颜色
@property (nonatomic, strong) UIColor *titleNormalColor; // 默认字体颜色
@property (nonatomic, strong) UIColor *titleHighlightColor; // 高亮字体颜色
@property (nonatomic, strong) UIColor *titleDisabledColor; // 失效字体颜色
@end

NS_ASSUME_NONNULL_BEGIN
@interface LHPopMenuView : UIView


- (void)showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray <LHPopMenuItem *>*)menuItems;

- (void)dismissMenuAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
