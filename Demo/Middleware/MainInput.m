//
//  MainInput.m
//  mvc-base
//
//  Created by 张超 on 2018/12/19.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MainInput.h"
#import "MyModel.h"
@implementation MainInput

- (NSString *)mvp_identifierForModel:(id<MVPModelProtocol>)model
{
    if ([model isKindOfClass:[MyModel class]]) {
        return @"MyCell";
    }
    return @"cell";
}



@end
