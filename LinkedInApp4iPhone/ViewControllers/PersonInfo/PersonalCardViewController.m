//
//  PersonalCardViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-20.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "PersonalCardViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface PersonalCardViewController ()

@end

@implementation PersonalCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        keyArray = @[@[@"姓名",@"性别",@"学校",@"专业",@"入学时间",@"毕业时间"],@[@"生日",@"籍贯",@"名族",@"简介",@"联系方式"]];
        
        self.infoModel = [[ProfileModel alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"个人信息修改";
    self.listTableView.backgroundColor = [UIColor clearColor];
    self.listTableView.backgroundView = nil;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(updatePersonalCard)];
    self.navigationItem.rightBarButtonItem = item;
    
    imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
    
    
    [self getPersonalCardInfoWithID:@"me"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setListTableView:nil];
    [self setDataPicker:nil];
    [self setToolBar:nil];
    [super viewDidUnload];
}

#pragma mark-
#pragma mark--按钮点击事件
- (IBAction)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender ;
    switch (button.tag) {
        case 102: //选择头像
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentModalViewController:imagePicker animated:YES];
            }
        }
            break;
        case 300: //时间选择取消
        {
            self.dataPicker.hidden = YES;
            self.toolBar.hidden = YES;
        }
            break;
        case 301: //时间选择确定
        {
            self.dataPicker.hidden = YES;
            self.toolBar.hidden = YES;
            NSString *timeStr = [StaticTools getDateStrWithDate:self.dataPicker.date withCutStr:@"-" hasTime:NO];
            selectTextView.text = timeStr;
            if (selectTextView.tag == 105) //入学时间
            {
                self.infoModel.mAdYear = timeStr;
            }
            else if(selectTextView.tag == 106) //毕业时间
            {
                self.infoModel.mGradYear = timeStr;
            }
            else if(selectTextView.tag == 200) //生日
            {
                self.infoModel.mBirthday = timeStr;
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
	
    UIImageView *headImgView = (UIImageView*)[[self.listTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] viewWithTag:101];
    headImgView.image = imgFixed;
    selectImg = imgFixed;
	[self dismissModalViewControllerAnimated:YES];
	
}

#pragma mark-
#pragma mark--TextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    selectTextView = textView;
    //入学时间||毕业时间||生日
    if (textView.tag == 105||textView.tag == 106|| textView.tag == 200)
    {
        [self hideKeyBoad];
        self.toolBar.hidden = NO;
        self.dataPicker.hidden = NO;
        return NO;
    }
    int tag = textView.tag;
    UITableViewCell *cell = [self.listTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textView.tag%100  inSection:tag/100-1]];
    CGRect rectUpTable = [self.listTableView convertRect:textView.frame fromView:cell.contentView];
   
    [UIView animateWithDuration:0.5 animations:^{
        
         self.listTableView.contentOffset = CGPointMake(0, rectUpTable.origin.y-80);
    }];
   
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == 101)
    {
        self.infoModel.mName = textView.text;
    }
    else if(textView.tag == 103)
    {
         self.infoModel.mSchool = textView.text;
    }
    else if(textView.tag == 104)
    {
        self.infoModel.mMajor = textView.text;
    }
    else if(textView.tag == 201)
    {
        self.infoModel.mBirthplace = textView.text;
    }
    else if(textView.tag == 202)
    {
        self.infoModel.mNation = textView.text;
    }
    else if(textView.tag == 203)
    {
        self.infoModel.mDesc = textView.text;
    }
    else if(textView.tag == 204)
    {
        self.infoModel.mTel = textView.text;
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
- (void)hideKeyBoad
{
    NSArray *arrayOne = keyArray[0];
    NSArray *arrayTwo = keyArray[1];
    for (int i=0;i<2; i++)
    {
        int num = i==0?arrayOne.count:arrayTwo.count;
        for (int j=0; j<num;j++)
        {
            UITableViewCell *cell = [self.listTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            for (UIView *view in cell.contentView.subviews)
            {
                if ([view isKindOfClass:[UITextView class]])
                {
                    UITextView *textView = (UITextView*)view;
                    [textView resignFirstResponder];
                }
            }
        }
    }
}
/**
 *	@brief	获取个人全部信息
 *
 *	@param 	idStr 	id号 查看自己的时传@“me”
 */
- (void)getPersonalCardInfoWithID:(NSString*)idStr
{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:nil requesId:@"PROFILE_ALL" messId:idStr success:^(id obj)
     {
        
         if ([[obj objectForKey:@"rc"]intValue] == 1)
         {
             NSDictionary *baseDict = obj[@"basic"];
             self.infoModel.mName = baseDict[@"name"];
             self.infoModel.mGender = baseDict[@"gender"];
             self.infoModel.mSchool = baseDict[@"colg"];
             self.infoModel.mMajor = baseDict[@"major"];
             self.infoModel.mAdYear = baseDict[@"adYear"];
             self.infoModel.mGradYear = baseDict[@"gradYear"];
             self.infoModel.mImgUrl = baseDict[@"pic"];
             
             NSDictionary *extDict = obj[@"ext"];
             self.infoModel.mBirthday = extDict[@"birthday"];
             self.infoModel.mBirthplace = extDict[@"birthplace"];
             self.infoModel.mDesc = extDict[@"desc"];
             self.infoModel.mNation = extDict[@"nation"];
             self.infoModel.mTel = extDict[@"tel"];
             
             [self.listTableView reloadData];
           
         }
         else if([[obj objectForKey:@"rc"]intValue] == -1)
         {
             [SVProgressHUD showErrorWithStatus:@"id不存在！"];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"加载失败！"];
         }
         
         
     } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"数据加载中..."
                                   completeBlock:nil];
}

