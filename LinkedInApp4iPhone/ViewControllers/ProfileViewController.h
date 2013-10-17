//
//  ProfileViewController.h
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)    UITextField *searchTF;
@property(nonatomic, strong)    UITableView *mTableView;
@property(nonatomic)            int sectionCount;
@property(nonatomic, strong)    NSMutableArray *array_timeline;
@property(nonatomic, strong)    NSMutableArray *array_myattention;
@property(nonatomic, strong)    NSMutableArray *array_fans;
@property(nonatomic, strong)    NSMutableDictionary *dic_array;

@end
