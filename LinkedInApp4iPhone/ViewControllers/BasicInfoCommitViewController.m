//
//  BasicInfoCommitViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-22.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "BasicInfoCommitViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface BasicInfoCommitViewController ()

@end

@implementation BasicInfoCommitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        keyArray  = @[@"姓名",@"性别",@"学号",@"身份证号",@"专业",@"入学时间",@"毕业时间"];
        self.infoModel = [[ProfileModel alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"个人基本信息提交";
    self.navigationController.navigationBarHidden = NO;
    self.listTableView.backgroundColor = [UIColor clearColor];
    self.listTableView.backgroundView = nil;
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    headView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 300, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor redColor];
    titleLabel.text = @"   学号和身份证号选填一项即可";
    [headView addSubview:titleLabel];
    self.listTableView.tableHeaderView = headView;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(commitPersonBasicInfo)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidUnload
{
    [self setListTableView:nil];
    [self setDatePicker:nil];
    [self setToolBar:nil];
    [super viewDidUnload];
}

#pragma mark-
#pragma mark--按钮点击事件
- (IBAction)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender ;
    switch (button.tag) {
       
        case 300: //时间选择取消
        {
            self.datePicker.hidden = YES;
            self.toolBar.hidden = YES;
        }
            break;
        case 301: //时间选择确定
        {
            self.datePicker.hidden = YES;
            self.toolBar.hidden = YES;
            NSString *timeStr = [StaticTools getDateStrWithDate:self.datePicker.date withCutStr:@"-" hasTime:NO];
            selectTextView.text = timeStr;
            if (selectTextView.tag == 105) //入学时间
            {
                self.infoModel.mAdYear = timeStr;
            }
            else if(selectTextView.tag == 106) //毕业时间
            {
                self.infoModel.mGradYear = timeStr;
            }
        
        }
            break;
        default:
            break;
    }
}

- (IBAction)segmentValueChange:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl*)sender;
    if (seg.selectedSegmentIndex == 0)
    {
        self.infoModel.mGender = @"1";
    }
    else
    {
        self.infoModel.mGender = @"0";
    }
}
#pragma mark-
#pragma mark--功能函数
- (void)hideKeyBoad
{

    for (int j=0; j<keyArray.count;j++)
    {
        UITableViewCell *cell = [self.listTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]];
        for (UIView *view in cell.contentView.subviews)
        {
            if ([view isKindOfClass:[UITextView class]])
            {
                UITextView *textView = (UITextView*)view;
                [textView resignFirstResponder];
            }
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        
        self.listTableView.contentOffset = CGPointMake(0, 0);
    }];
    
    
}

/**
 *	@brief	检查页面输入
 *
 *	@return	
 */
- (BOOL)iSvalueInputCheckOk

{
    NSString *errStr = nil;
    if ([StaticTools isEmptyString:self.infoModel.mName])
    {
        errStr = @"请输入姓名！";
    }
    else if([StaticTools isEmptyString:self.infoModel.mMajor])
    {
        errStr = @"请输入专业名称";
    }
    else if([StaticTools isEmptyString:self.infoModel.mAdYear])
    {
        errStr = @"请输入入学时间";
    }
    else if([StaticTools isEmptyString:self.infoModel.mGradYear])
    {
        errStr = @"请输入毕业时间";
    }

    else if([StaticTools isEmptyString:self.infoModel.mStuNo]
            &&[StaticTools isEmptyString:self.infoModel.mIdCardNo])
    {
        errStr = @"学号和身份证号必须选填一项";
    }
    else if(![StaticTools isPUreInt:self.infoModel.mStuNo]&&![StaticTools isEmptyString:self.infoModel.mStuNo])
    {
        errStr = @"学号必须为一个正确的数字";
    }
    else if(![StaticTools isPUreInt:self.infoModel.mIdCardNo]&&![StaticTools isEmptyString:self.infoModel.mIdCardNo])
    {
        errStr = @"身份证号必须为一个正确的数字";
    }

    if (errStr !=nil)
    {
        [SVProgressHUD showErrorWithStatus:errStr];
        return NO;
    }
   return YES;

}

/**
 *	@brief	提交个人信息-后台匹配
 */
