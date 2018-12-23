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


- (void)test
{
    
}

- (NSUInteger)mvp_addModel:(id<MVPModelProtocol>)model;
{
    [self.table addObject:model];
    NSUInteger index = [self.table count] - 1;
    [self.outputer insertAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    return index;
}

- (NSUInteger)mvp_insertModel:(id<MVPModelProtocol>)model atIndex:(NSUInteger)idx;
{
    [self.table insertObject:model atIndex:idx];
    [self.outputer insertAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
    return idx;
}

- (id<MVPModelProtocol>)mvp_deleteModelAtIndexPath:(NSIndexPath *)path
{
    NSUInteger idx = [path indexAtPosition:0];
    id obj = [self.table objectAtIndex:idx];
    [self.table removeObjectAtIndex:idx];
    [self.outputer deleleAtIndexPath:path];
    return obj;
    
}

- (void)mvp_updateModel:(id<MVPModelProtocol>)model atIndexPath:(NSIndexPath *)path
{
    NSUInteger idx = [path indexAtPosition:0];
    [self.table removeObjectAtIndex:idx];
    [self.table insertObject:model atIndex:idx];
    [self.outputer updateAtIndexPath:path];
}

- (id<MVPModelProtocol>)mvp_modelAtIndexPath:(NSIndexPath *)path
{
    return [self.table objectAtIndex:[path indexAtPosition:0]];
}

- (NSUInteger)mvp_count
{
    return [self.table count];
}

 
 
@synthesize outputer;

@end
