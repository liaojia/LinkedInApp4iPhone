//
//  BaseViewController.m
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-8.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setButtonBgWithNomal:(NSString*) nomalImageStr selectedImageStr:(NSString *) selectedImageStr button:(UIButton*) button{
    [button setBackgroundImage:[UIImage imageNamed:nomalImageStr] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selectedImageStr] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:selectedImageStr] forState:UIControlStateHighlighted];
}

-(void) slideFrame:(BOOL) up
{
    int movementDistance = 0;
    
    if (self.interfaceOrientation == UIDeviceOrientationPortrait){
        movementDistance = 60;//260
    }else if(self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown){
        movementDistance = -60;
    }else if(self.interfaceOrientation == UIDeviceOrientationLandscapeLeft){
        movementDistance = -320;
    }else{
        movementDistance = 320;
    }
    
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)) {
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    } else {
        self.view.frame = CGRectOffset(self.view.frame, movement, 0);
    }
    
    [UIView commitAnimations];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self slideFrame:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self slideFrame:NO];
}
@end
