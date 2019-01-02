//
//  MVPTableViewDelegate.m
//  mvc-base
//
//  Created by 张超 on 2018/12/20.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPTableViewDelegate.h"
#import "MVPPresenter.h"
@implementation MVPTableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self.presenter ]
//    if ([self.presenter ]) {
    
//    }
    if ([self.presenter respondsToSelector:@selector(mvp_action_selectItemAtIndexPath:)]) {
        [self.presenter mvp_action_selectItemAtIndexPath:indexPath];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.dragHideKeyboard) {
        [scrollView endEditing:YES];
    }
}


- (void)dealloc
{
    NSLog(@"%@ %s",[self class],__func__);
}

@end
