//
//  CoreInput.m
//  mvc-base
//
//  Created by 张超 on 2018/12/22.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "CoreInput.h"
//#import "Account.h"
#import "Account+CoreDataProperties.h"
@import MagicalRecord;
@implementation CoreInput

- (NSString *)mvp_identifierForModel:(id<MVPModelProtocol>)model
{
    return @"CoreCell";
}

- (Class)mvp_modelClass
{
    return [Account class];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [Account MR_createEntity]
        
    }
    return self;
}

- (NSArray<NSSortDescriptor *> *)sortDescriptors
{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
}



@end
