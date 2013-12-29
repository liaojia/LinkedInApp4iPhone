//
//  StudentInfoCell.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-27.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *departmentBtn; //院系

@property (weak, nonatomic) IBOutlet UIButton *majorBtn; //专业
@property (weak, nonatomic) IBOutlet UITextField *classTxtField; //班级
@property (weak, nonatomic) IBOutlet UIButton *startYearBtn; //入学年份
@end
