//
//  BaseViewController.h
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-8.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UITextFieldDelegate>

-(void)setButtonBgWithNomal:(NSString*) nomalImageStr selectedImageStr:(NSString *) selectedImageStr button:(UIButton*) button;
@end
