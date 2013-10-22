//
//  ProfileVC.m
//  zjtSinaWeiboClient
//
//  Created by jianting zhu on 12-2-25.
//  Copyright (c) 2012年 Dunbar Science & Technology. All rights reserved.
//

#import "ProfileVC.h"
#import "Status.h"
#import "User.h"
#import "HHNetDataCacheManager.h"
#import "ImageBrowser.h"
#import "GifView.h"
//#import "SHKActivityIndicator.h"
//#import "ZJTDetailStatusVC.h"
//#import "FollowerVC.h"
//#import "ZJTHelpler.h"

@interface ProfileVC ()

- (void)getImages;

@end

@implementation ProfileVC
@synthesize table;
@synthesize userID;
@synthesize statusCellNib;
@synthesize statuesArr;
@synthesize imageDictionary;
@synthesize browserView;
@synthesize headerView;
@synthesize headerVImageV;
@synthesize headerVNameLB;
@synthesize weiboCount;
@synthesize followerCount;
@synthesize followingCount;
@synthesize user;
@synthesize avatarImage;

-(void)dealloc
{
    self.avatarImage = nil;
    self.user = nil;
    self.imageDictionary = nil;
    self.statusCellNib = nil;
    self.statuesArr = nil;
    self.userID = nil;
    self.browserView = nil;
    self.table = nil;
    self.headerVImageV = nil;
    self.headerVNameLB = nil;
    self.weiboCount = nil;
    self.followerCount = nil;
    self.followingCount = nil;
    
    self.headerView = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //init data
        isFirstCell = YES;
        shouldLoad = NO;
        shouldLoadAvatar = NO;
        shouldShowIndicator = YES;
        defaultNotifCenter = [NSNotificationCenter defaultCenter];
        imageDictionary = [[NSMutableDictionary alloc] initWithCapacity:100];
        
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

-(UINib*)statusCellNib
{
    if (statusCellNib == nil) 
    {
        self.statusCellNib = [StatusCell nib];
    }
    return statusCellNib;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [table setTableHeaderView:headerView];
    
    self.tableView.contentInset = UIEdgeInsetsOriginal;
    
    //请求用户信息
    [self getUserInfoWithUserID:[self.userID intValue]]; //1918502663
    //请求时间轴数据
    [self getUserStatusUserID:self.userID sinceID:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
   
    
//    [[ZJTStatusBarAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
    
//    [defaultNotifCenter addObserver:self selector:@selector(didGetHomeLine:)    name:MMSinaGotUserStatus        object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAvatar:)  name:HHNetDataCacheNotification object:nil];
//
//    [defaultNotifCenter addObserver:self selector:@selector(mmRequestFailed:) name:MMSinaRequestFailed object:nil];
}

-(void)viewDidUnload
{
//    [defaultNotifCenter removeObserver:self name:MMSinaGotUserStatus        object:nil];
//    [defaultNotifCenter removeObserver:self name:HHNetDataCacheNotification object:nil];
////    [defaultNotifCenter removeObserver:self name:MMSinaGotUserInfo          object:nil];
//    [defaultNotifCenter removeObserver:self name:MMSinaRequestFailed object:nil];
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    if (shouldLoad) 
    {
        shouldLoad = NO;
//        [self getUserStatusUserID:userID sinceID:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark-
#pragma mark--发送请求

//获取某个用户最新发表的微博列表
-(void)getUserStatusUserID:(NSString *) uid sinceID:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature
{
    //https://api.weibo.com/2/statuses/user_timeline.json
    
   NSString  *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
    //self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:authToken,@"access_token",nil];
    [params setObject:uid forKey:@"uid"];
    NSLog(@"uid = %@",uid);
    if (sinceID >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%lld",sinceID];
        [params setObject:tempString forKey:@"since_id"];
    }
    if (maxID >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%lld",maxID];
        [params setObject:tempString forKey:@"max_id"];
    }
    if (count >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",count];
        [params setObject:tempString forKey:@"count"];
    }
    if (page >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",page];
        [params setObject:tempString forKey:@"page"];
    }
    if (baseApp >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",baseApp];
        [params setObject:tempString forKey:@"baseApp"];
    }
    if (feature >= 0) {
        NSString *tempString = [NSString stringWithFormat:@"%d",feature];
        [params setObject:tempString forKey:@"feature"];
    }
    
    NSString    *baseUrl =[NSString  stringWithFormat:@"%@/statuses/user_timeline.json",SINA_V2_DOMAIN];
    NSURL         *url = [self generateURL:baseUrl params:params];
    
    
 
     NSURL *hosturl = [[NSURL alloc] initWithString:SINA_V2_DOMAIN];
     _Block_H_ AFHTTPClient  *client = [[AFHTTPClient alloc] initWithBaseURL:hosturl];
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    client.parameterEncoding = AFJSONParameterEncoding;
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:url.path parameters:params];
    [request setTimeoutInterval:20];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
             {
                 
                 NSData *data = [NSJSONSerialization dataWithJSONObject:JSON
                                                                options:0
                                                                  error:nil];
                
                 NSLog(@"请求返回数据:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                 
                 NSArray *arr = [JSON objectForKey:@"statuses"];
                 
                 if (arr == nil || [arr isEqual:[NSNull null]])
                 {
                     return;
                 }
                 
                 NSMutableArray  *statuesArray = [[NSMutableArray alloc]initWithCapacity:0];
                 for (id item in arr) {
                     Status* sts = [Status statusWithJsonDictionary:item];
                     [statuesArray addObject:sts];
                 }
                 
                [self didGetHomeLine:statuesArray];
                 
                 [statuesArr release];
                 
                 
             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response,
                         NSError *error, id JSON)
             {
                 
                 
                [ client.operationQueue cancelAllOperations];
                 [client cancelAllHTTPOperationsWithMethod:@"POST" path:DEFAULTHOST];
                 
                 NSLog(@"请求失败--err:%@", [NSString stringWithFormat:@"%@",error]);
            
                 NSString *message = [error.userInfo objectForKey:@"NSLocalizedDescription"];
                 if (message)
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [alert show];
                 }
                 
                 
             }
             ];

  
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"加载中..."
                                   completeBlock:nil];
}

//获取任意一个用户的信息
-(void)getUserInfoWithUserID:(long long)uid
{
    //https://api.weibo.com/2/users/show.json
    
    NSString  *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
//    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,                                   @"access_token",
                                       [NSString stringWithFormat:@"%lld",uid],     @"uid",
                                       nil];
    NSString                *baseUrl =[NSString  stringWithFormat:@"%@/users/show.json",SINA_V2_DOMAIN];
    NSURL                   *url = [self generateURL:baseUrl params:params];
    
    
    NSURL *hosturl = [[NSURL alloc] initWithString:SINA_V2_DOMAIN];
    _Block_H_ AFHTTPClient  *client = [[AFHTTPClient alloc] initWithBaseURL:hosturl];
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    client.parameterEncoding = AFJSONParameterEncoding;
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:url.path parameters:params];
    [request setTimeoutInterval:20];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                     {
                         
                    
                         NSData *data = [NSJSONSerialization dataWithJSONObject:JSON
                                                                        options:0
                                                                          error:nil];
                         
                         NSLog(@"请求返回数据:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                         
                       self.user = [[User alloc]initWithJsonDictionary:JSON];
                         //获取头像图片

                         [[HHNetDataCacheManager getInstance] getDataWithURL:user.profileLargeImageUrl];
                         NSLog(@"follwcut %d frind %d",self.user.followersCount,self.user.friendsCount);
                         self.headerVNameLB.text = user.screenName;
                         self.weiboCount.text = [NSString stringWithFormat:@"%d",user.statusesCount];
                         self.followerCount.text = [NSString stringWithFormat:@"%d",user.followersCount];
                         self.followingCount.text = [NSString stringWithFormat:@"%d",user.friendsCount];
                         
                         if (![self.title isEqualToString:@"我的微博"]) {
                             self.title = user.screenName;
                         }
                         
                     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response,
                                 NSError *error, id JSON)
                     {
                         
                         
                         [ client.operationQueue cancelAllOperations];
                         [client cancelAllHTTPOperationsWithMethod:@"POST" path:DEFAULTHOST];
                         
                         NSLog(@"请求失败--err:%@", [NSString stringWithFormat:@"%@",error]);
                         
                         NSString *message = [error.userInfo objectForKey:@"NSLocalizedDescription"];
                         if (message)
                         {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                             [alert show];
                         }
                         
                         
                     }
                     ];

    
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"加载中..."
                                   completeBlock:nil];
    

}


