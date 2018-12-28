//
//  MVCPresenter.m
//  mvc-base
//
//  Created by 张超 on 2018/12/14.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPPresenter.h"
@import ReactiveObjC;

@interface MVPPresenter ()
{
    
}
@property (nonatomic, strong) NSMapTable* table;


@end

@implementation MVPPresenter

@synthesize view;

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)mvp_bindItem:(id)item propertyName:(NSString *)name keypath:(NSString *)keypath
{
    [item setValue:[self valueForKey:keypath] forKey:name];
    RACSignal* s =  [self rac_valuesForKeyPath:keypath observer:self];
    [s subscribeNext:^(id  _Nullable x) {
        [item setValue:x forKey:name];
    } error:^(NSError * _Nullable error) {
    
    } completed:^{
        
    }];
}

- (void)mvp_bindBlock:(void (^)(id, id))block keypath:(NSString *)keypath
{
    RACSignal* s =  [self rac_valuesForKeyPath:keypath observer:self];
    @weakify(self);
    [s subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (block) {
            block(self.view,x);
        }
    } error:^(NSError * _Nullable error) {
        
    } completed:^{
        
    }];
}

- (id)mvp_inputerWithOutput:(id<MVPOutputProtocol>)output
{
    return nil;
}


// NSKeyValueChangeSetting = 1,
// NSKeyValueChangeInsertion = 2,
// NSKeyValueChangeRemoval = 3,
// NSKeyValueChangeReplacement = 4

- (void)mvp_bindChangeBlock:(void (^)(id, id, id, id, id))block keypath:(NSString *)keypath
{
    RACSignal* s =  [self rac_valuesAndChangesForKeyPath:keypath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld observer:self];
    [s subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
        id value = x[0];
        NSDictionary* c = x[1];
        if (block) {
            switch ( [c[@"kind"] integerValue]) {
                case NSKeyValueChangeSetting:
                    NSLog(@"赋值");
                    if (block) {
                        block(self.view,value,NULL,NULL,NULL);
                    }
                    break;
                case NSKeyValueChangeInsertion:
                    NSLog(@"插入");
                    if (block) {
                        block(self.view,value,c,NULL,NULL);
                    }
                    break;
                case NSKeyValueChangeRemoval:
                    NSLog(@"删除");
                    if (block) {
                        block(self.view,value,NULL,c,NULL);
                    }
                    break;
                case NSKeyValueChangeReplacement:
                    NSLog(@"替换");
                    if (block) {
                        block(self.view,value,NULL,NULL,c);
                    }
                    break;
                default:
                    break;
            }
//            block(value)
        }
    } error:^(NSError * _Nullable error) {
        
    } completed:^{
        
    }];
}

- (void)mvc_action:(id)sender
{
    NSString* action = [[self table] objectForKey:sender];
    [self mvp_runAction:action];
}

- (void)mvp_runAction:(NSString*)actionName;
{
    SEL s = NSSelectorFromString(actionName);
    if ([self respondsToSelector:s]) {
        IMP imp = [self methodForSelector:s];
        void (*func)(id, SEL) = (void *)imp;
        func(self, s);
    }
    else{
        NSLog(@"%@'s selector [%@] unexist",self,actionName);
    }
}

- (void)mvp_registActionName:(NSString *)name item:(id)item
{
    [[self table] setObject:name forKey:item];
}

- (void)mvp_removeActionForItem:(id)item
{
    [[self table] removeObjectForKey:item];
}

- (void)mvp_action_selectItemAtIndexPath:(NSIndexPath *)path
{
    
}

- (void)mvp_action_withModel:(id<MVPModelProtocol>)model value:(id)value
{
    
}

- (void)mvp_initFromModel:(id)model
{
    
}


 
#pragma mark - lazy

- (NSMapTable *)table
{
    if (!_table) {
        _table = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSHashTableCopyIn capacity:10];

    }
    return _table;
}

- (Class)routerClass
{
    return NSClassFromString(@"MVPRouter");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.router = [[[self routerClass] alloc] init];
    }
    return self;
}

- (id)mvp_valueWithSelectorName:(NSString *)name
{
    if ([self respondsToSelector:NSSelectorFromString(name)]) {
        SEL s = NSSelectorFromString(name);
        IMP imp = [self methodForSelector:s];
        id (*func)(id, SEL) = (void *)imp;
        return func(self, s);
    }
    NSLog(@"%@'s selector [%@] unexist",self,name);
    return nil;
}

@end