- (void)commitPersonBasicInfo
{
    [self hideKeyBoad];
    if (![self iSvalueInputCheckOk])
    {
        return;
    }
    
    int gender = [self.infoModel.mGender isEqualToString:@"男"]?1:0;
    NSMutableDictionary *requectMtbDict = [[NSMutableDictionary alloc]
                        initWithDictionary:@{@"name":self.infoModel.mName,
                                             @"gender": [NSNumber numberWithInt:gender],
                                             @"major":self.infoModel.mMajor,
                                             @"adYear":[self.infoModel.mAdYear substringToIndex:4],
                                           @"gradYear":[self.infoModel.mGradYear substringToIndex:4]}];

    if (self.infoModel.mStuNo !=nil&&![StaticTools isEmptyString:self.infoModel.mStuNo])
    {
        [requectMtbDict setObject:self.infoModel.mStuNo forKey:@"stuNo"];

    }
    if (self.infoModel.mIdCardNo !=nil&&![StaticTools isEmptyString:self.infoModel.mIdCardNo])
    {
        [requectMtbDict setObject:self.infoModel.mIdCardNo forKey:@"idCardNo"];
    }
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:requectMtbDict requesId:@"COMMITPERSONINFO" messId:nil success:^(id obj)
         {
             
             if ([[obj objectForKey:@"rc"]intValue] == 1)
             {
                 [SVProgressHUD showErrorWithStatus:@"信息提交成功！"];
                 
             }
             else if([[obj objectForKey:@"rc"]intValue] == 2)
             {
                 [SVProgressHUD showErrorWithStatus:@"提交成功，信息正在审核中"];
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"信息提交失败！"];
             }
             
             
         } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"数据加载中..."
                                   completeBlock:nil];
    
}

#pragma mark-
#pragma mark--TextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    selectTextView = textView;
    //入学时间||毕业时间||生日
    if (textView.tag == 105||textView.tag == 106)
    {
        [self hideKeyBoad];
        self.toolBar.hidden = NO;
        self.datePicker.hidden = NO;
        return NO;
    }
    int tag = textView.tag;
    if (tag == 100)
    {
        return YES;
    }
    UITableViewCell *cell = [self.listTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textView.tag%100  inSection:tag/100-1]];
    CGRect rectUpTable = [self.listTableView convertRect:textView.frame fromView:cell.contentView];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.listTableView.contentOffset = CGPointMake(0, rectUpTable.origin.y-80);
    }];
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == 100)
    {
        self.infoModel.mName = textView.text;
    }else if(textView.tag == 102)
    {
        self.infoModel.mStuNo = textView.text;
    }else if(textView.tag == 103)
    {
        self.infoModel.mIdCardNo = textView.text;
    }
    else if(textView.tag == 104)
    {
        self.infoModel.mMajor = textView.text;
    }
}


#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return keyArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier =  @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    //标题文字
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = keyArray[indexPath.row];
    [cell.contentView addSubview:titleLabel];
    
    if (indexPath.row == 1)
    {
        UISegmentedControl *segControl = [[UISegmentedControl alloc]initWithFrame:CGRectMake(90, 5, 100, 30)];
        segControl.segmentedControlStyle = UISegmentedControlStyleBezeled;
        [segControl insertSegmentWithTitle:@"男" atIndex:0 animated:NO];
        [segControl insertSegmentWithTitle:@"女" atIndex:1 animated:NO];
        [segControl addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
        if ([self.infoModel.mGender isEqualToString:@"男"])
        {
            [segControl setSelectedSegmentIndex:0];
        }
        else
        {
            [segControl setSelectedSegmentIndex:1];
        }
        [cell.contentView addSubview:segControl];
    }
    else
    {
        UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(90, 5, 200, 30)];
        txtView.delegate = self;
        txtView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        txtView.font = [UIFont systemFontOfSize:16];
        txtView.layer.borderWidth = 1;
        txtView.tag = 100+indexPath.row;
        [cell.contentView addSubview:txtView];
        
      
        if (indexPath.row == 0)
        {
            txtView.text = self.infoModel.mName;
        }else if(indexPath.row == 2)
        {
            txtView.text = self.infoModel.mStuNo;
        }else if(indexPath.row == 3)
        {
            txtView.text = self.infoModel.mIdCardNo;
        }
        else if(indexPath.row == 4)
        {
            txtView.text = self.infoModel.mMajor;
        }
        else if(indexPath.row == 5)
        {
            txtView.text = self.infoModel.mAdYear;
        }
        else if(indexPath.row == 6)
        {
            txtView.text = self.infoModel.mGradYear;
        }
    }
    
    
    return cell;
}

#pragma mark-
#pragma mark--UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyBoad];
}
@end
