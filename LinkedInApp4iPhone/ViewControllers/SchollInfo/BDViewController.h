//
//  BDViewController.h
//  BDDynamicGridViewDemo
//
//  Created by Nor Oh on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述： 首师印象
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "BDDynamicGridViewController.h"
@interface BDViewController : BDDynamicGridViewController <BDDynamicGridViewDelegate>
{
    int currentPage;
    int listTotalCount;
    
    NSArray *testImgArray;
}
@property (strong, nonatomic) NSMutableArray *imgInfoArray; //保存照片信息
@property (strong, nonatomic) NSMutableArray *imgMtbArray;  //保存下载的照片
@property (strong, nonatomic) NSMutableArray *items;
- (void) _demoAsyncDataLoading;
- (void) buildBarButtons;
@end