- (NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
	if (params) {
		NSMutableArray* pairs = [NSMutableArray array];
		for (NSString* key in params.keyEnumerator) {
			NSString* value = [params objectForKey:key];
			NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                  NULL, /* allocator */
                                  (CFStringRef)value,
                                  NULL, /* charactersToLeaveUnescaped */
                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                  kCFStringEncodingUTF8);
            
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
			[escaped_value release];
		}
		
		NSString* query = [pairs componentsJoinedByString:@"&"];
		NSString* url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
		return [NSURL URLWithString:url];
	} else {
		return [NSURL URLWithString:baseURL];
	}
}

//
- (IBAction)gotoFollowedVC:(id)sender {
//    FollowerVC  *followerVC     = [[FollowerVC alloc]initWithNibName:@"FollowerVC" bundle:nil];
//    followerVC.title = [NSString stringWithFormat:@"%@的粉丝",user.screenName];
//    followerVC.user = user;
//    followerVC.hidesBottomBarWhenPushed = YES;
//    
//    [self.navigationController pushViewController:followerVC animated:YES];
//    [followerVC release];
}

- (IBAction)gotoFollowingVC:(id)sender 
{
    
//    FollowerVC *followingVC    = [[FollowerVC alloc] initWithNibName:@"FollowerVC" bundle:nil];
//    
//    followingVC.title = [NSString stringWithFormat:@"%@的关注",user.screenName];
//    followingVC.isFollowingViewController = YES;
//    followingVC.user = user;
//    followingVC.hidesBottomBarWhenPushed = YES;
//    
//    [self.navigationController pushViewController:followingVC animated:YES];
//    [followingVC release];
}

