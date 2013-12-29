//
//  ReplyViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-29.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述：  回复页面
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/

#import <UIKit/UIKit.h>

@interface ReplyViewController : UIViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView*inputTextView;
@property (weak, nonatomic) IBOutlet UILabel *messLabel;
@property (strong, nonatomic) NSString *cirecleId; //圈子的id
@property (strong, nonatomic) NSString *resId; //回复留言的id
@property (assign, nonatomic) UIViewController *fatherController;

- (IBAction)buttonClickHandle:(id)sender;
@end
