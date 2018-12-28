//
//  MVPInitModel.m
//  mvc-base
//
//  Created by 张超 on 2018/12/27.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPInitModel.h"

@implementation MVPInitModel

- (instancetype)initWithMJDictionary:(NSDictionary *)MJDictionary
{
    self = [super init];
    if (self) {
        self.url = [MJDictionary valueForKey:@"MGJRouterParameterURL"];
        self.userInfo = [MJDictionary valueForKey:@"MGJRouterParameterUserInfo"];
        NSMutableDictionary* d = [NSMutableDictionary dictionaryWithCapacity:10];
        [[MJDictionary allKeys] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isEqualToString:@"MGJRouterParameterURL"] && ![obj isEqualToString:@"MGJRouterParameterUserInfo"]) {
                [d setValue:[MJDictionary valueForKey:obj] forKey:obj];
            }
        }];
        self.queryProperties = [d copy];
    }
    return self;
}

@end
