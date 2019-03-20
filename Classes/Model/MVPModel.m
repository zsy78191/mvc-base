//
//  MVCModel.m
//  mvc-base
//
//  Created by 张超 on 2018/12/14.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPModel.h"
#import <objc/runtime.h>
#import "MVPOutputProtocol.h"

@interface MVPModel()
{
    
}

@end

@implementation MVPModel

- (NSArray *)propertys
{
    unsigned int count = 0;
    //获取属性的列表
    objc_property_t *propertyList =  class_copyPropertyList([self class], &count);
    NSMutableArray *propertyArray = [NSMutableArray array];
    for(int i=0;i<count;i++)
    {
        //取出每一个属性
        objc_property_t property = propertyList[i];
        //获取每一个属性的变量名
        const char* propertyName = property_getName(property);
        NSString *proName = [[NSString alloc] initWithCString:propertyName encoding:NSUTF8StringEncoding];
        [propertyArray addObject:proName];
    }
    //c语言的函数，所以要去手动的去释放内存
    free(propertyList);
    return propertyArray.copy;
}

- (BOOL)mvp_sameWithModel:(id<MVPModelProtocol>)model
{
    return [self sameWithObj:model];
}

- (BOOL)mvp_sameWithCoreDataModel:(__kindof NSManagedObject *)model
{
    return [self sameWithObj:model];
}

- (BOOL)sameWithObj:(id)obj
{
    __block BOOL same = YES;
    [[self propertys] enumerateObjectsUsingBlock:^(NSString*  _Nonnull p, NSUInteger idx, BOOL * _Nonnull stop) {
        id v1 = [self valueForKey:p];
        id v2 = [(id)obj valueForKey:p];
        if (![self same:v1 with:v2]) {
            same = NO;
            *stop = YES;
        }
    }];
    return same;
}

- (BOOL)same:(id)v1 with:(id)v2
{
    if ( (v1 == nil && v2 != nil) || (v1 != nil && v2 == nil)) {
        return NO;
    }
    else if (![v1 isKindOfClass:[v2 class]]) {
        return NO;
    }
    else {
        if ([v1 isKindOfClass:[NSString class]]) {
            if (![v1 isEqualToString:v2]) {
                return NO;
            }
        }
        else
        {
            if (![[v1 description] isEqualToString:[v2 description]]) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)removeFromInputer
{
    
}

+ (MVPModelNewInstanceBlock)m
{
    MVPModelNewInstanceBlock b2 = ^(MVPModelInitailBlock b){
        __kindof MVPModel* model = [[[self class] alloc] init];
        if (b) {
            b(model);
        }
        return model;
    };
    return b2;
}

@synthesize inputer;

@synthesize cell_identifier = _cell_identifier;

@end
