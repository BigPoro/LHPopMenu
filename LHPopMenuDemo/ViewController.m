//
//  ViewController.m
//  LHPopMenuDemo
//
//  Created by iDog on 2019/1/28.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "ViewController.h"
#import "LHPopMenu/LHPopMenu.h"
@interface ViewController (){
    
    UIButton *_btn1;
    UIButton *_btn2;
    UIButton *_btn3;
    UIButton *_btn4;
    UIButton *_btn5;
    UIButton *_btn6;
    UIButton *_btn7;
}

@end

@implementation ViewController

- (void) loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    const CGFloat W = self.view.bounds.size.width;
    const CGFloat H = self.view.bounds.size.height;
    
    _btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn1.frame = CGRectMake(5, 5, 100, 50);
    [_btn1 setTitle:@"Click me" forState:UIControlStateNormal];
    [_btn1 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn1];
    
    _btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn2.frame = CGRectMake(5, H - 55, 100, 50);
    [_btn2 setTitle:@"Click me" forState:UIControlStateNormal];
    [_btn2 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn2];
    
    _btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn3.frame = CGRectMake(W - 105, 5, 100, 50);
    [_btn3 setTitle:@"Click me" forState:UIControlStateNormal];
    [_btn3 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn3];
    
    _btn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn4.frame = CGRectMake(W - 105, H - 55, 100, 50);
    [_btn4 setTitle:@"Click me" forState:UIControlStateNormal];
    [_btn4 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn4];
    
    _btn5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn5.frame = CGRectMake(5, (H-50) * 0.5, 100, 50);
    [_btn5 setTitle:@"Click me" forState:UIControlStateNormal];
    [_btn5 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn5];
    
    _btn6 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn6.frame = CGRectMake(W - 105, (H-50) * 0.5, 100, 50);
    [_btn6 setTitle:@"Click me" forState:UIControlStateNormal];
    [_btn6 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn6];
    
    _btn7 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn7.frame = CGRectMake((W - 100)* 0.5, (H-50) * 0.5, 100, 50);
    [_btn7 setTitle:@"Click me" forState:UIControlStateNormal];
    [_btn7 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn7];
}
- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    const CGFloat W = self.view.bounds.size.width;
    const CGFloat H = self.view.bounds.size.height;
    
    _btn1.frame = CGRectMake(5, 5, 100, 50);
    _btn2.frame = CGRectMake(5, H - 55, 100, 50);
    _btn3.frame = CGRectMake(W - 105, 5, 100, 50);
    _btn4.frame = CGRectMake(W - 105, H - 55, 100, 50);
    _btn5.frame = CGRectMake(5, (H-50) * 0.5, 100, 50);
    _btn6.frame = CGRectMake(W - 105, (H-50) * 0.5, 100, 50);
    _btn7.frame = CGRectMake((W - 100)* 0.5, (H-50) * 0.5, 100, 50);
}
- (void)showMenu:(UIButton *)sender
{
    LHPopMenuItemHandler handler = ^(NSInteger index){
        NSLog(@"%ld",(long)index);
    };
    NSArray *arr = @[
                     [LHPopMenuItem menuItem:@"分享分享" image:[UIImage imageNamed:@"action_icon"] type:LHPopMenuItemTypeNormal handler:handler],
                     [LHPopMenuItem menuItem:@"确定分享" image:[UIImage imageNamed:@"check_icon"] type:LHPopMenuItemTypeHighlight handler:handler],
                     [LHPopMenuItem menuItem:@"主页分享" image:[UIImage imageNamed:@"home_icon"] type:LHPopMenuItemTypeDisabled handler:handler],
                     [LHPopMenuItem menuItem:@"搜索分享" image:[UIImage imageNamed:@"search_icon"] type:LHPopMenuItemTypeNormal handler:handler]];
    [LHPopMenuViewConfig globalConfig].itemNormalColor = [UIColor lightGrayColor];
    [LHPopMenuViewConfig globalConfig].maskColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    [LHPopMenu showMenuInView:self.view fromRect:sender.frame menuItems:arr ];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


@end
