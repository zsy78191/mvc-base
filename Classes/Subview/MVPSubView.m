//
//  MVPSubView.m
//  mvc-base
//
//  Created by 张超 on 2018/12/25.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPSubView.h"
#import "MVPViewApperance.h"
@implementation MVPSubView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    
    if ([self.view appear]) {
        [[self.view appear] mvp_setupView:view];
    }
}

@end
