//
//  LHPopMenuItem.m
//  LHPopMenuDemo
//
//  Created by iDog on 2019/1/28.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHPopMenuItem.h"

@implementation LHPopMenuItem

+ (instancetype) menuItem:(NSString *) title
                    image:(UIImage *) image
                   type:(LHPopMenuType)type
                   handler:(LHPopMenuItemHandler) handler
{
    return [[LHPopMenuItem alloc]initWithTitle:title image:image type:type handler:handler];
}
- (id) initWithTitle:(NSString *) title
      image:(UIImage *) image
     type:(LHPopMenuType)type
     handler:(LHPopMenuItemHandler) handler
{
    NSParameterAssert(title.length || image);
    
    self = [super init];
    if (self) {
        _title = title;
        _image = image;
        _handler = handler;
        switch (type) {
            case LHPopMenuItemTypeNormal:
                break;
            case LHPopMenuItemTypeHighlight:
                self.highlight = YES;
                break;
            case LHPopMenuItemTypeDisabled:
                self.disabled = YES;
                break;
        }
    }
    return self;
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"<%@ #%p %@>", [self class], self, _title];
}
@end
