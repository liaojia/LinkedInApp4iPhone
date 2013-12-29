//
//  AddRegisterInfoViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-27.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "AddRegisterInfoViewController.h"
#import "StudentInfoCell.h"
#import "WorkersCell.h"
#import "SingleSelectCell.h"
#import "GTMBase64.h"

@interface AddRegisterInfoViewController ()

@end

@implementation AddRegisterInfoViewController

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
     self.navigationItem.title = @"完善注册信息";
    
    cerType = 1;
    selectYear = 2000;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(280, 5, 50, 30);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    rightBtn.tag = 1405;
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_find_stu_n"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_find_stu_s"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];

    
    self.departments = [NSMutableArray arrayWithCapacity:0];
    self.companys = [NSMutableArray arrayWithCapacity:0];
    
    [StaticTools setExtraCellLineHidden:self.listTableView];
    
    imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
    
    [self getDepartMentList];
    
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
#pragma mark--功能函数
/**
 *  显示院系选择
 */
- (void)showDepartmentSelect
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    for (NSDictionary *dict in self.departments)
    {
        [actionSheet addButtonWithTitle:dict[@"display"]];
    }
    actionSheet.tag = 1004;
    [actionSheet showInView:self.view];

}

/**
 *  显示专业选择
 */
- (void)showMajorSelect
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:Nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    
    NSArray *list  = self.departments[[self.selectDepartment[@"INDEX"] intValue]][@"list"];
    for (NSDictionary *dict in list)
    {
        [actionSheet addButtonWithTitle:dict[@"display"]];
    }
    actionSheet.tag = 1005;
    [actionSheet showInView:self.view];
    
}

/**
 *  显示一级组织选择
 */
- (void)showFistCompanySelect
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    for (NSDictionary *dict in self.companys)
    {
        [actionSheet addButtonWithTitle:dict[@"display"]];
    }
    actionSheet.tag = 1006;
    [actionSheet showInView:self.view];
}

/**
 *  显示二级组织选择
 */
- (void)showSecCompanySelect
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    
     NSArray *list  = self.companys[[self.selectFistCompany[@"INDEX"] intValue]][@"list"];
    for (NSDictionary *dict in list)
    {
        [actionSheet addButtonWithTitle:dict[@"display"]];
    }
    actionSheet.tag = 1007;
    [actionSheet showInView:self.view];
}
/**
 *  显示入学年份选择
 */
- (void)showStartYearSelect
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    
    NSString *current = [StaticTools getDateStrWithDate:[NSDate date] withCutStr:@"-" hasTime:NO];
    int currentYear = [[current substringToIndex:4] intValue];
    for(int i= 1900;i<=currentYear;i++)
    {
        [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%d年",i]];
    }
    actionSheet.tag = 1008;
    [actionSheet showInView:self.view];
}

- (BOOL)checkInputValue
{
    NSString *errStr  = nil;
    if ([StaticTools isEmptyString:self.name])
    {
        errStr = @"请填写姓名";
    }
    else  if ([StaticTools isEmptyString:self.classNum]&&cerType==1)
    {
        errStr = @"请填写班级";
    }
    else  if ([StaticTools isEmptyString:self.workerNum]&&cerType==0)
    {
        errStr = @"请填写职工编号";
    }
    else  if ([StaticTools isEmptyString:self.phonenum])
    {
        errStr = @"请填写手机号";
    }
    else  if ([StaticTools isEmptyString:self.email])
    {
        errStr = @"请填写邮箱";
    }
    else  if ([StaticTools isEmptyString:self.qqNum])
    {
        errStr = @"请填写qq号码";
    }
    
    if (errStr!=nil)
    {
        [SVProgressHUD showErrorWithStatus:errStr];
        return NO;
    }
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark-
#pragma mark--发送http请求
/**
 *  获取院系列表
 */
- (void)getDepartMentList
{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:nil requesId:@"GETDEPARTMENTLIST" messId:nil success:^(id obj)
                                         {
                                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                                             {
                                                 NSArray *listArray = obj[@"list"];
                                                 
                                                 [self.departments addObjectsFromArray:listArray];
                                                
                                                  self.selectDepartment = [NSMutableDictionary dictionaryWithDictionary:self.departments[0]];
                                                 [self.selectDepartment setValue:[NSNumber numberWithInt:0] forKey:@"INDEX"];
                                                 
                                                  self.selectMajor =[NSMutableDictionary dictionaryWithDictionary: self.departments[[self.selectDepartment[@"INDEX"] intValue]][@"list"][0]];
                                                 [self.listTableView reloadData];
                                                 
                                            }
                                            
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"院系信息加载失败"];
                                             }
                                             
                                             
                                         } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"加载中..."
                                   completeBlock:nil];
}

