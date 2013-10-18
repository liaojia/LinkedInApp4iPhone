//
//  StaticUITools.h
//  Mlife
//
//  Created by xuliang on 12-12-27.
//
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
 // 版权所有。
 //
 // 文件功能描述：UI相关的工具函数
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/

#import <Foundation/Foundation.h>
#import "StaticTools.h"
//#import "MBProgressHUD.h"

@class CitySelectViewController;
@class CodeSelectViewController;
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface StaticTools(StaticUITools)


typedef enum
{
    CAlertTypeDefault=0,//默认只有一个确定按钮
    CAlertTypeCacel,    //确定和取消
    CAlertTypeUpDate,   //更新
    CAlertTypeRelogin,  //重新登录
    CalertTypeOther     //其他待定
    
} CAlertStyle;

/*
 带tag的alert实现aLert代理的时候
 */
+ (void)showAlertWithTag:(int)tag
                   title:(NSString *)titleString
                 message:(NSString *)messageString
               AlertType:(CAlertStyle)AlertType
               SuperView:(UIViewController *)SuperViewController;

/*
 @abstract 设置导航栏背景颜色
 */
+ (void)navigationBarSetBackgroundImage:(UINavigationBar *)navigationBar;

/*
 @abstract 给View添加navigation
 */
+ (UINavigationController *)pushNavController:(UIViewController *)viewController;

/*
 @abstract 淡入淡出效果
 */
+ (void)FadeOut:(UIView *)view
         appear:(BOOL)appear
          viewX:(float)viewX
          viewY:(float)viewY
      viewWidth:(float)viewWidth
     viewHeigth:(float)viewHeigth;

/*
 给图片加边框
 */
+ (void)addFrame:(UIView *)sender;

/*
 给图片加圆角
 */
+ (void)createRoundedRectImage:(UIImageView *)imageView;

/*
 *返回label的高度
 */
+ (float)getLabelHeight:(NSString *)textString
            defautWidth:(float)defautWidth
           defautHeight:(float)defautHeight
               fontSize:(int)fontSize;

/*
 *返回label的宽度
 */
+ (float)getLabelWidth:(NSString *)textString
           defautWidth:(float)defautWidth
          defautHeight:(float)defautHeight
              fontSize:(int)fontSize;

/*
 *image拼图
 *返回一个拼好的image
 */
+ (UIImage *)getImageFromImage:(UIImage *)imageLeftOrTop
                 centerImage:(UIImage *)imageCenter
                  finalImage:(UIImage *)imageRightOrBottom
                    withSize:(CGSize)resultSize;

/*
 *屏幕旋转
 */
+ (CGAffineTransform)transformForOrientation;

/*
 navigation右按钮
 */
+ (UIButton *)initNavigationItem:(int)tag withContext:(UIViewController *)context;

/*
 *动态获取键盘状态的通知
 */
+ (void)NotificationkeyboardRectHeight:(UIViewController *)context;

/*
 *给tableview添headerview
 */
+ (void)setheaderView:(UITableView *)tableview;

/*
 给view加BadgeValue
 */
+ (UIView *)showBadgeValue:(NSString *)strBadgeValue
                 withImage:(UIImage *)backgroundImage
                    onView:(UIView *)parentView;

/*
 给view移除badgevalue
 */
+ (void)removeBadgeValue:(UIView *)view;

/*
 tip提示
 */
+ (void)showFavoriteTip:(NSString *)tip img:(NSString *)img;


#pragma mark -
#pragma mark 添加Notification
+ (void)registerNotification:(UIViewController *)context
            notificationName:(NSString * const)notificationName
        notificationFunction:(SEL)function;

#pragma mark 发送Notification
+ (void)postNotification:(NSString *)notificationName param:(id)param;

#pragma mark 删除Notification
+ (void)removeNotification:(UIViewController *)context
          notificationName:(NSString *)notificationName;


#pragma mark - 去掉cell多余的分割线
+ (void)setExtraCellLineHidden: (UITableView *)tableView;

@end


