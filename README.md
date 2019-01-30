## LHPopMenu
类似微信和支付宝右上角下拉的菜单封装，使用简单，欢迎star。

[Github地址](https://github.com/BigPoro/LHPopMenu)

效果图如下:

![](https://ws3.sinaimg.cn/large/006tNc79ly1fzoqrtyeibg30840eh0u7.gif)

自己调的这个效果，真的是太他么丑了😂😂😂

定制化比较高，很多地方都可以自定义。

使用方法很简单，如下:

```
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

```
