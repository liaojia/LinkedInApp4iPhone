//
//  PersonInfoEditViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-19.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "PersonInfoEditViewController.h"
#import "GTMBase64.h"
#import <QuartzCore/QuartzCore.h>

#define Tag_PickerCancel_Action 200
#define Tag_PickerOk_Aciton  201
#define Tag_SelectPic_Action 202

#define Tag_HeadImgView_View 300

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
    
    [self initTableView];
    
    imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
    
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
    titleLabel.font  = [UIFont systemFontOfSize:15];
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
        txtField.text = self.infoModel.mProvince;
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
    else if(textField.tag == 101||textField.tag == 102)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.listTableView.contentOffset = CGPointMake(0, 80);
        }];
        
    }
    else if(textField.tag == 103||textField.tag == 104)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.listTableView.contentOffset = CGPointMake(0, 150);
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
            break;
        case Tag_SelectPic_Action: //从相册选择图片
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentModalViewController:imagePicker animated:YES];
            }
        }
            break;
            
        default:
            break;
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
	
    UIImageView *headImgView = (UIImageView*)[self.listTableView.tableHeaderView viewWithTag:Tag_HeadImgView_View];
    headImgView.image = imgFixed;
	[self dismissModalViewControllerAnimated:YES];
	
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
 *	@brief	初始化tableview相关
 */
- (void)initTableView
{
    self.listTableView.backgroundColor = [UIColor clearColor];
    self.listTableView.backgroundView = nil;
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 80)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIImageView *headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 70, 70)];
    headImgView.backgroundColor = [UIColor lightGrayColor];
    headImgView.layer.borderWidth = 2;
    headImgView.layer.borderColor = [UIColor grayColor].CGColor;
    NSLog(@"self.infoModel.mImgUrl %@",self.infoModel.mImgUrl);
    [headImgView setImageWithURL:[NSURL URLWithString:self.infoModel.mImgUrl] placeholderImage:[UIImage imageNamed:@"img_weibo_item_pic_loading"]];
    headImgView.tag = Tag_HeadImgView_View;
    [headView addSubview:headImgView];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectBtn.frame = CGRectMake(120, 40, 140, 30);
    selectBtn.tag = Tag_SelectPic_Action;
    [selectBtn setTitle:@"从相册选择头像" forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(buttonClickerHandle:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:selectBtn];
    
    self.listTableView.tableHeaderView = headView;
}

/**
 *	@brief	更新个人履历节点 ||新增履历节点
 */
- (void)updatePersonInfo
{
    [self hideKeyBoad];
    NSString *errStr = nil;
    if ([StaticTools isEmptyString:self.infoModel.mTitle])
    {
        errStr = @"请输入身份信息";
    }
    else if ([StaticTools isEmptyString:self.infoModel.mDesc])
    {
        errStr = @"请输入描述信息";
    }
    else if ([StaticTools isEmptyString:self.infoModel.mOrg])
    {
        errStr = @"请输入组织信息";
    }
    else if ([StaticTools isEmptyString:self.infoModel.mProvince])
    {
        errStr = @"请输入省份信息";
    } else if ([StaticTools isEmptyString:self.infoModel.mCity])
    {
        errStr = @"请输入城市信息";
    }
    else if ([StaticTools isEmptyString:self.infoModel.mStime])
    {
        errStr = @"请输入开始时间";
    }
    else if ([StaticTools isEmptyString:self.infoModel.mEtime])
    {
        errStr = @"请输入结束时间";
    }
    if (errStr !=nil)
    {
        [SVProgressHUD showErrorWithStatus:errStr];
        return;
    }
    
    
    NSMutableDictionary *infoMtbDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [infoMtbDict setValue:self.infoModel.mTitle forKey:@"title"];
    [infoMtbDict setValue:self.infoModel.mDesc forKey:@"desc"];
    [infoMtbDict setValue:self.infoModel.mOrg forKey:@"org"];
    [infoMtbDict setValue:self.infoModel.mProvince forKey:@"province"];
    [infoMtbDict setValue:self.infoModel.mCity forKey:@"city"];
//    [infoMtbDict setValue:[self.infoModel.mStime substringToIndex:7] forKey:@"stime"];
//    [infoMtbDict setValue:[self.infoModel.mEtime substringToIndex:7] forKey:@"etime"];
    
    UIImageView *headImgView = (UIImageView*)[self.listTableView.tableHeaderView viewWithTag:Tag_HeadImgView_View];
    [infoMtbDict setValue:[GTMBase64 stringByEncodingData:UIImagePNGRepresentation(headImgView.image) ] forKey:@"pic"];
    

    
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
                     [self.navigationController popViewControllerAnimated:YES];
                     [self.fatherController performSelector:@selector(getTimeLimeWithId:) withObject:@"me"];
                 }
                 else
                 {
                     [SVProgressHUD showErrorWithStatus:@"履历添加成功！"];
                     [self.fatherController performSelector:@selector(refreshTimeLine) withObject:nil];
                     [self.navigationController popViewControllerAnimated:YES];
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
//    for (int i=0; i<keyArray.count; i++)
//    {
//        UITableViewCell *cell = [self.listTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//        UITextField  *txtfield = (UITextField*)[cell.contentView viewWithTag:100+i ];
//        [txtfield resignFirstResponder];
//    }
    [self.view endEditing:YES];
    self.listTableView.contentOffset = CGPointMake(0 , 0);
}
@end
