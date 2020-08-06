//
//  MyCell.m
//  mvc-base
//
//  Created by 张超 on 2018/12/19.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MyCell.h"
#import "MyModel.h"
@implementation MyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadModel:(MyModel*)model
{
    self.textLabel.text = model.name;
}

@end
