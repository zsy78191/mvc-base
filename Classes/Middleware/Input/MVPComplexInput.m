//
//  MVPComplexInput.m
//  mvc-base
//
//  Created by 张超 on 2019/1/8.
//  Copyright © 2019 orzer. All rights reserved.
//

#import "MVPComplexInput.h"
@import oc_string;
@interface MVPComplexInput ()
{
    
}
@property (nonatomic, strong) NSMutableArray* inputs;

@end

@implementation MVPComplexInput

- (NSMutableArray *)inputs
{
    if (!_inputs) {
        _inputs = [[NSMutableArray alloc] init];
    }
    return _inputs;
}

- (id<MVPInputProtocol>)inputerAtIndexPath:(NSIndexPath *)path
{
    return [self.inputs objectAtIndex:path.section];
}

#pragma mark - function

- (void)addInput:(id<MVPInputProtocol>)input
{
    [input setComplexSection:self.inputs.count];
    [self.inputs addObject:input];
    if (self.outputer) {
        [self.outputer insertSectionAtIndex:self.inputs.count-1];
        [input setOutputer:self.outputer];
    }
}

- (void)deleteInput:(id<MVPInputProtocol>)input
{
    [self.inputs removeObject:input];
    if (self.outputer) {
        [self.outputer deleteSectionAtIndex:self.inputs.count-1];
    }
}

- (NSString *)mvp_identifierForModel:(id<MVPModelProtocol>)model
{
    __block NSString* modelIdentifier = nil;
    [self.inputs enumerateObjectsUsingBlock:^(id<MVPInputProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSIndexPath* i = [obj mvp_indexPathWithModel:model];
        BOOL c = [obj containsModel:model];
        if (c) {
            modelIdentifier = [obj mvp_identifierForModel:model];
            if (modelIdentifier && ![modelIdentifier isEqualToString:@"cell"]) {
                *stop = YES;
            }
        }
    }];
    return modelIdentifier;
}

@synthesize outputer = _outputer;

- (id)allModels {
    return self.inputs.map(^id _Nonnull(id<MVPInputProtocol>  _Nonnull x) {
        return [x allModels];
    });
}

- (NSUInteger)mvp_addModel:(id<MVPModelProtocol>)model {
    NSLog(@"%@ can't response %s",self,__func__);
    return NSNotFound;
}

- (void)mvp_cleanAll {
    [self.inputs enumerateObjectsUsingBlock:^(id<MVPInputProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mvp_cleanAll];
    }];
}

- (NSUInteger)mvp_count {
    __block NSUInteger count = 0;
    [self.inputs enumerateObjectsUsingBlock:^(id<MVPInputProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        count += [obj mvp_count];
    }];
    return count;
}

- (id<MVPModelProtocol>)mvp_deleteModelAtIndexPath:(NSIndexPath *)path {
    id<MVPInputProtocol> input = [self.inputs objectAtIndex:path.section];
    return [input mvp_deleteModelAtIndexPath:path];
}

- (void)mvp_deleteModel:(id<MVPModelProtocol>)model
{
    NSIndexPath* p = [self mvp_indexPathWithModel:model];
    [self mvp_deleteModelAtIndexPath:p];
}

- (NSIndexPath *)mvp_indexPathWithModel:(id<MVPModelProtocol>)model {
    __block NSUInteger idx = NSNotFound;
    __block NSUInteger sec = NSNotFound;
    [self.inputs enumerateObjectsUsingBlock:^(id<MVPInputProtocol>   _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath* p = [obj mvp_indexPathWithModel:model];
        if (p) {
            *stop = YES;
            idx = p.row;
            sec = idx;
        }
    }];
    return [NSIndexPath indexPathForRow:idx inSection:sec];
}

- (NSUInteger)mvp_insertModel:(id<MVPModelProtocol>)model atIndex:(NSUInteger)idx {
    NSLog(@"%@ can't response %s",self,__func__);
    return NSNotFound;
}

- (id<MVPModelProtocol>)mvp_modelAtIndexPath:(NSIndexPath *)path {
    id<MVPInputProtocol> input = [self.inputs objectAtIndex:path.section];
    return [input mvp_modelAtIndexPath:path];
}

- (void)mvp_moveModelFromIndexPath:(NSIndexPath *)path1 toPath:(NSIndexPath *)path2 {
    if (path1.section == path2.section) {
        NSInteger s = path1.section;
        id<MVPInputProtocol> input = [self.inputs objectAtIndex:s];
        [input mvp_moveModelFromIndexPath:path1 toPath:path2];
    }
    else {
        NSLog(@"No data exchange across sections");
    }
}

- (void)mvp_updateModel:(id<MVPModelProtocol>)model atIndexPath:(NSIndexPath *)path {
    id<MVPInputProtocol> input = [self.inputs objectAtIndex:path.section];
    [input mvp_updateModel:model atIndexPath:path];
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section {
    id<MVPInputProtocol> input = [self.inputs objectAtIndex:section];
    return [input numberOfRowsInSection:0];
}

- (NSUInteger)numberOfSections {
    return self.inputs.count;
}

- (BOOL)containsModel:(id<MVPModelProtocol>)model { 
    __block BOOL contain = NO;
    [self.inputs enumerateObjectsUsingBlock:^(id<MVPInputProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        contain = contain || [obj containsModel:model];
    }];
    return contain;
}


- (void)setOutputer:(id<MVPOutputProtocol>)outputer
{
    _outputer = outputer;
    [self.inputs enumerateObjectsUsingBlock:^(id<MVPInputProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setOutputer:outputer];
    }];
}



@synthesize complexSection;

@end
