//
//  WorkersCell.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-27.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkersCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *firstCompayeBtn; //一级单位
@property (weak, nonatomic) IBOutlet UIButton *secCompanyBtn; //二级单位
@property (weak, nonatomic) IBOutlet UITextField *workersNumTxtField; //职工编号
@end
