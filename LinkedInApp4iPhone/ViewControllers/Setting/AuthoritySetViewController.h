//
//  AuthoritySetViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 14-3-3.
//  Copyright (c) 2014年 liao jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthoritySetViewController : UIViewController<UITableViewDataSource,
    UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSString *qqAuth;
@property (strong, nonatomic) NSString *emailAuth;
@property (strong, nonatomic) NSString *phoneAuth;

@end
