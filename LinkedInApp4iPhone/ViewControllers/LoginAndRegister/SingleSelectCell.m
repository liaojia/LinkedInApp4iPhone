//
//  SingleSelectCell.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-27.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "SingleSelectCell.h"

@implementation SingleSelectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
 - (void)awakeFromNib
{
    [self.segControl setSelectedSegmentIndex:0];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
