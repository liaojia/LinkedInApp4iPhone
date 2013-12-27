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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    self.leftBtn.selected = button==self.leftBtn;
    self.rightBtn.selected = button==self.rightBtn;
}
@end
