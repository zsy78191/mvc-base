//
//  CoreModel.m
//  mvc-base
//
//  Created by 张超 on 2018/12/23.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "CoreModel.h"
 
@implementation CoreModel



- (instancetype)init
{
    self = [super init];
    if (self) {
//        NSLog(@"%@",[self propertys]);
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}


@end
