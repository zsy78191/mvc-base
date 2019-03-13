//
//  MVPEmptyMiddleware.m
//  mvc-base
//
//  Created by 张超 on 2018/12/23.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPEmptyMiddleware.h"
@import UIKit;
@import DZNEmptyDataSet;
@interface MVPEmptyMiddleware() <DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@end

@implementation MVPEmptyMiddleware


- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView;
{
    NSString *title = [self titleForEmptyTitle];
    return [[NSAttributedString alloc] initWithString:title attributes:[self attributesForEmptyTitle]];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *title = [self titleForEmptyDescription];
    return [[NSAttributedString alloc] initWithString:title attributes:[self attributesForEmptyDescription]];
}

- (NSString *)titleForEmptyTitle
{
    return @"空空如也";
}

- (NSDictionary *)attributesForEmptyTitle
{
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                 };
    return attributes;
}

- (NSString *)titleForEmptyDescription
{
    return @"";
}

- (NSDictionary *)attributesForEmptyDescription
{
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor]
                                 };
    return attributes;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [self image];
}

- (UIImage *)image
{
    return nil;
}

- (UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [self imageTintColor];
}

- (UIColor*)imageTintColor
{
    return nil;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return  [[NSAttributedString alloc] initWithString:[self buttonTitleForState:state] attributes:[self buttonTitleAttributesForState:state]];
}

- (NSString *)buttonTitleForState:(NSUInteger)state
{
    return @"按钮";
}

- (NSDictionary *)buttonTitleAttributesForState:(NSUInteger)state
{
    return @{
     NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f],
     NSForegroundColorAttributeName:[UIColor lightGrayColor]
     };;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    if ([self respondsToSelector:@selector(didTapButton:)]) {
        [self didTapButton:button];
    }
}

- (void)didTapButton:(UIButton *)button
{
    
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    return [self customView];
}

- (UIView *)customView
{
    return nil;
}


@end
