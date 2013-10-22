//
//  CommitBasicInfoViewController.h
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-21.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommitBasicInfoViewController : UIViewController<UITableViewDataSource,
    UITableViewDelegate,
    UIImagePickerControllerDelegate,
    UITextViewDelegate,
    UIScrollViewDelegate>
{
    UIImagePickerController *imagePicker;
    NSArray *keyArray;
    UITextView *selectTextView;
    UIImage *selectImg;
}
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;
@property (strong, nonatomic) ProfileModel *infoModel;
@property (assign, nonatomic) UIViewController *fatherContrller;
- (IBAction)buttonClickHandle:(id)sender;
@end
