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
    NSLog(@"warning %@ didn't response %s",self,__func__);
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
    [self mvp_runAction:action sender:sender];
}

- (void)mvp_runAction:(NSString*)actionName value:(id)value;
{
    SEL s = NSSelectorFromString(actionName);
    if ([self respondsToSelector:s]) {
        IMP imp = [self methodForSelector:s];
        void (*func)(id, SEL, id) = (void *)imp;
        func(self, s, value);
    }
    else{
        NSLog(@"%@'s selector [%@] unexist",self,actionName);
    }
}

- (void)mvp_runAction:(NSString*)actionName
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

- (void)mvp_runAction:(NSString*)actionName sender:(id)sender;
{
    SEL s = NSSelectorFromString(actionName);
    if ([self respondsToSelector:s]) {
        if ([actionName hasSuffix:@":"]) {
            IMP imp = [self methodForSelector:s];
            void (*func)(id, SEL, id) = (void *)imp;
            func(self, s, sender);
        }
        else {
            IMP imp = [self methodForSelector:s];
            void (*func)(id, SEL) = (void *)imp;
            func(self, s);
        }
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
    NSLog(@"warning %@ didn't response %s",self,__func__);
}

- (void)mvp_action_withModel:(id<MVPModelProtocol>)model value:(id)value
{
    NSLog(@"warning %@ didn't response %s",self,__func__);
}

- (void)mvp_initFromModel:(id)model
{
    NSLog(@"warning %@ didn't response %s",self,__func__);
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

- (id)mvp_valueWithSelectorName:(NSString *)name sender:(id)sender
{
    SEL s = NSSelectorFromString(name);
    if ([self respondsToSelector:s]) {
        if ([name hasSuffix:@":"]) {
            IMP imp = [self methodForSelector:s];
            id (*func)(id, SEL, id) = (void *)imp;
            return func(self, s, sender);
        }
        else {
            IMP imp = [self methodForSelector:s];
            id (*func)(id, SEL) = (void *)imp;
            return func(self, s);
        }
    }
    else{
        NSLog(@"%@'s selector [%@] unexist",self,name);
    }
    return nil;
}

- (void)mvp_gestrue:(__kindof UIGestureRecognizer *)gesture
{
    NSLog(@"warning %@ didn't response %s",self,__func__);
}

- (void)mvp_gestrue:(__kindof UIGestureRecognizer *)gesture model:(id<MVPModelProtocol>)model
{
    NSLog(@"warning %@ didn't response %s",self,__func__);
}

@end
