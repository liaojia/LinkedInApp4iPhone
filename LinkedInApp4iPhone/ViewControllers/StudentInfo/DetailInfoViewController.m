//
//  DetailInfoViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-17.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "DetailInfoViewController.h"

@interface DetailInfoViewController ()

@end

@implementation DetailInfoViewController

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
    self.navigationItem.title = @"新闻详情";
    self.listTableView.separatorColor = [UIColor clearColor];
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getDetailWithID:self.listId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--功能函数
/**
 *	@brief	获取图片在cell里展示的最佳frame  图片宽大于高时：长度最大为tableview的宽度 高度为其对应缩放
 图片高大于宽时：最大高度为480 宽度为其对应缩放
 *
 *	@param 	image 	图片数据
 *
 *	@return
 */
- (CGRect)getRectWithImage:(UIImage*)image

{
    CGRect rect = CGRectMake(320, 150, 10, 10);
    float maxHeight;
    if (image.size.width>image.size.height)
    {
        maxHeight = 300;
    }
    else
    {
        maxHeight = 480;
    }
    
    CGRect frame = CGRectMake(0, 0, 300, maxHeight);
    //图片尺寸比view小 按原图尺寸显示
    if (image.size.width<frame.size.width&&image.size.height<maxHeight)
    {
        rect = CGRectMake((frame.size.width-image.size.width)/2, 5,
                          image.size.width, image.size.height);
    }
    else
    {
        CGRect showRect = CGRectMake(0, 0, frame.size.width ,maxHeight);
        float rate = image.size.width/image.size.height;
        
        float rateBox = showRect.size.width/(showRect.size.height);
        if(rate > rateBox){
            rect.size.width = frame.size.width;
            rect.size.height = frame.size.width/rate;
        }else{
            rect.size.height = showRect.size.height;
            rect.size.width = (showRect.size.height)*rate;
        }
        
        rect.origin.x= (frame.size.width-rect.size.width)/2;
        rect.origin.y = 5;
    }
    
    return rect;
}

#pragma mark-
#pragma mark--发送htp请求
/**
 *	@brief	获取详细信息
 *
 *	@param 	idStr 	id
 */
- (void)getDetailWithID:(NSString*)idStr

{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"id":self.typeId} requesId:@"CUSTOMEMEDIODETAILTINFO" messId:idStr success:^(id obj)
                             {
                                 if ([[obj objectForKey:@"rc"]intValue] == 1)
                                 {
                                     
                                     self.resultDict = obj;
                                     [self.listTableView reloadData];
                                     self.imageArray = [NSMutableArray arrayWithCapacity:0];
                                    
                                     NSArray *pics = self.resultDict[@"pics"];
                                     for (int i=0; i<pics.count; i++)
                                     {
                                         [self.imageArray addObject:@""];
                                         NSDictionary *dict = pics[i];
                                         NSLog(@"开始下载图片 %@",dict[@"url"]);
                                        /////////////?
                                        AFImageRequestOperation* operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dict[@"url"]]] success:^(UIImage *image) {
                                             
                                              NSLog(@"下载图片完成 %@",dict[@"url"]);
                                             [self.imageArray replaceObjectAtIndex:i withObject:image];
                                             [self.listTableView reloadData];
                                        
                                         }];
                                         
                                         [operation start];
                                     }
                                     
                                 }
                                 else if([[obj objectForKey:@"rc"]intValue] == -1)
                                 {
                                     [SVProgressHUD showErrorWithStatus:@"id不存在！"];
                                 }
                                 else
                                 {
                                     [SVProgressHUD showErrorWithStatus:@"详情信息加载失败！"];
                                 }
                                 
                                 
                             } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"加载中..."
                                   completeBlock:nil];
    
}

#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *pics = self.resultDict[@"pics"];
    return pics.count+2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *pics = self.resultDict[@"pics"];
    
    if (indexPath.row == 0)
    {
        return [StaticTools getLabelHeight:self.resultDict[@"title"] defautWidth:tableView.frame.size.width-10 defautHeight:480 fontSize:17]+40;
    }
    else if(indexPath.row == pics.count+1) //最后一行 正文
    {
        
        return [StaticTools getLabelHeight:self.resultDict[@"content"] defautWidth:tableView.frame.size.width-10 defautHeight:480 fontSize:16]+10;
    }
    
    
    //图片下载完成时返回图片的适应大小  图片未下载完完返回10
    if ([self.imageArray[indexPath.row-1] isKindOfClass:[UIImage class]])
    {
        return [self getRectWithImage:self.imageArray[indexPath.row-1]].size.height+10;
    }
    else
    {
        return 10;
    }

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
     NSArray *pics = self.resultDict[@"pics"];
    
    if (indexPath.row==0)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, tableView.frame.size.width-10, [StaticTools getLabelHeight:self.resultDict[@"title"] defautWidth:tableView.frame.size.width-10 defautHeight:480 fontSize:17])];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = self.resultDict[@"title"];
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        [cell.contentView addSubview:titleLabel];
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, titleLabel.frame.origin.y+titleLabel.frame.size.height+5, 200, 30)];
        timeLabel.font = [UIFont systemFontOfSize:15];
        timeLabel.text = self.resultDict[@"time"];
        timeLabel.textAlignment = UITextAlignmentRight;
        timeLabel.textColor = RGBCOLOR(29, 60, 229);
        [cell.contentView addSubview:timeLabel];
    }
    else if(indexPath.row == pics.count+1)
    {
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, tableView.frame.size.width-10, [StaticTools getLabelHeight:self.resultDict[@"content"] defautWidth:tableView.frame.size.width-10 defautHeight:480 fontSize:16])];
        contentLabel.font = [UIFont systemFontOfSize:16];
        contentLabel.numberOfLines = 0;
        contentLabel.lineBreakMode = UILineBreakModeWordWrap;
        contentLabel.text = self.resultDict[@"content"];
        [cell.contentView addSubview:contentLabel];
    }
    else
    {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, tableView.frame.size.width-20, 180)];
        if ([self.imageArray[indexPath.row-1] isKindOfClass:[UIImage class]])
        {
           
            imgView.image = self.imageArray[indexPath.row-1];
            imgView.frame = [self getRectWithImage:self.imageArray[indexPath.row-1]];
        }
        [cell.contentView addSubview:imgView];
    }
    
    return cell;
}


@end