/**
 *  获取组织列表
 */
- (void)getCompacyList
{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:nil requesId:@"GETCOMPANYLIST" messId:nil success:^(id obj)
                                         {
                                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                                             {
                                                 NSArray *listArray = obj[@"list"];
                                                 
                                                 [self.companys addObjectsFromArray:listArray];
                                                 
                                                
                                                 self.selectFistCompany = [NSMutableDictionary dictionaryWithDictionary:self.departments[0]];
                                                 [self.selectFistCompany setValue:[NSNumber numberWithInt:0] forKey:@"INDEX"];
                                                 
                                                 self.selectSecCompaye =[NSMutableDictionary dictionaryWithDictionary: self.companys[[self.selectFistCompany[@"INDEX"] intValue]][@"list"][0]];
                                                 
                                                 [self.listTableView reloadData];
                                             }
                                             
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"组织信息加载失败"];
                                             }
                                             
                                             
                                         } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"加载中..."
                                   completeBlock:nil];
}

/**
 *  提交个人信息
 */
- (void)commitInfo
{
    [self.view endEditing:YES];
    
    if (![self checkInputValue])
    {
        return;
    }
//     UIImageView *headImgView = (UIImageView*)[[self.listTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] viewWithTag:200];
    NSDictionary *dict = Nil;
    if (cerType==0)
    {
        selectImg = [UIImage imageWithImage:selectImg scaledToSize:CGSizeMake(100 , 100)];
        dict = @{@"name":self.name,@"gender":(sigleCell.segControl.selectedSegmentIndex==0?@"1":@"0"),@"type":[NSString stringWithFormat:@"%d",2],@"org1Id":self.selectFistCompany[@"id"],@"org2Id":self.selectSecCompaye[@"id"],@"empNo":self.workerNum,@"mobile":self.phonenum,@"email":self.email,@"qq":self.qqNum,@"pic":selectImg==nil?@"":[GTMBase64 stringByEncodingData: UIImagePNGRepresentation(selectImg) ]};
    }
    else
    {
     
        selectImg = [UIImage imageWithImage:selectImg scaledToSize:CGSizeMake(100 , 100)];
        dict = @{@"name":self.name,@"gender":(sigleCell.segControl.selectedSegmentIndex==0?@"1":@"0"),@"type":[NSString stringWithFormat:@"%d",1],@"deptId":self.selectDepartment[@"id"],@"majorId":[NSString stringWithFormat:@"%@",self.selectMajor[@"id"]],@"clazz":self.classNum,@"adYear":[NSString stringWithFormat:@"%d",selectYear],@"mobile":self.phonenum,@"email":self.email,@"qq":self.qqNum,@"pic":selectImg==nil?@"":[GTMBase64 stringByEncodingData: UIImagePNGRepresentation(selectImg) ]};
        
    }
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:dict requesId:@"ADDREGISTERINFO" messId:nil success:^(id obj)
                                         {
                                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                                             {
                                                [SVProgressHUD showErrorWithStatus:@"信息提交成功，正在等待审核"];
                                             }
                                             else if ([[obj objectForKey:@"rc"]intValue] == -2)
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"已提交过个人信息"];
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"信息提交失败"];
                                             }
                                             
                                             
                                         } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"加载中..."
                                   completeBlock:nil];
}


#pragma mark-
#pragma mark--按钮点击事件
- (void)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case 1000:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentModalViewController:imagePicker animated:YES];
            }
        }
            break;
        case 1003: //身份类型选择
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:nil
                                          delegate:self
                                          cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:@"学生校友", @"教工校友",nil];
            actionSheet.tag = button.tag;
            [actionSheet showInView:self.view];
        }
            break;
        case 1400: //院系选择
        {
            
            [self showDepartmentSelect];
        }
            break;
        case 1401: //专业选择
        {
            [self showMajorSelect];
        }
            break;
        case 1402: //一级单位选择
        {
            [self showFistCompanySelect];
        }
            break;
        case 1403: //二级单位选择
        {
            [self showSecCompanySelect];
        }
            break;
        case 1404: //入学年份选择
        {
            [self showStartYearSelect];
        }
            break;
        case 1405: //完成
        {
            [self commitInfo];
        }
            break;

            
        default:
            break;
    }
}

