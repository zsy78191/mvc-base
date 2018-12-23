//
//  MVPEmptyMiddleware.m
//  mvc-base
//
//  Created by 张超 on 2018/12/23.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPEmptyMiddleware.h"
@import DZNEmptyDataSet;
@interface MVPEmptyMiddleware() <DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@end

@implementation MVPEmptyMiddleware


- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView;
{
    NSString *title = [self titleForEmpty];
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (NSString *)titleForEmpty
{
    return @"空空如也";
}


@end
