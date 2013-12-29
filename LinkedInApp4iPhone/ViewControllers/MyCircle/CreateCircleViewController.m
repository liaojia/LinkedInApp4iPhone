//
//  CreateCircleViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-29.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "CreateCircleViewController.h"

@interface CreateCircleViewController ()

@end

@implementation CreateCircleViewController

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
    self.navigationItem.title = @"新建圈子";
    
    self.nameTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.nameTextView.layer.borderWidth = 0.5;
    self.nameTextView.layer.cornerRadius = 6;
    
    self.desTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.desTextView.layer.borderWidth = 0.5;
    self.desTextView.layer.cornerRadius = 6;
    
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
/**
 *	@brief	创建圈子
 *
 *	@param
 */
-(void)createCircle
{
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"name":self.nameTextView.text,@"desc":self.desTextView.text} requesId:@"CREATECIRCLE" messId:nil success:^(id obj)
                                         {
                                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                                             {
                                                  [SVProgressHUD showErrorWithStatus:@"创建成功！"];
                                                 [self.navigationController popViewControllerAnimated:YES];
                                                 if ([self.fatherController respondsToSelector:@selector(refreshMyCreateCricle)])
                                                 {
                                                     [self.fatherController performSelector:@selector(refreshMyCreateCricle) withObject:nil];
                                                 }
                                             }
                                         
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后再试！"];
                                             }
                                             
                                             
                                         } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"数据加载中..."
                                   completeBlock:nil];
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView==self.nameTextView)
    {
        if ([StaticTools isEmptyString:textView.text])
        {
            self.nameLabel.hidden = NO;
        }
        else
        {
            self.nameLabel.hidden = YES;
        }
    }
    else if(textView == self.desTextView)
    {
        if ([StaticTools isEmptyString:textView.text])
        {
            self.desLabel.hidden = NO;
        }
        else
        {
            self.desLabel.hidden = YES;
        }
    }
}

- (IBAction)buttonClickHandle:(id)sender
{
    [self.view endEditing:YES];
    [self createCircle];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
