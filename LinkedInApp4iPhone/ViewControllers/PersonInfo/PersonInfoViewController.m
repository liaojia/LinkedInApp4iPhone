//
//  PersonInfoViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "AppDelegate.h"
#import "PersonInfoCell.h"
#import "CommendListViewController.h"
#import "PersonCell.h"
#import "PersonHeadView.h"
#import "ProfileModel.h"
#import "PersonInfoEditViewController.h"
#import "PersonalCardViewController.h"

#define Tag_DeletePersonInfo_Alert 500

@interface PersonInfoViewController ()

@end

@implementation PersonInfoViewController
@synthesize model = _model;
@synthesize timeLimeArray = _timeLimeArray;

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
    self.listTableView.backgroundColor = [UIColor clearColor];
    self.listTableView.backgroundView = nil;
    
    self.timeLimeArray = [[NSMutableArray alloc] init];
    self.myNoticeArray = [[NSMutableArray alloc] init];
    self.noticeMeArray = [[NSMutableArray alloc] init];
    
    [self refreshData];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}
- (void)viewDidUnload
{
    [self setListTableView:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--按钮点击事件
- (void)buttonClickHandle:(id)sender
{
    
    UIButton *button  = (UIButton*)sender;
    
    if (button.tag>=200&&button.tag<300) //增加履历节点
    {
        PersonInfoEditViewController *personInfoEditController = [[PersonInfoEditViewController alloc]   initWithNibName:@"PersonInfoEditViewController" bundle:[NSBundle mainBundle]];
        personInfoEditController.infoModel = self.timeLimeArray[button.tag-200-1];
        personInfoEditController.pageType = 1;
        personInfoEditController.fatherController = self;
        [self.navigationController pushViewController:personInfoEditController animated:YES];
        return;
        
    }
    else if(button.tag>=300&&button.tag<400) //修改履历节点
    {
        
        PersonInfoEditViewController *personInfoEditController = [[PersonInfoEditViewController alloc]   initWithNibName:@"PersonInfoEditViewController" bundle:[NSBundle mainBundle]];
        personInfoEditController.infoModel = self.timeLimeArray[button.tag-300-1];
        personInfoEditController.pageType = 0;
         personInfoEditController.fatherController = self;
        [self.navigationController pushViewController:personInfoEditController animated:YES];
        return;
    }
    else if(button.tag>=400&&button.tag<500) //删除履历节点
    {
        [StaticTools showAlertWithTag:Tag_DeletePersonInfo_Alert
                                title:nil
                              message:@"您确定要删除该条记录吗？"
                            AlertType:CAlertTypeCacel SuperView:self];
        
        selectDeleteIndex = button.tag-400-1;
        return;
        
    }
    
    if (button.tag>=20000)
    {
        PersonInfoViewController *perosnInforController = [[PersonInfoViewController alloc]initWithNibName:@"PersonInfoViewController" bundle:[NSBundle mainBundle]];
        perosnInforController.pageType = 1;
        int tag = button.tag - 40000;
        if (tag > 19999) {
            // 和 section = 3 等价，即关注我的人
            perosnInforController.personId = ((ProfileModel*)[self.noticeMeArray objectAtIndex:tag-20000]).mId;
            
            
        }else{
            // 和 section = 2 等价，即我关注的人
            perosnInforController.personId = ((ProfileModel*)[self.myNoticeArray objectAtIndex:tag]).mId;
           
        }
        
        AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [appdelegate.rootNavigationController pushViewController:perosnInforController animated:YES];
        return;
        
    }
    switch (button.tag)
    {
        case 102: //我的关注列表类型改变
        {
            myNoticeListType = myNoticeListType == 0?1:0;
            [button setImage:[UIImage imageNamed:myNoticeListType == 0?@"img_card_list_two":@"img_card_list_one"] forState:UIControlStateNormal];
            [self.listTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
            
        }
            break;
        case 103: //关注我的列表类型改变
        {
            NoticeMeListType = NoticeMeListType == 0?1:0;
            [button setImage:[UIImage imageNamed:NoticeMeListType == 0?@"img_card_list_two":@"img_card_list_one"] forState:UIControlStateNormal];
            [self.listTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
            
        default:
            break;
    }
}

-(IBAction)cancelAction:(id)sender
{
    int tag = ((UIButton*)sender).tag - 40000;
    if (tag > 19999) {
        // 和 section = 3 等价，即关注我的人, 加关注
        [self addNoticeWithId:((ProfileModel*)[self.noticeMeArray objectAtIndex:tag-20000]).mId];
        
    }else{
        // 和 section = 2 等价，即我关注的人，取消关注
        [self cancelNoticeWithId:((ProfileModel*)[self.myNoticeArray objectAtIndex:tag]).mId];
    }
}

-(IBAction)recommendAction:(id)sender
{
    int index = ((UIButton*)sender).tag - 1000;
    ProfileModel *model = [self.timeLimeArray objectAtIndex:index];
    [self getSuggestPepoleListWithId:model.mId];
    
}

#pragma mark-
#pragma mark--UIAlertVewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == Tag_DeletePersonInfo_Alert)
    {
        if (buttonIndex !=alertView.cancelButtonIndex)
        {
            [self deletePersonInFoWithIndex:selectDeleteIndex];
        }
    }
}

#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.pageType == 0?4:2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0)
    {
        return 1;
    }else if(section == 1){

        return [self.timeLimeArray count] + 1;
    }
    else if(section == 2||section == 3)
    {
        int type = section ==2?myNoticeListType:NoticeMeListType;
        int count = section ==2?[self.myNoticeArray count ]:[self.noticeMeArray count];
        
        if (type == 0)
        {
            return count+1;
        }
        else
        {
            if (count%3==0)
            {
                return count/3+1;
            }
            else
            {
                return count/3+2;
            }
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 130;
    }
    else if(indexPath.section == 1)
    {
        
        return indexPath.row == 0?44:140;
    }
    if (indexPath.section == 2||indexPath.section==3)
    {
        if (indexPath.row == 0)
        {
           return 44;
        }
        
        if ((myNoticeListType == 1&&indexPath.section == 2)
            ||(NoticeMeListType == 1&&indexPath.section == 3))
        {
            return 130;
        }
        return 100;
    }
    return 130;
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
    // cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    if( indexPath.row == 0&&indexPath.section!=0) //title
    {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        NSString *titleStr;
        if (indexPath.section == 1)
        {
            titleStr = @"个人履历";
        }
        else if(indexPath.section == 2)
        {
            titleStr = @"个人关注";
        }
        else if(indexPath.section == 3)
        {
            titleStr = @"关注我的人";
        }
        titleLabel.text =  titleStr;
        [cell.contentView addSubview:titleLabel];
        
        if (indexPath.section==2||indexPath.section == 3)
        {
            UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            typeBtn.frame = CGRectMake(260, 5, 35, 35);
            typeBtn.tag = 100+indexPath.section;
            [typeBtn setImage:[UIImage imageNamed:@"img_card_list_two"] forState:UIControlStateNormal];
            [typeBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:typeBtn];
          

        }
    }
    else if (indexPath.section == 0) //个人资料
    {
        
        //头像图片
        UIImageView *headImgView  = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 80, 120)];
        headImgView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:headImgView];
        
        //姓名
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 200, 30)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:18];
        nameLabel.textColor = RGBACOLOR(0, 140, 207, 1);
        nameLabel.text = self.model.mName;
        [cell.contentView addSubview:nameLabel];
        
        //学校名称
        UILabel *schoolLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 40, 200, 50)];
        schoolLabel.backgroundColor = [UIColor clearColor];
        schoolLabel.numberOfLines = 2;
        schoolLabel.lineBreakMode = UILineBreakModeWordWrap;
        schoolLabel.font = [UIFont boldSystemFontOfSize:16];
        schoolLabel.text = self.model.mDept;
        [cell.contentView addSubview:schoolLabel];
        
        //专业名称
        UILabel *specialityLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 80, 200, 50)];
        specialityLabel.backgroundColor = [UIColor clearColor];
        specialityLabel.numberOfLines = 2;
        specialityLabel.lineBreakMode = UILineBreakModeWordWrap;
        specialityLabel.font = [UIFont boldSystemFontOfSize:16];
        specialityLabel.text = self.model.mMajor;
        [cell.contentView addSubview:specialityLabel];
    }
    else if (indexPath.section == 1&&indexPath.row!=0) //个人履历
    {

        PersonInfoCell *personInfoCell = [[[NSBundle mainBundle]loadNibNamed:@"PersonInfoCell" owner:nil options:nil] objectAtIndex:0];
        [personInfoCell initWithMode:[self.timeLimeArray objectAtIndex:indexPath.row-1]];
//        personInfoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [personInfoCell.recommendButton addTarget:self action:@selector(recommendAction:) forControlEvents:UIControlEventTouchUpInside];
        [personInfoCell.recommendButton setTag:(999+indexPath.row)];
        if (![self.personId isEqualToString:@"me"]) {
            [personInfoCell.recommendButton setHidden:YES];
        }else{
            [personInfoCell.recommendButton setHidden:NO];
        }
        
        personInfoCell.addBtn.tag = 200+indexPath.row;
        [personInfoCell.addBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
        personInfoCell.changeBtn.tag = 300+indexPath.row;
        [personInfoCell.changeBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
        personInfoCell.deleteBtn.tag = 400+indexPath.row;
        [personInfoCell.deleteBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];

        personInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return personInfoCell;
    }
    else if(indexPath.section == 2|| indexPath.section == 3) //个人关注||//关注我的人
    {
        int type = indexPath.section ==2?myNoticeListType:NoticeMeListType;
        int coutn = indexPath.section==2?[self.myNoticeArray count ]:[self.noticeMeArray count];
        
        if (type == 1)
        {
            
            int rowCount = coutn%3==0?coutn/3:coutn/3+1;
            int currentLineCount ;
            if (coutn%3 == 0)
            {
                currentLineCount = 3;
            }
            else
            {
                if (indexPath.row<rowCount)
                {
                    currentLineCount = 3;
                }
                else
                {
                    currentLineCount = coutn%3;
                }
            }
            
            for (int i=0; i<currentLineCount; i++)
            {
                PersonHeadView *personHeadView = [[PersonHeadView alloc]initWithFrame:CGRectMake(8*(i+1)+i*90, 5, 90, 120)];
                personHeadView.nameLabel.text = @"文彬";
                personHeadView.headImgBtn.tag = 201; //TODO: 暂时写死
                [personHeadView.headImgBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:personHeadView];
            }

            
        }
        else
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonCell" owner:nil options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            PersonCell *pesonCell = (PersonCell*)cell;
            NSArray *tmpArray = nil;
            if (indexPath.section == 2) {
                tmpArray = self.myNoticeArray;
            }else{
                tmpArray = self.noticeMeArray;
            }
            if (tmpArray || [tmpArray count] !=0) {
                ProfileModel *model = [tmpArray objectAtIndex:indexPath.row-1];
                pesonCell.selectionStyle = UITableViewCellSelectionStyleNone;
                pesonCell.nameLabel.text = model.mName;
                pesonCell.sexLabel.text = model.mGender;
                pesonCell.placeLabel.text = [NSString stringWithFormat:@"%@--%@", model.mProvince, model.mCity];
                pesonCell.headImg.tag =indexPath.section*20000+indexPath.row-1;
                [pesonCell.headImg addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
                [pesonCell.actionBtn setTitle:indexPath.section==2?@"取消关注":@"关注" forState:UIControlStateNormal];
                [pesonCell.actionBtn setTag:(indexPath.section*20000+indexPath.row-1) ];
                [pesonCell.actionBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
        
        
    }
  
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1&&self.pageType == 0) //进入相关推荐页面
    {
        CommendListViewController *commendListController = [[CommendListViewController alloc]initWithNibName:@"CommendListViewController" bundle:[NSBundle mainBundle]];
        AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [appdelegate.rootNavigationController pushViewController:commendListController animated:YES];


    }
    else if(indexPath.section == 0) //进入个人名片修改页面
    {
        PersonalCardViewController *personalCardController = [[PersonalCardViewController alloc]initWithNibName:@"PersonalCardViewController" bundle:[NSBundle mainBundle]];
        personalCardController.fatherContrller = self;
        [self.navigationController pushViewController:personalCardController animated:YES];
    }
}

#pragma mark-
#pragma mark--功能函数
- (void)refreshData
{
    if (self.pageType == 0) {
        self.personId = @"me";
        [self getProfileWithId:@"me"];
        [self getTimeLimeWithId:@"me"];
        [self getMyNoticeList];
        [self getNoticeMeList];
    }else{
        if (self.personId) {
            [self getProfileWithId:self.personId];
            [self getTimeLimeWithId:self.personId];
        }
        
    }
    

    // 查看个人履历
    AFHTTPRequestOperation *operation2 = [[Transfer sharedTransfer] TransferWithRequestDic:nil
         requesId:@"TIMELINE_LIST"
           prompt:@"prompt"
        replaceId:@"me"
          success:^(id obj) {
              
              if ([[obj objectForKey:@"rc"]intValue] == 1) {
                  NSArray *list = [obj objectForKey:@"list"];
//                  [self.timeLimeArray removeAllObjects];
                  for (id obj2 in list) {
                      ProfileModel *model = [[ProfileModel alloc] init];
                      [model setMId:[obj2 objectForKey:@"id"]];
                      [model setMTitle:[obj2 objectForKey:@"mTitle"]];
                      [model setMCity:[obj2 objectForKey:@"city"]];
                      [model setMDesc:[obj2 objectForKey:@"desc"]];
                      [model setMEtime:[obj2 objectForKey:@"etime"]];
                      [model setMStime:[obj2 objectForKey:@"stime"]];
                      [model setMProvince:[obj2 objectForKey:@"province"]];
                      [model setMOrg:[obj2 objectForKey:@"org"]];
                      [self.timeLimeArray addObject:model];
                  }
                  [self.listTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
              }
             
          }
          failure:^(NSString *errMsg) {
              
          }];
    
}

/**
 *	@brief	刷新个人简历  增加履历节点成功后由增加页面调用
 */
- (void)refreshTimeLine
{
    [self.timeLimeArray removeAllObjects];
    [self getTimeLimeWithId:@"me"];
}

/**
 *	@brief	查看个人履历
 */
-(void)getTimeLimeWithId:(NSString*)personId
{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:nil
      requesId:@"TIMELINE_LIST"
        prompt:@"prompt"
     replaceId:personId
       success:^(id obj) {
           
           if ([[obj objectForKey:@"rc"]intValue] == 1) {
               NSArray *list = [obj objectForKey:@"list"];
               for (id obj2 in list) {
                   ProfileModel *model = [[ProfileModel alloc] init];
                   [model setMTitle:[obj2 objectForKey:@"title"]];
                   [model setMCity:[obj2 objectForKey:@"city"]];
                   [model setMDesc:[obj2 objectForKey:@"desc"]];
                   [model setMEtime:[obj2 objectForKey:@"etime"]];
                   [model setMStime:[obj2 objectForKey:@"stime"]];
                   [model setMProvince:[obj2 objectForKey:@"province"]];
                   [model setMOrg:[obj2 objectForKey:@"org"]];
                   [model setMId:[obj2 objectForKey:@"id"]];
                   [self.timeLimeArray addObject:model];
               }
               [self.listTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
           }
           
       }
       failure:^(NSString *errMsg) {
           
       }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在获取数据..." completeBlock:^(NSArray *operations) {
        
        
    }];
}
/**
 *	@brief	根据选中履历推荐好友
 *
 *	@param 	nodeId 	结点Id
 */
-(void)getSuggestPepoleListWithId:(NSString *)nodeId
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: @"1",@"page", @"5", @"num", nil];
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:dic requesId:@"SUGGESTPEOPLE_LIST" messId:nodeId success:^(id obj)
         {
             NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
             if ([[obj objectForKey:@"rc"]intValue] == 1)
             {
                 NSArray *list = [obj objectForKey:@"list"];
                 for (id obj2 in list) {
                     ProfileModel *model = [[ProfileModel alloc] init];
                     [model setMCity:[obj2 objectForKey:@"city"]];
                     [model setMDesc:[obj2 objectForKey:@"desc"]];
                     [model setMEtime:[obj2 objectForKey:@"etime"]];
                     [model setMStime:[obj2 objectForKey:@"stime"]];
                     [model setMProvince:[obj2 objectForKey:@"province"]];
                     [model setMOrg:[obj2 objectForKey:@"org"]];
                     [model setMName:[obj2 objectForKey:@"name"]];
                     [model setMGender:[obj2 objectForKey:@"gender"]];
                     [model setMId:[obj2 objectForKey:@"id"]];
                     [tmpArray addObject:model];
                 }
                 CommendListViewController *vc = [[CommendListViewController alloc]initWithNibName:@"CommendListViewController" bundle:[NSBundle mainBundle]];
                 vc.mArray = tmpArray;
                 [self.navigationController pushViewController:vc animated:YES];
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
 *	@brief	获取个人信息
 */
-(void)getProfileWithId:(NSString*)personId
{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:nil
      requesId:@"PROFILE_BASIC"
        prompt:@"prompt"
     replaceId:personId
       success:^(id obj) {
           
           if ([[obj objectForKey:@"rc"]intValue] == 1) {
               NSDictionary *basicDic = [obj objectForKey:@"basic"];
               _model = [[ProfileModel alloc] init];
               [_model setMAdYear:[basicDic objectForKey:@"adYear"]];
               NSNumberFormatter *fomatter = [[NSNumberFormatter alloc] init];
               [_model setMGender:[fomatter stringFromNumber:[basicDic objectForKey:@"gender"]]];
               [_model setMMajor:[basicDic objectForKey:@"major"]];
               [_model setMName:[basicDic objectForKey:@"name"]];
               [_model setMDept:[basicDic objectForKey:@"dept"]];
               
           }
           [self.listTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
           
       }
       failure:^(NSString *errMsg) {
           
       }];
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"数据加载中..."
                                   completeBlock:nil];
}
/**
 *	@brief 我关注的人列表
 */
-(void)getMyNoticeList

{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: @"1",@"page", @"5", @"num", nil];
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:dic requesId:@"MYATTENTIONS_LIST" messId:nil success:^(id obj)
         {
             if ([[obj objectForKey:@"rc"]intValue] == 1)
             {
                 [self.myNoticeArray removeAllObjects];
                 NSArray *list = [obj objectForKey:@"list"];
                 for (id obj2 in list) {
                     ProfileModel *model = [[ProfileModel alloc] init];
                     [model setMCity:[obj2 objectForKey:@"city"]];
                     [model setMDesc:[obj2 objectForKey:@"desc"]];
                     [model setMEtime:[obj2 objectForKey:@"etime"]];
                     [model setMStime:[obj2 objectForKey:@"stime"]];
                     [model setMProvince:[obj2 objectForKey:@"province"]];
                     [model setMOrg:[obj2 objectForKey:@"org"]];
                     [model setMName:[obj2 objectForKey:@"name"]];
                     [model setMGender:[obj2 objectForKey:@"gender"]];
                     [model setMId:[obj2 objectForKey:@"id"]];
                     [self.myNoticeArray addObject:model];
                 }
                 [self.listTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
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
 *	@brief 关注我的人列表
 */
-(void)getNoticeMeList

{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: @"1",@"page", @"5", @"num", nil];
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:dic requesId:@"FANS_LIST" messId:nil success:^(id obj)
         {
             if ([[obj objectForKey:@"rc"]intValue] == 1)
             {
                 NSArray *list = [obj objectForKey:@"list"];
                 for (id obj2 in list) {
                     ProfileModel *model = [[ProfileModel alloc] init];
                     [model setMCity:[obj2 objectForKey:@"city"]];
                     [model setMDesc:[obj2 objectForKey:@"desc"]];
                     [model setMEtime:[obj2 objectForKey:@"etime"]];
                     [model setMStime:[obj2 objectForKey:@"stime"]];
                     [model setMProvince:[obj2 objectForKey:@"province"]];
                     [model setMOrg:[obj2 objectForKey:@"org"]];
                     [model setMName:[obj2 objectForKey:@"name"]];
                     [model setMGender:[obj2 objectForKey:@"gender"]];
                     [model setMId:[obj2 objectForKey:@"id"]];
                     [self.noticeMeArray addObject:model];
                 }
                [self.listTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
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
 *	@brief	加关注
 *
 *	@param 	personId 	人员ID（必填项）
 */
-(void)addNoticeWithId:(NSString *)personId

{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:nil requesId:@"ADD_ATTENTION" messId:personId success:^(id obj)
         {
             if ([[obj objectForKey:@"rc"]intValue] == 1)
             {
                 [self getMyNoticeList];
             }
             else if([[obj objectForKey:@"rc"]intValue] == -1)
             {
                 [SVProgressHUD showErrorWithStatus:@"id不存在！"];
             }
             else if([[obj objectForKey:@"rc"]intValue] == -2){
                 [SVProgressHUD showErrorWithStatus:@"已经关注过此人！"];
             }
             else if([[obj objectForKey:@"rc"]intValue] == -3){
                 [SVProgressHUD showErrorWithStatus:@"关注对象非法！"];
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
 *	@brief	取消关注
 *
 *	@param 	personId 	人员ID（必填项）
 */
-(void)cancelNoticeWithId:(NSString *)personId

{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:nil requesId:@"CANCELATTENTION" messId:personId success:^(id obj)
         {
             if ([[obj objectForKey:@"rc"]intValue] == 1)
             {
                 [self getMyNoticeList];
                 
             }
             else if([[obj objectForKey:@"rc"]intValue] == -1)
             {
                 [SVProgressHUD showErrorWithStatus:@"id不存在！"];
             }
             else if([[obj objectForKey:@"rc"]intValue] == -2){
                 [SVProgressHUD showErrorWithStatus:@"没有关注过此人！"];
             }
             else if([[obj objectForKey:@"rc"]intValue] == -3){
                 [SVProgressHUD showErrorWithStatus:@"关注对象非法！"];
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
 *	@brief	删除个人履历节点信息
 *
 *	@param 	num 表示第几条数据
 */
- (void)deletePersonInFoWithIndex:(int)num
{
     ProfileModel *model = self.timeLimeArray[num];
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"id":model.mId} requesId:@"TIMELINE_NODE_DELETE" messId:nil success:^(id obj)
     {
         if ([[obj objectForKey:@"rc"]intValue] == 1)
         {
             
             [SVProgressHUD showErrorWithStatus:@"履历删除成功！"];
             [self.timeLimeArray removeObjectAtIndex:num];
             [self.listTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
         }
         else if([[obj objectForKey:@"rc"]intValue] == -1)
         {
             [SVProgressHUD showErrorWithStatus:@"id不存在！"];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"履历删除失败！"];
         }
         
         
     } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"数据加载中..."
                                   completeBlock:nil];

}
@end
