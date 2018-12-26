//
//  DMApperance.m
//  mvc-base
//
//  Created by 张超 on 2018/12/25.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "DMApperance.h"



@implementation DMApperance

- (void)mvp_setupView:(__kindof UIView *)view
{
    switch (view.tag) {
        case MVPViewTagManageView:
        {
            if ([view isKindOfClass:[UITableView class]]) {
                [self configTableView:view];
            }
            break;
        }
        case MVPViewTagContentView:
        {
            [self configContentView:view];
            break;
        }
        default:
            break;
    }
}

- (void)configTableView:(UITableView*)tableView;
{
    [tableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
    [tableView setBackgroundColor:[UIColor clearColor]];
}

- (void)configContentView:(UIView*)contentView
{
    contentView.backgroundColor = [UIColor colorNamed:@"bgColor"];
}

@end
