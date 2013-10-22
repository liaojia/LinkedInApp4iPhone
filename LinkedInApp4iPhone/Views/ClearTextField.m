//
//  ClearTextField.m
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-9.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "ClearTextField.h"
#define TF_INPUT_H 30
#define BTN_CLEAR_W 22

@implementation ClearTextField

@synthesize tf_input = _tf_input;
@synthesize btn_clear = _btn_clear;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

       // [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_login_edittext_backdrop"]]];
        self.backgroundColor = [UIColor whiteColor];
        _tf_input = [[UITextField alloc] initWithFrame:CGRectMake(5, (frame.size.height)/4.0, frame.size.width-50, TF_INPUT_H)];
        [self addSubview:_tf_input];
        
        _btn_clear = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_clear setFrame:CGRectMake(frame.size.width-10-BTN_CLEAR_W, (frame.size.height-BTN_CLEAR_W)/2.0, BTN_CLEAR_W, BTN_CLEAR_W)];
        [_btn_clear setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_login_edittext_delete"]]];
        [_btn_clear addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn_clear];

    }
    return self;
}

-(IBAction)clearAction:(id)sender{
    [_tf_input setText:@""];
}

-(NSString*)getText{
    return _tf_input.text;
}
@end