#pragma mark - Methods

//异步加载图片
-(void)getImages
{    
    //得到文字数据后，开始加载图片
    for(int i=0;i<[statuesArr count];i++)
    {
        Status * member=[statuesArr objectAtIndex:i];
        NSNumber *indexNumber = [NSNumber numberWithInt:i];
        
        //下载博文图片
        if (member.thumbnailPic && [member.thumbnailPic length] != 0)
        {
            [[HHNetDataCacheManager getInstance] getDataWithURL:member.thumbnailPic withIndex:i];
        }
        else
        {
            [imageDictionary setObject:[NSNull null] forKey:indexNumber];
        }
        
        //下载转发的图片
        if (member.retweetedStatus.thumbnailPic && [member.retweetedStatus.thumbnailPic length] != 0) 
        {
            [[HHNetDataCacheManager getInstance] getDataWithURL:member.retweetedStatus.thumbnailPic withIndex:i];
        }
        else
        {
            [imageDictionary setObject:[NSNull null] forKey:indexNumber];
        }
    }
}

//得到图片
-(void)getAvatar:(NSNotification*)sender
{
    NSDictionary * dic = sender.object;
    NSString * url          = [dic objectForKey:HHNetDataCacheURLKey];
    NSNumber *indexNumber   = [dic objectForKey:HHNetDataCacheIndex];
    NSInteger index = [indexNumber intValue];
    
    if([url isEqualToString:user.profileLargeImageUrl])
    {
        UIImage * image     = [UIImage imageWithData:[dic objectForKey:HHNetDataCacheData]];
        self.avatarImage = image;
        headerVImageV.image = image;
    }
    
    //当下载大图过程中，后退，又返回，如果此时收到大图的返回数据，会引起crash，在此做预防。
    if (indexNumber == nil) {
        NSLog(@"indexNumber = nil");
        return;
    }
    
    if (index >= [statuesArr count]) {
//        NSLog(@"statues arr error ,index = %d,count = %d",index,[statuesArr count]);
        return;
    }
    
    Status *sts = [statuesArr objectAtIndex:index];
    
    //得到的是博文图片
    if([url isEqualToString:sts.thumbnailPic])
    {
        [imageDictionary setObject:[dic objectForKey:HHNetDataCacheData] forKey:indexNumber];
    }
    
    //得到的是转发的图片
    if (sts.retweetedStatus && ![sts.retweetedStatus isEqual:[NSNull null]])
    {
        if ([url isEqualToString:sts.retweetedStatus.thumbnailPic])
        {
            [imageDictionary setObject:[dic objectForKey:HHNetDataCacheData] forKey:indexNumber];
        }
    }
    
    //reload table
    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:index inSection:0];
    NSArray     *arr        = [NSArray arrayWithObject:indexPath];
    [table reloadRowsAtIndexPaths:arr withRowAnimation:NO];
}

