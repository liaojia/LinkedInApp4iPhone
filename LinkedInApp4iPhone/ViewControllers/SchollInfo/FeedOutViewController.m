//
//  FeedOutViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-19.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "FeedOutViewController.h"

@interface FeedOutViewController ()

@end

@implementation FeedOutViewController

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
    if (self.pageType==0)
    {
        self.content = @"          首都师范大学教育基金会捐赠途径\n首都师范大学教育基金会欢迎所有热心教育的有识之士以不同方式支持首都师范大学和教育事业，包括设立永久性基金，或以现金、支票、汇票、股票、证券、债券、图书、资料、设备、房产、遗产、财产等形式捐赠。\n          捐款可以指定项目和用途，具体捐赠途径如下：\n(一)银行转账  \n人民币捐赠账户\n    开户行帐号： 0200 0076 0904 7652 806 \n    开户名称： 首都师范大学教育基金会 \n    开户地址： 中国工商银行北京紫竹院支行 \n(二)邮局汇款 \n    地 址：北京市海淀区西三环北路105号首都师范大学（学校办公室）\n    邮政编码：100048 \n    收款人：首都师范大学教育基金会 (请在附言中注明捐赠用途) \n    (请您务必在转账和汇款附言中写清您的通讯地址、联系电话等信息，以便于我们和您联系。)\n          首都师范大学教育基金会联系方式\n    地址：北京市海淀区西三环北路105号首都师范大学学校办公室-教育基金会\n    邮政编码：100048 \n    联系电话：010-68902418 68902611 \n    传真：86-10-68902418\n    E-mail：cnuxyh@126.com\n    网址：http://xyh.cnu.edu.cn";
        
        self.navigationItem.title = @"捐款方式";
    }
    else if(self.pageType==1)
    {
        self.navigationItem.title = @"首都师范大学";
        NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"scollInfo" ofType:@"txt" ] encoding:NSUTF8StringEncoding  error:nil];
         self.content =str;
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
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageType==0)
    {
        if (indexPath.row==1)
        {
            return 160;
        }
        return  [StaticTools getLabelHeight:self.content defautWidth:300 defautHeight:4800 fontSize:16]+10;
    }
    else if(self.pageType==1)
    {
        if (indexPath.row==0)
        {
            return 160;
        }
        return  [StaticTools getLabelHeight:self.content defautWidth:300 defautHeight:4800 fontSize:16]+10;;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if ((self.pageType==0&&indexPath.row==1)||
        (self.pageType==1&&indexPath.row==0))
    {
        UIImageView *imgView = [[UIImageView alloc]init];;
        imgView.frame = CGRectMake(5, 5,290, 150);
        imgView.image = [UIImage imageNamed:self.pageType==0? @"img_feedback":@"img_school_logo.jpg"];
        [cell.contentView addSubview:imgView];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    else if((self.pageType==0&&indexPath.row==0)||
            (self.pageType==1&&indexPath.row==1))
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, [StaticTools getLabelHeight:self.content defautWidth:300 defautHeight:4800 fontSize:16])];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        label.numberOfLines = 0;
        label.lineBreakMode = UILineBreakModeWordWrap;
        [cell.contentView addSubview:label];
        label.text = self.content;
    }
   
    return cell;
}

@end
