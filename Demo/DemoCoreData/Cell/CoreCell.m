//
//  CoreCell.m
//  mvc-base
//
//  Created by 张超 on 2018/12/23.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "CoreCell.h"
#import "Account+CoreDataProperties.h"
@implementation CoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadModel:(Account*)model
{
    [super loadModel:(id)model];
//    NSLog(@"%@",model);
    self.textLabel.text = model.name;
    
    [self mvp_bindModel:(id)model withProperties:@[@"name"]];
    
}

- (void)mvp_value:(id)value updateForKeypath:(NSString *)keypath
{
    NSLog(@"%s",__func__);
    self.textLabel.text = value;
}

@end
