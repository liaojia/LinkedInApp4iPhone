//
//  UINavigationController+UINavigationController_BackButton.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "UINavigationController+UINavigationController_BackButton.h"

@implementation UINavigationController (UINavigationController_BackButton)


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 35, 35);
    [leftBtn setImage:[UIImage imageNamed:@"img_list_normal"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"img_list_pressed"] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end