/**
 *	@brief	更新个人名片信息
 */
- (void)updatePersonalCard
{
  
    [self hideKeyBoad];
    
    int gender = [self.infoModel.mGender isEqualToString:@"男"]?1:0;
    NSDictionary *requectDict = @{@"basic":@{@"name":self.infoModel.mName,
                                             @"gender": [NSNumber numberWithInt:gender],
                                             @"colg":self.infoModel.mSchool,
                                             @"major":self.infoModel.mMajor,
                                             @"adYear":self.infoModel.mAdYear,
                                             @"gradYear":self.infoModel.mGradYear,
                                             @"pic":@""},
                                  @"ext":@{@"birthday":self.infoModel.mBirthday,
                                           @"birthplace":self.infoModel.mBirthplace,
                                           @"desc":self.infoModel.mDesc,
                                           @"nation":self.infoModel.mNation,
                                           @"tel":self.infoModel.mTel,}};
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:requectDict requesId:@"PROFILE_UPDATE" messId:nil success:^(id obj)
         {
             
             if ([[obj objectForKey:@"rc"]intValue] == 1)
             {
                 [SVProgressHUD showErrorWithStatus:@"信息更新成功！"];
                
                 [self.fatherContrller performSelector:@selector(getProfileWithId:) withObject:@"me"];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"信息失败！"];
             }
             
             
         } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"数据加载中..."
                                   completeBlock:nil];
    
}
#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = keyArray[section];
    return section ==0? array.count+1:array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section==0?@"基本信息":@"扩展信息";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0&&indexPath.row == 0)
    {
        return 110;
    }
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
    
    if (indexPath.section == 0&&indexPath.row == 0) //头像
    {
        UIImageView *headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 100, 100)];
        headImgView.backgroundColor = [UIColor grayColor];
        headImgView.tag =  100+1;
        if (selectImg == nil)
        {
            [headImgView setImageWithURL:[NSURL URLWithString:self.infoModel.mImgUrl]];
        }
        else
        {
            headImgView.image = selectImg;
        }
        
        [cell.contentView addSubview:headImgView];
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        selectBtn.tag = 100+2;
        selectBtn.frame = CGRectMake(120, 50, 120, 40);
        [selectBtn setTitle:@"从相册选择头像" forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:selectBtn];
        
        
    }
    else
    {
        //标题文字
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        NSArray *array = keyArray[indexPath.section];
        titleLabel.text = indexPath.section ==0?array[indexPath.row-1]:array[indexPath.row];
        [cell.contentView addSubview:titleLabel];
        
        if (indexPath.section==0&&indexPath.row == 2)
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
            txtView.tag = (indexPath.section+1)*100+indexPath.row;
            [cell.contentView addSubview:txtView];
            
            if (indexPath.section == 0)
            {
               if (indexPath.row == 1)
                {
                    txtView.text = self.infoModel.mName;
                }
                else if(indexPath.row == 3)
                {
                    txtView.text = self.infoModel.mSchool;
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
            else if(indexPath.section == 1)
            {
                if (indexPath.row == 0)
                {
                    txtView.text = self.infoModel.mBirthday;
                }
                else if (indexPath.row == 1)
                {
                    txtView.text = self.infoModel.mBirthplace;
                }
                else if(indexPath.row == 2)
                {
                    txtView.text = self.infoModel.mNation;
                }
                else if(indexPath.row == 3)
                {
                    txtView.text = self.infoModel.mDesc;
                }
                else if(indexPath.row == 4)
                {
                    txtView.text = self.infoModel.mTel;
                }
            }
        }
        
    }
   
    
    return cell;
}

@end
