//
//  PersonInfoEditViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-19.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "PersonInfoEditViewController.h"

#define Tag_PickerCancel_Action 200
#define Tag_PickerOk_Aciton  201

@interface PersonInfoEditViewController ()

@end

@implementation PersonInfoEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        keyArray = @[@"身份",@"描述",@"组织",@"省份",@"城市",@"开始时间",@"结束时间"];
        
        
   
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.pageType == 0)
    {
        self.navigationItem.title = @"个人履历修改";
    }
    else if(self.pageType == 1)
    {
        self.navigationItem.title = @"个人履历增加";
    }
    
    self.listTableView.backgroundColor = [UIColor clearColor];
    self.listTableView.backgroundView = nil;
    
    if (self.pageType == 1)
    {
        //清除除id外的数据
        NSString *idStr = self.infoModel.mId;
        self.infoModel = [[ProfileModel alloc]init];
        self.infoModel.mId = idStr;
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(updatePersonInfo)];
    self.navigationItem.rightBarButtonItem = item;
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
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font  = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = keyArray[indexPath.row];
    [cell.contentView addSubview:titleLabel];

    UITextField *txtField = [[UITextField alloc] initWithFrame:CGRectMake(90, 5, 200, 30)];
    [cell.contentView addSubview:txtField];
    txtField.borderStyle = UITextBorderStyleLine;
    txtField.delegate = self;
    if (indexPath.row == 0)
    {
        txtField.text = self.infoModel.mTitle;
    }
    else if(indexPath.row == 1)
    {
        txtField.text = self.infoModel.mDesc;
    }
    else if(indexPath.row == 2)
    {
        txtField.text = self.infoModel.mOrg;
    }
    else if(indexPath.row == 3)
    {
        txtField.text = self.infoModel.mPlace;
    }
    else if(indexPath.row == 4)
    {
        txtField.text = self.infoModel.mCity;
    }
    else if(indexPath.row == 5)
    {
        txtField.text = self.infoModel.mStime;
    }
    else if(indexPath.row == 6)
    {
        txtField.text = self.infoModel.mEtime;
    }

    txtField.tag = indexPath.row+100;
    return cell;
}


#pragma mark-
#pragma mark--UITextfieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  //  self.listTableView.contentOffset = CGPointMake(0, 0);

    switch (textField.tag)
    {
        case 100:
        {
            self.infoModel.mTitle = textField.text;
        }
            break;
        case 101:
        {
            self.infoModel.mDesc = textField.text;
        }
            break;
        case 102:
        {
            self.infoModel.mOrg = textField.text;
        }
            break;
        case 103:
        {
            self.infoModel.mProvince = textField.text;
        }
            break;
        case 104:
        {
            self.infoModel.mCity = textField.text;
        }
            break;
            
            
        default:
            break;
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textfiled = textField;
    if (textField.tag == 105||textField.tag == 106)
    {
        [self hideKeyBoad];
        self.dataPicker.hidden = NO;
        self.toolBar.hidden = NO;
        return NO;
    }
    else if(textField.tag == 103||textField.tag == 104)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.listTableView.contentOffset = CGPointMake(0, 100);
        }];
        
    }
    self.dataPicker.hidden = YES;
    self.toolBar.hidden  = YES;
    return YES;
}
#pragma mark-
#pragma mark--按钮点击事件
- (IBAction)buttonClickerHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case Tag_PickerCancel_Action: //时间选择取消
        {
             
            self.dataPicker.hidden = YES;
            self.toolBar.hidden = YES;
        }
            break;
        case Tag_PickerOk_Aciton: //时间选择确认
        {
            self.dataPicker.hidden = YES;
            self.toolBar.hidden = YES;
            
            NSString *timeStr = [StaticTools getDateStrWithDate:self.dataPicker.date withCutStr:@"-" hasTime:NO];
            textfiled.text = timeStr;
            if (textfiled.tag == 105)
            {
                self.infoModel.mStime = timeStr;
            }
            else
            {
                self.infoModel.mEtime  = timeStr;
            }
          
        }
            
        default:
            break;
    }
}

#pragma mark-
#pragma mark--UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  
    [self hideKeyBoad];
}
#pragma mark-
#pragma mark--功能函数

/**
 *	@brief	更新个人履历节点 ||新增履历节点
 */
- (void)updatePersonInfo
{
    NSMutableArray *infoMtbDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [infoMtbDict setValue:self.infoModel.mTitle forKey:@"title"];
    [infoMtbDict setValue:self.infoModel.mDesc forKey:@"desc"];
    [infoMtbDict setValue:self.infoModel.mOrg forKey:@"org"];
    [infoMtbDict setValue:self.infoModel.mProvince forKey:@"province"];
    [infoMtbDict setValue:self.infoModel.mCity forKey:@"city"];
    [infoMtbDict setValue:self.infoModel.mStime forKey:@"stime"];
    [infoMtbDict setValue:self.infoModel.mEtime forKey:@"etime"];
    [infoMtbDict setValue:self.infoModel.mImgUrl forKey:@"pic"];
    
    if (self.pageType == 0)
    {
         [infoMtbDict setValue:self.infoModel.mId forKey:@"id"];
    }
    else if(self.pageType == 1)
    {
         [infoMtbDict setValue:self.infoModel.mId forKey:@"afterID"];
    }
   
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:infoMtbDict requesId:self.pageType == 0? @"TIMELINE_NODE_UPDATE":@"TIMELINE_NODE_CREATE" messId:nil success:^(id obj)
         {
             if ([[obj objectForKey:@"rc"]intValue] == 1)
             {
                 if (self.pageType == 0)
                 {
                     [SVProgressHUD showErrorWithStatus:@"履历更新成功！"];
                 }
                 else
                 {
                     [SVProgressHUD showErrorWithStatus:@"履历添加更新成功！"];
                 }
                 
                 
             }
             else if([[obj objectForKey:@"rc"]intValue] == -1)
             {
                 [SVProgressHUD showErrorWithStatus:@"id不存在"];
             }
             else
             {
                 if (self.pageType == 0)
                 {
                      [SVProgressHUD showErrorWithStatus:@"履历更新失败！"];
                 }
                 else
                 {
                      [SVProgressHUD showErrorWithStatus:@"履历添加失败！"];
                 }
                
             }
             
             
         } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"正在提交..."
                                   completeBlock:nil];
}
- (void)hideKeyBoad
{
    for (int i=0; i<keyArray.count; i++)
    {
        UITableViewCell *cell = [self.listTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UITextField  *txtfield = (UITextField*)[cell.contentView viewWithTag:100+i ];
        [txtfield resignFirstResponder];
    }
    self.listTableView.contentOffset = CGPointMake(0 , 0);
}
@end
