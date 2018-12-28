//
//  MVPCollectionViewDelegate.m
//  mvc-base
//
//  Created by 张超 on 2018/12/25.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPCollectionViewDelegate.h"

@implementation MVPCollectionViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.dragHideKeyboard) {
        [scrollView resignFirstResponder];
    }
}

@end