//-(void)didGetUserID:(NSNotification*)sender
//{
//    self.userID = sender.object;
//    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:USER_STORE_USER_ID];
//    [manager getUserInfoWithUserID:[userID longLongValue]];
//}



-(void)didGetHomeLine:(NSMutableArray*)state
{
    [self stopLoading];
    
    shouldLoadAvatar = YES;
    self.statuesArr = state;
    [table reloadData];
   // [[ZJTStatusBarAlertWindow getInstance] hide];
    
    [imageDictionary removeAllObjects];
    
    [self getImages];
}

-(void)mmRequestFailed:(id)sender
{
    [self stopLoading];
//    [[ZJTStatusBarAlertWindow getInstance] hide];
}

-(void)refresh
{
    [self getUserStatusUserID:self.userID sinceID:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
}

//计算text field 的高度。
-(CGFloat)cellHeight:(NSString*)contentText with:(CGFloat)with
{
    UIFont * font=[UIFont  systemFontOfSize:14];
    CGSize size=[contentText sizeWithFont:font constrainedToSize:CGSizeMake(with - kTextViewPadding, 300000.0f) lineBreakMode:kLineBreakMode];
    CGFloat height = size.height + 44;
    return height;
}

- (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib {
    NSString *cellID = NSStringFromClass([StatusCell class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        if (isFirstCell) {
//            [[ZJTStatusBarAlertWindow getInstance] hide];
            isFirstCell = NO;
        }
        NSLog(@"cell new");
        NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
        cell = [nibObjects objectAtIndex:0];
    }
    else {
        [(LPBaseCell *)cell reset];
    }
    
    return cell;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [statuesArr count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger  row = indexPath.row;
    StatusCell *cell = [self cellForTableView:table fromNib:self.statusCellNib];
    
    if (row >= [statuesArr count]) {
//        NSLog(@"cellForRowAtIndexPath error ,index = %d,count = %d",row,[statuesArr count]);
        return cell;
    }
    
    NSData *imageData = [imageDictionary objectForKey:[NSNumber numberWithInt:[indexPath row]]];
    Status *status = [statuesArr objectAtIndex:row];
    cell.delegate = self;
    cell.cellIndexPath = indexPath;
    
    [cell setupCell:status avatarImageData:UIImagePNGRepresentation(avatarImage) contentImageData:imageData];
    
    //开始绘制第一个cell时，隐藏indecator.
    if (isFirstCell) {
//        [[ZJTStatusBarAlertWindow getInstance] hide];
        isFirstCell = NO;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{
    NSInteger  row = indexPath.row;
    
    if (row >= [statuesArr count]) {
//        NSLog(@"heightForRowAtIndexPath error ,index = %d,count = %d",row,[statuesArr count]);
        return 1;
    }
    
    Status *status          = [statuesArr objectAtIndex:row];
    Status *retwitterStatus = status.retweetedStatus;
    NSString *url = status.retweetedStatus.thumbnailPic;
    NSString *url2 = status.thumbnailPic;
    
    CGFloat height = 0.0f;
    
    //有转发的博文
    if (retwitterStatus && ![retwitterStatus isEqual:[NSNull null]])
    {
        height = [self cellHeight:status.text with:320.0f] + [self cellHeight:[NSString stringWithFormat:@"%@:%@",status.retweetedStatus.user.screenName,retwitterStatus.text] with:300.0f] - 22.0f;
    }
    
    //无转发的博文
    else
    {
        height = [self cellHeight:status.text with:320.0f];
    }
    
    //
    if ((url && [url length] != 0) || (url2 && [url2 length] != 0))
    {
        height = height + 80;
    }
    return height + 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger  row = indexPath.row;
    if (row >= [statuesArr count]) {
//        NSLog(@"didSelectRowAtIndexPath error ,index = %d,count = %d",row,[statuesArr count]);
        return ;
    }
    
//    ZJTDetailStatusVC *detailVC = [[ZJTDetailStatusVC alloc] initWithNibName:@"ZJTDetailStatusVC" bundle:nil];
//    Status *status  = [statuesArr objectAtIndex:row];
//    detailVC.status = status;
//    detailVC.isFromProfileVC = YES;
//    detailVC.avatarImage = avatarImage;
//    
//    NSData *imageData = [imageDictionary objectForKey:[NSNumber numberWithInt:[indexPath row]]];
//    if (![imageData isEqual:[NSNull null]]) 
//    {
//        detailVC.contentImage = [UIImage imageWithData:imageData];
//    }
//    
//    [self.navigationController pushViewController:detailVC animated:YES];
//    [detailVC release];
}

#pragma mark - StatusCellDelegate

-(void)browserDidGetOriginImage:(NSDictionary*)dic
{
    NSString * url=[dic objectForKey:HHNetDataCacheURLKey];
    if ([url isEqualToString:browserView.bigImageURL]) 
    {
        //[[SHKActivityIndicator currentIndicator] hide];
        shouldShowIndicator = NO;
        
        UIImage * img=[UIImage imageWithData:[dic objectForKey:HHNetDataCacheData]];
        [browserView.imageView setImage:img];
        
        NSLog(@"big url = %@",browserView.bigImageURL);
        if ([browserView.bigImageURL hasSuffix:@".gif"]) 
        {
            UIImageView *iv = browserView.imageView; // your image view
            CGSize imageSize = iv.image.size;
            CGFloat imageScale = fminf(CGRectGetWidth(iv.bounds)/imageSize.width, CGRectGetHeight(iv.bounds)/imageSize.height);
            CGSize scaledImageSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);
            CGRect imageFrame = CGRectMake(floorf(0.5f*(CGRectGetWidth(iv.bounds)-scaledImageSize.width)), floorf(0.5f*(CGRectGetHeight(iv.bounds)-scaledImageSize.height)), scaledImageSize.width, scaledImageSize.height);
            
            GifView *gifView = [[GifView alloc]initWithFrame:imageFrame data:[dic objectForKey:HHNetDataCacheData]];
            
            gifView.userInteractionEnabled = NO;
            gifView.tag = GIF_VIEW_TAG;
            [browserView addSubview:gifView];
            [gifView release];
        }
    }
}

-(void)cellImageDidTaped:(StatusCell *)theCell image:(UIImage *)image
{
    shouldShowIndicator = YES;
    
    if ([theCell.cellIndexPath row] > [statuesArr count]) {
//        NSLog(@"cellImageDidTaped error ,index = %d,count = %d",[theCell.cellIndexPath row],[statuesArr count]);
        return ;
    }
    
    Status *sts = [statuesArr objectAtIndex:[theCell.cellIndexPath row]];
    BOOL isRetwitter = sts.retweetedStatus && sts.retweetedStatus.originalPic != nil;
    UIApplication *app = [UIApplication sharedApplication];
    
    CGRect frame = CGRectMake(0, 0, 320, 480);
    if (browserView == nil) {
        self.browserView = [[[ImageBrowser alloc]initWithFrame:frame] autorelease];
        [browserView setUp];
    }
    
    browserView.image = image;
    browserView.theDelegate = self;
    browserView.bigImageURL = isRetwitter ? sts.retweetedStatus.originalPic : sts.originalPic;
    [browserView loadImage];
    
    app.statusBarHidden = YES;
    UIWindow *window = nil;
    for (UIWindow *win in app.windows) {
        if (win.tag == 0) {
            [win addSubview:browserView];
            window = win;
            [window makeKeyAndVisible];
        }
    }
    
    //animation

    
    if (shouldShowIndicator == YES && browserView) {
//        [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:browserView];
    }
    else shouldShowIndicator = YES;
}


@end
