
//
//  DCColor.m
//  mvc-base
//
//  Created by 张超 on 2018/12/25.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "DCColor.h"

@implementation DCColor

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@",[super description],self.colorName];
}

@end
