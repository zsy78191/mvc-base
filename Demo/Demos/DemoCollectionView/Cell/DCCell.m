//
//  DCCell.m
//  mvc-base
//
//  Created by 张超 on 2018/12/25.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "DCCell.h"
#import "DCColor.h"
#import "Account+CoreDataProperties.h"
@interface DCCell()
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation DCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)loadModel:(id)model
{
//    NSLog(@"%@",color.colorName);
    if ([model isKindOfClass:[DCColor class]]) {
        DCColor* color = model;
        [self.colorView setBackgroundColor:[UIColor colorNamed:color.colorName]];
    }
    else if([model isKindOfClass:[Account class]]) {
        Account* a = model;
        self.nameLabel.text = a.name;
    }
}

@end
