//
//  StaticUITools.m
//  Mlife
//
//  Created by xuliang on 12-12-27.
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
 // 版权所有。
 //
 // 文件名： StaticUITools.m
 // 文件功能描述：公共方法类
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/


#import "StaticUITools.h"
#import <QuartzCore/QuartzCore.h>
#import "StaticDataTools.h"


@implementation StaticTools(StaticUITools)
/*
 带tag的alert实现aLert代理的时候
 */
+ (void)showAlertWithTag:(int)tag
                   title:(NSString *)titleString
                 message:(NSString *)messageString
               AlertType:(CAlertStyle)AlertType
               SuperView:(UIViewController *)SuperViewController
{
//    UIWindow *mainWindow= [[UIApplication sharedApplication] keyWindow];
//    for(UIView *view in mainWindow.subviews){
//        if ([view isKindOfClass:[UIAlertView class]])
//        {
//            [view removeFromSuperview];
//        }
//    }
    
    UIAlertView *alert;
    
    switch (AlertType)
    {
        case CAlertTypeDefault:
            
            alert=[[UIAlertView alloc] initWithTitle:titleString message:messageString delegate:SuperViewController cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            if (SuperViewController)
            {
                alert.delegate=SuperViewController;
            }
            alert.tag = tag;
            [alert show];
            [alert release];
            
            break;
        case CAlertTypeCacel:

            alert=[[UIAlertView alloc] initWithTitle:titleString message:messageString delegate:SuperViewController cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            if (SuperViewController)
            {
                alert.delegate=SuperViewController;
            }
            alert.tag = tag;
            [alert show];
            [alert release];
            
            break;
        case CAlertTypeUpDate:
            
            alert=[[UIAlertView alloc] initWithTitle:titleString message:messageString delegate:SuperViewController cancelButtonTitle:@"暂不更新" otherButtonTitles:@"更新", nil];
            if (SuperViewController)
            {
                alert.delegate=SuperViewController;
            }
            alert.tag = tag;
            [alert show];
            [alert release];
            
            break;
        case CAlertTypeRelogin:
            
            alert=[[UIAlertView alloc] initWithTitle:titleString message:messageString delegate:SuperViewController cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
            if (SuperViewController)
            {
                alert.delegate=SuperViewController;
            }
            alert.tag = tag;
            [alert show];
            [alert release];
            break;
        case CalertTypeOther:
            
            alert=[[UIAlertView alloc] initWithTitle:titleString message:messageString delegate:SuperViewController cancelButtonTitle:@"关闭" otherButtonTitles:@"重试", nil];
            if (SuperViewController)
            {
                alert.delegate=SuperViewController;
            }
            alert.tag = tag;
            [alert show];
            [alert release];
            break;
        default:
            break;
    }
}

/*
 @abstract 设置导航栏背景颜色
 */
+ (void)navigationBarSetBackgroundImage:(UINavigationBar *)navigationBar{
    if ([navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
		[navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_viewnav"] forBarMetrics:UIBarMetricsDefault];
        //navigationBar.tintColor=[UIColor redColor];
        
        //[UIColor colorWithRed:139.0/255 green:178.0/255 blue:38.0/255 alpha:1];
	}
}

/*
 @abstract 给View添加navigation
 */
+ (UINavigationController *)pushNavController:(UIViewController *)viewController
{
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self navigationBarSetBackgroundImage:navController.navigationBar];
    return [navController autorelease];
}

/*
 @abstract 淡入淡出效果
 */
+ (void) FadeOut:(UIView *)view appear:(BOOL)appear
		   viewX:(float)viewX
		   viewY:(float)viewY
	   viewWidth:(float)viewWidth
	  viewHeigth:(float)viewHeigth
{
    view.alpha = appear?0:1;
    view.frame = appear?CGRectMake(viewX + viewWidth / 2, viewY+viewHeigth / 2, 0, 0):CGRectMake(viewX, viewY, viewWidth, viewHeigth);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
	view.alpha = appear?1:0;
    view.frame = !appear?CGRectMake(viewX + viewWidth / 2, viewY + viewHeigth / 2, 0, 0):CGRectMake(viewX, viewY, viewWidth, viewHeigth);
	[UIView commitAnimations];
}

/*
 给图片加边框
 */
+ (void)addFrame:(UIView *)sender{
    sender.layer.masksToBounds=YES;
	sender.layer.cornerRadius=0.8;
	sender.layer.borderWidth=0.8;
    sender.layer.borderColor=[[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1]CGColor];
}

/*
 给图片加圆角
 */
+ (void)createRoundedRectImage:(UIImageView *)imageView{
    imageView.layer.masksToBounds = YES;
	imageView.layer.cornerRadius = 5.0;
}

/*
 *返回label的高度
 */
+ (float)getLabelHeight:(NSString *)textString
            defautWidth:(float)defautWidth
           defautHeight:(float)defautHeight
               fontSize:(int)fontSize
{
    CGSize size = CGSizeMake(defautWidth,defautHeight);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [textString sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    return labelsize.height;
}

/*
 *返回label的宽度
 */
+ (float)getLabelWidth:(NSString *)textString
           defautWidth:(float)defautWidth
          defautHeight:(float)defautHeight
              fontSize:(int)fontSize
{
    //textString = [textString stringByReplacingOccurrencesOfString:@"0" withString:@"*"];
    CGSize size = CGSizeMake(defautWidth,defautHeight);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [textString sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    return labelsize.width;
}

/*
 *image拼图
 *返回一个拼好的image
 */
+ (UIImage *)getImageFromImage:(UIImage *)imageLeftOrTop
                  centerImage:(UIImage *)imageCenter
                   finalImage:(UIImage *)imageRightOrBottom
                     withSize:(CGSize)resultSize
{
    //m_zhanggaofeng20130712 解决图片拼接后模糊问题
//    UIGraphicsBeginImageContext(resultSize);
    UIGraphicsBeginImageContextWithOptions(resultSize, NO, 0.0);
    
    // Draw image1
    [imageLeftOrTop drawInRect:CGRectMake(0, 0, imageLeftOrTop.size.width, imageLeftOrTop.size.height)];
    
    // Draw image2
    if (resultSize.height == imageLeftOrTop.size.height)
    {
        //如果高度相等 则从左到右画图
        [imageCenter drawInRect:CGRectMake(imageLeftOrTop.size.width, 0, resultSize.width -imageLeftOrTop.size.width - imageRightOrBottom.size.width, imageCenter.size.height)];
        // Draw image3
        [imageRightOrBottom drawInRect:CGRectMake(resultSize.width-imageRightOrBottom.size.width, 0, imageRightOrBottom.size.width, imageRightOrBottom.size.height)];
    }
    else if(resultSize.width == imageLeftOrTop.size.width)
    {
        //宽度相同 则从上到下画图
        [imageCenter drawInRect:CGRectMake(0, imageLeftOrTop.size.height, imageCenter.size.width, resultSize.height - imageLeftOrTop.size.height-imageRightOrBottom.size.height)];
        // Draw image3
        [imageRightOrBottom drawInRect:CGRectMake(0, resultSize.height - imageRightOrBottom.size.height, imageRightOrBottom.size.width, imageRightOrBottom.size.height)];
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
//    [resultingImage release];
}

/*
 *屏幕旋转
 */
+ (CGAffineTransform)transformForOrientation {
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (UIInterfaceOrientationLandscapeLeft == orientation) {
		return CGAffineTransformMakeRotation(M_PI*1.5);
	} else if (UIInterfaceOrientationLandscapeRight == orientation) {
		return CGAffineTransformMakeRotation(M_PI/2);
	} else if (UIInterfaceOrientationPortraitUpsideDown == orientation) {
		return CGAffineTransformMakeRotation(-M_PI);
	} else {
		return CGAffineTransformIdentity;
	}
}

+ (UIButton *)initNavigationItem:(int)tag withContext:(UIViewController *)context {
	UIButton *ItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ItemBtn.tag=tag;
	[ItemBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [ItemBtn.titleLabel setTextColor:[UIColor blackColor]];
    [ItemBtn.titleLabel setTextAlignment:UITextAlignmentCenter];
	[ItemBtn setTitle:@"返回" forState:UIControlStateNormal];
	[ItemBtn setTitle:@"返回" forState:UIControlStateHighlighted];
	[ItemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   // [ItemBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    if ([context respondsToSelector:@selector(touchUpClickListener:)])
    {
        [ItemBtn addTarget:context action:@selector(touchUpClickListener:) forControlEvents:UIControlEventTouchUpInside];
    }
	[ItemBtn setBackgroundImage:[UIImage imageNamed:@"btn_viewnav"] forState:UIControlStateNormal];
	[ItemBtn setBackgroundImage:[UIImage imageNamed:@"btn_viewnavpress"] forState:UIControlStateHighlighted];
	[ItemBtn setFrame:CGRectMake(0, 0, 60, 45)];
	
	return ItemBtn;
}

/*
 *动态获取键盘状态的通知
 */
+ (void)NotificationkeyboardRectHeight:(UIViewController *)context
{
    if ([context respondsToSelector:@selector(keyboardWillHide:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:context selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    if ([context respondsToSelector:@selector(keyboardWillShow:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:context selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        
#ifdef __IPHONE_5_0
        
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        
        if (version >= 5.0) {
            
            [[NSNotificationCenter defaultCenter] addObserver:context selector:@selector(keyboardWillShow:) name:UIKeyboardDidChangeFrameNotification object:nil];
            
        }
#endif
        
    }
}

/*
 *给tableview添headerview
 */
+ (void)setheaderView:(UITableView *)tableview{
    
    UIView *headview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    [headview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_list_all.png"]]];
    UIImageView *lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 320, 1)];
    [lineImage setBackgroundColor:[StaticTools colorWithHexString:@"#e1e1e1"]];
    [headview addSubview:lineImage];
    [tableview setTableHeaderView:headview];
    [lineImage release];
    [headview release];
}

/*
 给view加BadgeValue
 */
+ (UIView *)showBadgeValue:(NSString *)strBadgeValue
                 withImage:(UIImage *)backgroundImage
                    onView:(UIView *)parentView
{
    UIImageView *subview=[[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)] autorelease];//M_lxl
    [subview setImage:backgroundImage];
    UILabel *badgeLable=[[UILabel alloc] initWithFrame:CGRectMake(0, -1, backgroundImage.size.width, backgroundImage.size.height)];
    [badgeLable setFont:[UIFont systemFontOfSize:13]];
    [badgeLable setBackgroundColor:[UIColor clearColor]];
    [badgeLable setTextAlignment:UITextAlignmentCenter];
    [badgeLable setTextColor:[UIColor whiteColor]];
    if ([strBadgeValue intValue] < 10)
    {
        [badgeLable setText:strBadgeValue];
    }
    else
    {
        [badgeLable setText:@"N"];
    }
    [badgeLable setTextAlignment:UITextAlignmentCenter];
    [subview addSubview:badgeLable];
    [badgeLable release];//A_lxl
    [parentView addSubview:subview];
    subview.frame = CGRectMake(parentView.frame.size.width-subview.frame.size.width, 0,
                               subview.frame.size.width, subview.frame.size.height);
    
    return subview;
}

/*
 给view移除badgevalue
 */
+ (void)removeBadgeValue:(UIView *)view
{
    //移除badgevalue
    for (UIView *subview in view.subviews) {
        NSString *strClassName = [NSString stringWithUTF8String:object_getClassName(subview)];
        if ([strClassName isEqualToString:@"UIImageView"] ||
            [strClassName isEqualToString:@"_UIBadgeView"]) {
            [subview removeFromSuperview];
            break;
        }
    }
}

/*
 tip提示
 */
+ (void)showFavoriteTip:(NSString *)tip img:(NSString *)img{
    UIWindow *mainWindow= [[UIApplication sharedApplication] keyWindow];
    for(UIView *view in mainWindow.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview];
        }
    }
    
    UIImageView *starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_toast.png"]];
    [starImageView setFrame:CGRectMake((mainWindow.frame.size.width - 170)/2, (mainWindow.frame.size.height - 60)/2, 170, 60)];
    
    UIImageView *iconImageview;
    if ([img isEqualToString:@""]) {
        iconImageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_toast_right.png"]];
    }else{
        iconImageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:img]];
    }
    
    [iconImageview setFrame:CGRectMake(15, (starImageView.frame.size.height - 30)/2, 30, 30)];
    [starImageView addSubview:iconImageview];
    
    UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectMake(35, (starImageView.frame.size.height-30)/2, starImageView.frame.size.width-40, 30)];
    lblText.textAlignment = UITextAlignmentCenter;
    lblText.text = tip;
    lblText.backgroundColor = [UIColor clearColor];
    [lblText setTextColor:[UIColor whiteColor]];
    [lblText setFont:[UIFont systemFontOfSize:15]];
    [starImageView addSubview:lblText];
    
    [mainWindow addSubview:starImageView];
    
    //消失的动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:3.0f];
    [UIView setAnimationDelay:2.0f];
    
    starImageView.alpha = 0.0f;
    
    [UIView commitAnimations];
    
    [starImageView release];
    [lblText release];
    [iconImageview release];
}


#pragma mark -
#pragma mark 添加Notification
/*
 *注册通知
 *
 *@param context
 *  传入接收消息的上下文，即谁要接收消息，类型为UIViewController
 *
 *@param notificationName
 *  传入通知的名称
 *
 *@param notificationFunction
 *  传入接到通知后要调用的方法名
 *
 *@调用举例
 *   [StaticTools registerNotification:self notificationName:@"updata" notificationFunction:@selector(updata:)];
 */
+(void)registerNotification:(UIViewController *)context
           notificationName:(NSString * const)notificationName
       notificationFunction:(SEL)function
{
    if ([context respondsToSelector:function])
    {
        [[NSNotificationCenter defaultCenter] addObserver:context selector:function name:notificationName object:nil];
    }
}

#pragma mark -
#pragma mark 发送Notification
/*
 *发送通知
 *
 *@param notificationName
 *  传入通知的名称
 *
 *@param param
 *  传入通知需要携带的值，类型为id
 *
 *@调用举例
 *   NSArray* arr = [[NSArray alloc] initWithObjects:@"a",@"b", nil];
 [StaticTools postNotification:@"updata" param: arr];
 *
 *@取出消息中携带值方法
 *  在接到通知后要调用的方法中  NSArray* arr = (NSArray*)[n object];
 */
+ (void)postNotification:(NSString *)notificationName param:(id)param{
    NSNotification *notification = [NSNotification notificationWithName:notificationName object:param];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark -
#pragma mark 删除Notification
/*
 *删除接收通知
 *
 *@param context
 *  传入接收消息的上下文，即谁要接收消息，类型为UIViewController
 *
 *@param notificationName
 *  传入通知的名称，若在viewDidLoad 中调用注册通知，则在viewDidUnload中调用删除
 *
 *@调用举例
 *   [StaticTools removeNotification:self notificationName:@"updata"];
 */
+ (void)removeNotification:(UIViewController *)context  notificationName:(NSString *)notificationName{
    [[NSNotificationCenter defaultCenter] removeObserver:context name:notificationName object:nil];
}


#pragma mark - 去掉cell多余的分割线
+ (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
}

@end

