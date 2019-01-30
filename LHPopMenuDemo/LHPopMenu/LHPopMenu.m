//
//  LHPopMenu.m
//  LHPopMenuDemo
//
//  Created by iDog on 2019/1/28.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHPopMenu.h"
#import "LHPopMenuView.h"
@interface LHPopMenu()
{
    LHPopMenuView  *_menuView;
    BOOL        _observing;
}

@end

static LHPopMenu *gMenu;

@implementation LHPopMenu
+ (instancetype) sharedMenu
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gMenu = [[LHPopMenu alloc] init];
    });
    return gMenu;
}

+ (void)showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray <LHPopMenuItem *> *)menuItems
{
    [[self sharedMenu] showMenuInView:view fromRect:rect menuItems:menuItems];
}

+ (void)dismissMenuAnimated:(BOOL)animated
{
    [[self sharedMenu] dismissMenuWithAnimated:animated];
}
- (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
              menuItems:(NSArray *)menuItems
{
    NSParameterAssert(view);
    NSParameterAssert(menuItems.count);
    
    if (_menuView) {
        
        [_menuView dismissMenuAnimated:NO];
        _menuView = nil;
    }
    
    if (!_observing) {
        
        _observing = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationWillChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    }
    
    _menuView = [[LHPopMenuView alloc] init];
    [_menuView showMenuInView:view fromRect:rect menuItems:menuItems];
}

- (void)dismissMenuWithAnimated:(BOOL)animated
{
    if (_menuView) {
        [_menuView dismissMenuAnimated:animated];
        _menuView = nil;
    }
    if (_observing) {
        _observing = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
- (void) orientationWillChange: (NSNotification *)noti
{
    [self dismissMenuWithAnimated:NO];
}
- (void) dealloc
{
    if (_observing) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
@end
