//
//  CreateCircleViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-29.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateCircleViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *nameTextView;
@property (weak, nonatomic) IBOutlet UITextView *desTextView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (assign, nonatomic) UIViewController *fatherController;

- (IBAction)buttonClickHandle:(id)sender;


@end
