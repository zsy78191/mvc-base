//
//  AppTitleCell.m
//  mvc-base
//
//  Created by 张超 on 2018/12/24.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "AppTitleCell.h"
#import "AppInfoModel.h"
@interface AppTitleCell ()
{
    
}
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UILabel *appVersion;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation AppTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.icon setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer* t = [[UITapGestureRecognizer alloc] init];
    [self.icon addGestureRecognizer:t];
    [self mvp_bindGesture:t];
    [self mvp_bindAction:UIControlEventTouchUpInside target:self.infoBtn actionName:@"actionBtn:"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadModel:(AppInfoModel*)model
{
    [super loadModel:model];
//    self.appName.text = model.appName;
    [self mvp_bindModel:model withProperties:@[@"appName",@"appVersion"]];
}

- (void)mvp_value:(id)value updateForKeypath:(NSString *)keypath
{
    if ([keypath isEqualToString:@"appVersion"]) {
        self.appVersion.text = value;
    }
    else if([keypath isEqualToString:@"appName"])
    {
        self.appName.text = value;
    }
}

@end
