//
//  LoginViewController.h
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-8.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic)IBOutlet UITextField *nameTxtField;
@property (weak, nonatomic)IBOutlet UITextField *psaTxtField;

- (IBAction)buttonClickHandle:(id)sender;
@end
