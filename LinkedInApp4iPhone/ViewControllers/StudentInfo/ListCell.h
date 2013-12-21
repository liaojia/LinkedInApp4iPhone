//
//  ListCell.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface ListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EGOImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *txtLabel;
@end
