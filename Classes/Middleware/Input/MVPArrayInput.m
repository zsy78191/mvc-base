//
//  MVPArrayInput.m
//  mvc-base
//
//  Created by 张超 on 2018/12/19.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPArrayInput.h"
@import UIKit;
@interface MVPArrayInput ()
{
    
}
@property (nonatomic, strong) NSMutableArray* table;


@end

@implementation MVPArrayInput

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.complexSection = 0;
    }
    return self;
}

- (id)allModels
{
    return [self.table copy];
}

- (NSMutableArray *)table
{
    if (!_table) {
        _table = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _table;
}

- (id<MVPModelProtocol>)dataAtIndex:(NSUInteger)idx
{
    return [self.table objectAtIndex:idx];
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section {
    return [self.table count];
}

- (NSUInteger)numberOfSections {
    return 1;
}

- (void)mvp_moveModelFromIndexPath:(NSIndexPath *)path1 toPath:(NSIndexPath *)path2
{
    id obj = [self.table objectAtIndex:path1.row];
    [self.table removeObjectAtIndex:path1.row];
    [self.table insertObject:obj atIndex:path2.row];
}

- (void)test
{
    
}

- (NSUInteger)mvp_addModel:(id<MVPModelProtocol>)model;
{
    [self.table addObject:model];
    NSUInteger index = [self.table count] - 1;
    [self.outputer insertAtIndexPath:[NSIndexPath indexPathForRow:index inSection:self.complexSection]];
    [(id)model setInputer:self];
    return index;
}

- (NSUInteger)mvp_insertModel:(id<MVPModelProtocol>)model atIndex:(NSUInteger)idx;
{
    [self.table insertObject:model atIndex:idx];
    [self.outputer insertAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:self.complexSection]];
    [(id)model setInputer:self];
    return idx;
}

- (NSIndexPath *)mvp_indexPathWithModel:(id<MVPModelProtocol>)model
{
    if ([self.table indexOfObject:model] == NSNotFound) {
        return nil;
    }
    return [NSIndexPath indexPathForRow:[self.table indexOfObject:model] inSection:self.complexSection];
}

- (id<MVPModelProtocol>)mvp_deleteModelAtIndexPath:(NSIndexPath *)path
{
    NSUInteger idx = [path row];
    id obj = [self.table objectAtIndex:idx];
    [self.table removeObjectAtIndex:idx];
    [self.outputer deleleAtIndexPath:path];
    [obj setInputer:nil];
    if ([obj respondsToSelector:@selector(removeFromInputer)]) {
        [obj removeFromInputer];
    }
    return obj;
}

- (void)removeFromInputer
{
    
}


- (void)mvp_cleanAll
{
    [self.table enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setInputer:nil];
        if ([obj respondsToSelector:@selector(removeFromInputer)]) {
            [obj removeFromInputer];
        }
    }];
    [self.table removeAllObjects];
    [self.outputer deleteAll];
}


- (void)mvp_updateModel:(id<MVPModelProtocol>)model atIndexPath:(NSIndexPath *)path
{
    NSUInteger idx = [path row];
    [self.table removeObjectAtIndex:idx];
    [self.table insertObject:model atIndex:idx];
    [self.outputer updateAtIndexPath:path];
}

- (id<MVPModelProtocol>)mvp_modelAtIndexPath:(NSIndexPath *)path
{
    return [self.table objectAtIndex:[path row]];
}

- (NSUInteger)mvp_count
{
    return [self.table count];
}

 
 
@synthesize outputer;

@synthesize complexSection;

@end
