//
//  ClearTextField.h
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-9.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClearTextField : UIView

@property(nonatomic, strong)UITextField *tf_input;
@property(nonatomic, strong)UIButton    *btn_clear;

-(NSString*)getText;
@end
