//
//  LHPopMenuOverlay.m
//  LHPopMenuDemo
//
//  Created by iDog on 2019/1/28.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHPopMenuOverlay.h"
#import "LHPopMenuView.h"
@implementation LHPopMenuOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        UITapGestureRecognizer *gestureRecognizer;
        gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(singleTap:)];
        [self addGestureRecognizer:gestureRecognizer];
    }
    return self;
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer
{
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[LHPopMenuView class]] && [v respondsToSelector:@selector(dismissMenuAnimated:)]) {
            [v performSelector:@selector(dismissMenuAnimated:) withObject:@(YES)];
        }
    }
}

@end