#pragma mark-
#pragma mark--UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag)
    {
            
        case 1003: //身份类型选择
        {
            if (buttonIndex==0) //学生校友
            {
                cerType = 1;
                if (self.departments.count==0)
                {
                    [self getDepartMentList];
                }
            }
            else //教工校友
            {
                cerType = 0;
                if (self.companys.count==0)
                {
                    [self getCompacyList];
                }
            }
            [self.listTableView reloadData];
        }
            break;
        case 1004: //院系选择
        {
            self.selectDepartment = [NSMutableDictionary dictionaryWithDictionary:self.departments[buttonIndex]] ;
            [self.selectDepartment setValue:[NSNumber numberWithInt:buttonIndex] forKey:@"INDEX"];
            
            self.selectMajor = [NSMutableDictionary dictionaryWithDictionary: self.departments[[self.selectDepartment[@"INDEX"] intValue]][@"list"][0]];
            [self.listTableView reloadData];
        }
            break;
        case 1005: //专业选择
        {
          
            self.selectMajor = [NSMutableDictionary dictionaryWithDictionary:self.departments[[self.selectDepartment[@"INDEX"] intValue]][@"list"][buttonIndex]];
            [self.listTableView reloadData];
        }
            break;
        case 1006: //一级单位选择
        {
            self.selectFistCompany = [NSMutableDictionary dictionaryWithDictionary:self.companys[buttonIndex]] ;
            [self.selectFistCompany setValue:[NSNumber numberWithInt:buttonIndex] forKey:@"INDEX"];
            
            self.selectSecCompaye = [NSMutableDictionary dictionaryWithDictionary: self.companys[[self.selectFistCompany[@"INDEX"] intValue]][@"list"][0]];
            [self.listTableView reloadData];

        }
            break;
        case 1007: //二级单位选择
        {
            self.selectSecCompaye = [NSMutableDictionary dictionaryWithDictionary:self.companys[[self.selectFistCompany[@"INDEX"] intValue]][@"list"][buttonIndex]];
            [self.listTableView reloadData];
        }
            break;
        case 1008:
        {
            selectYear = 1900+buttonIndex;
            [self.listTableView reloadData];
        }
            
        default:
            break;
    }
}

