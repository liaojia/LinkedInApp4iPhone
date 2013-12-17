//
//  ImageShowView.h
//  HManager
//
//  Created by wenbin on 13-8-15.
//
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
 // 版权所有。
 //
 // 文件功能描述：提供图片缩放查看的视图  注意初始化时只用自定义的唯一的初始哈函数
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface ImageShowView : UIView
{
    UIImageView * imageView;                
	
	CGFloat lastDistance;
	CGFloat imgStartWidth;
	CGFloat imgStartHeight;

    CGPoint touchpoint;
    
    BOOL isMove;  //检测单击事件
}

//初始化函数  
- (id)initWithFrame:(CGRect)frame image:(UIImage*)image;
- (id)initWithFrame:(CGRect)frame url:(NSString*)url;
@end
