//
//  LHPopMenu.h
//  LHPopMenuDemo
//
//  Created by iDog on 2019/1/28.
//  Copyright © 2019 iDog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LHPopMenuView.h"
NS_ASSUME_NONNULL_BEGIN


@interface LHPopMenu : NSObject

+ (void)showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray <LHPopMenuItem *> *)menuItems;

+ (void)dismissMenuAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
