//
//  UINavigationController+UINavigationController_BackButton.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "UINavigationController_BackButton.h"

@implementation UINavigationController (UINavigationController_BackButton)


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //设置导航栏背景图片
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
		[self.navigationBar setBackgroundImage:[UIImage imageNamed:@"img_school_notice_normal"] forBarMetrics:UIBarMetricsDefault];
	}

    
    if (navigationController.viewControllers.count>1)
    {
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(10, 0, 25, 38);
        [leftBtn setImage:[UIImage imageNamed:@"btn_back_n"] forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:@"btn_back_s"] forState:UIControlStateHighlighted];
        [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];

    }
   }

- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end