#pragma mark-
#pragma mark--TextViewDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    int tag = textField.tag;
    if (tag==110||tag==111)
    {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.listTableView.contentOffset = CGPointMake(0, 250-50);
        }];
    }
    else
    {
        UITableViewCell *cell = [self.listTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag%100  inSection:tag/100-1]];
        CGRect rectUpTable = [self.listTableView convertRect:textField.frame fromView:cell.contentView];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.listTableView.contentOffset = CGPointMake(0, rectUpTable.origin.y-130);
        }];
    }
  

}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 101) //姓名
    {
        self.name = textField.text;
    }
    else if (textField.tag == 105) //手机号
    {
        self.phonenum = textField.text;
    }
    else if (textField.tag == 106) //邮箱
    {
        self.email = textField.text;
    }
    else if (textField.tag == 107) //qq
    {
        self.qqNum = textField.text;
    }
    else if (textField.tag == 110) //班级
    {
        self.classNum = textField.text;
    }
    else if (textField.tag == 111) //员工编号
    {
        self.workerNum = textField.text;
    }
}
#pragma mark-
#pragma mark - UIImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *pickerSelectedImage = (UIImage*)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
	CGFloat width = pickerSelectedImage.size.width;			// 压缩图片到80*100
	CGFloat height = pickerSelectedImage.size.height;
	if (width > 80.0 || height > 100.0){
		if (width > height) {
			height = height * 80.0 / width;
			width = 80.0;
		}else {
			width = width * 100.0 / height;
			height = 100.0;
		}
	}
    else if (width < 80.0 && height < 100.0)
    {
        if(width < height)
        {
            width = width * 100.0 / height;
            height = 100.0;
        }
        else
        {
            height = height * 80.0 / width;
            width = 80.0;
        }
    }
	UIImage *imgFixed = [UIImage imageWithImage:pickerSelectedImage scaledToSize:CGSizeMake(width, height)];
	
    UIImageView *headImgView = (UIImageView*)[[self.listTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] viewWithTag:200];
    headImgView.image = imgFixed;
    selectImg = imgFixed;
	[self dismissModalViewControllerAnimated:YES];
	
}
#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 80;
    }
    else if(indexPath.row==2) //姓名
    {
        return 50;
    }
    else if(indexPath.row==4)
    {
        return cerType==0?120:150;
    }
    else
    {
        return 44;
    }
    return 0;
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
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (indexPath.row==0)
    {
        UIImageView *headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 70, 70)];
        headImgView.backgroundColor = [UIColor grayColor];
        headImgView.layer.borderColor = [UIColor grayColor].CGColor;
        headImgView.layer.borderWidth = 2;
        headImgView.tag = 200;
      
        if (selectImg == nil)
        {
            headImgView.image = [UIImage imageNamed:@"img_weibo_item_pic_loading"];
        }
        else
        {
            headImgView.image = selectImg;
        }
        
        [cell.contentView addSubview:headImgView];
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.tag = 1000;
        selectBtn.frame = CGRectMake(129, 35, 130, 30);
        [selectBtn setTitle:@"从相册选择头像" forState:UIControlStateNormal];
        selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_group_n.png"] forState:UIControlStateNormal];
        [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:selectBtn];
        
        return cell;
    }
    else if(indexPath.row==2)
    {
        sigleCell = [[[NSBundle mainBundle] loadNibNamed:@"SingleSelectCell" owner:nil options:nil] objectAtIndex:0];
        sigleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return sigleCell;
    }
    else if(indexPath.row==3)
    {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 80, 30)];
        titleLabel.text = @"身份类型";
        [cell.contentView addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:15];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_group_n.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(129, 10, 171, 26);
        [button setTitle:cerType==0?@"教工校友":@"学生校友" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = 1003;
        [button addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:button];
        
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_down_arrows.png"]];
        img.frame = CGRectMake(276, 16, 15, 10);
        [cell.contentView addSubview:img];
    }
    else if(indexPath.row==4)
    {
        if (cerType==0)
        {
            WorkersCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"WorkersCell" owner:nil options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            cell.firstCompayeBtn.tag = 1402;
            [cell.firstCompayeBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
            [cell.firstCompayeBtn setTitle:self.selectFistCompany[@"display"] forState:UIControlStateNormal];
            
            cell.secCompanyBtn.tag = 1403;
            [cell.secCompanyBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
            [cell.secCompanyBtn setTitle:self.selectSecCompaye[@"display"] forState:UIControlStateNormal];
            
            cell.workersNumTxtField.tag = 111;
            cell.workersNumTxtField.delegate = self;
            cell.workersNumTxtField.text = self.workerNum;
            return cell;
        }
        else
        {
            StudentInfoCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"StudentInfoCell" owner:nil options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.departmentBtn.tag = 1400;
            [cell.departmentBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
             [cell.departmentBtn setTitle:self.selectDepartment[@"display"] forState:UIControlStateNormal];
            
            cell.majorBtn.tag = 1401;
            [cell.majorBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
            [cell.majorBtn setTitle:self.selectMajor[@"display"] forState:UIControlStateNormal];
            
            cell.startYearBtn.tag = 1404;
            [cell.startYearBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
            [cell.startYearBtn setTitle:[NSString stringWithFormat:@"%d年",selectYear] forState:UIControlStateNormal];
            
            cell.classTxtField.tag = 110;
            cell.classTxtField.delegate = self;
            cell.classTxtField.text = self.classNum;
            
            return cell;
        }
    }
    else
    {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, 80, 30)];
        [cell.contentView addSubview:titleLabel];
        titleLabel.textAlignment = UITextAlignmentRight;
        titleLabel.font = [UIFont systemFontOfSize:15];
        
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_group_n.png"]];
        img.frame = CGRectMake(129, 10, 170, 26);
        [cell.contentView addSubview:img];
        
        UITextField *inputTxtField = [[UITextField alloc]initWithFrame:CGRectMake(130, 8, 170, 30)];
        [cell.contentView addSubview:inputTxtField];
        inputTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        inputTxtField.delegate = self;
        inputTxtField.tag = 100+indexPath.row;
        inputTxtField.font = [UIFont systemFontOfSize:15];
        
        if (indexPath.row==1)
        {
            titleLabel.text = @"姓名";
            inputTxtField.placeholder = @"请输入姓名";
            inputTxtField.text = self.name;
        }
        else if(indexPath.row == 5)
        {
            titleLabel.text = @"手机号";
            inputTxtField.placeholder = @"请输手机号";
            inputTxtField.text = self.phonenum;
            inputTxtField.keyboardType = UIKeyboardTypeNumberPad;

        }
        else if(indexPath.row == 6)
        {
            titleLabel.text = @"邮箱";
            inputTxtField.placeholder = @"请输入邮箱";
            inputTxtField.text = self.email;
            inputTxtField.keyboardType = UIKeyboardTypeEmailAddress;
        }
        else if(indexPath.row == 7)
        {
            titleLabel.text = @"QQ号";
            inputTxtField.placeholder = @"请输入QQ号";
            inputTxtField.text = self.qqNum;
            inputTxtField.keyboardType = UIKeyboardTypeNumberPad;
            
        }
        
        return cell;
    }
    return cell;
}

@end
