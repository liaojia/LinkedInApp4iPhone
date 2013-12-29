//
//  ReplyViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-29.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "ReplyViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface ReplyViewController ()

@end

@implementation ReplyViewController

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
    // Do any additional setup after loading the view from its nib.
    self.inputTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.inputTextView.layer.borderWidth = 0.5;
    self.inputTextView.layer.cornerRadius = 6;
    
    if (self.resId==Nil)
    {
        self.navigationItem.title = @"发表评论";
    }
    else
    {
        self.navigationItem.title = @"回复评论";
    }
    
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--发送http请求
-(void)circleReply
{
    NSDictionary *dict = nil;
    if (self.resId==nil)
    {
        dict = @{@"content":self.inputTextView.text};
    }
    else
    {
        dict =  @{@"content":self.inputTextView.text,@"resTo":self.resId} ;
    }
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:dict requesId:@"CIRCLEREPLY" messId:[NSString stringWithFormat:@"%@",self.cirecleId] success:^(id obj)
                         {
                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                             {
                                [SVProgressHUD showErrorWithStatus:@"评论发表成功！"];
                                 
                                 if ([self.fatherController respondsToSelector:@selector(freshList)])
                                 {
                                     [self.fatherController performSelector:@selector(freshList) withObject:nil];
                                     [self.navigationController popViewControllerAnimated:YES];
                                 }
                             }
                             else if([[obj objectForKey:@"rc"]intValue] == -1)
                             {
                                 [SVProgressHUD showErrorWithStatus:@"圈子id不存在！"];
                             }
                             else
                             {
                                 [SVProgressHUD showErrorWithStatus:@"评论发表失败！"];
                             }
                             
                             
                         } failure:nil];

    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"数据加载中..."
                                   completeBlock:nil];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([StaticTools isEmptyString:textView.text])
    {
        self.messLabel.hidden = NO;
    }
    else
    {
        self.messLabel.hidden = YES;
    }
}
#pragma mark-
#pragma mark--按钮点击事件
- (IBAction)buttonClickHandle:(id)sender
{
    [self.view endEditing:YES];
    
    if ([StaticTools isEmptyString:self.inputTextView.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入评论内容！"];
        return;
    }
    
    [self circleReply];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
