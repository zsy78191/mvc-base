//
//  MVCModel.m
//  mvc-base
//
//  Created by 张超 on 2018/12/14.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPModel.h"
#import <objc/runtime.h>
@implementation MVPModel

- (NSString *)identifier
{
    return @"cell";
}

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
@end
