//
//  LHPopMenuItem.h
//  LHPopMenuDemo
//
//  Created by iDog on 2019/1/28.
//  Copyright © 2019 iDog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LHPopMenuType) {
    LHPopMenuItemTypeNormal,
    LHPopMenuItemTypeHighlight,
    LHPopMenuItemTypeDisabled
};
NS_ASSUME_NONNULL_BEGIN

typedef void(^LHPopMenuItemHandler)(NSInteger index);

@interface LHPopMenuItem : NSObject

@property (readwrite, nonatomic, strong) UIImage *image;
@property (readwrite, nonatomic, strong) NSString *title;
@property (readwrite, nonatomic, assign) BOOL highlight;
@property (readwrite, nonatomic, assign) BOOL disabled;
@property (nonatomic, copy)  LHPopMenuItemHandler handler;

+ (instancetype) menuItem:(NSString *) title
                    image:(UIImage *) image
                   type:(LHPopMenuType)type
                   handler:(LHPopMenuItemHandler) handler;

@end

NS_ASSUME_NONNULL_END
