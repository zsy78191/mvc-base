//
//  MVPRouter.m
//  mvc-base
//
//  Created by 张超 on 2018/12/23.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPRouter.h"
#import "MVPView.h"
@import MGJRouter;
@interface MVPRouter ()
{
    
}
@property (nonatomic, strong) NSMapTable* cacheTable;
@end

@implementation MVPRouter

+ (instancetype)sharedRouter
{
    static MVPRouter* sharedInstence_router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstence_router = [[MVPRouter alloc] init];
    });
    return sharedInstence_router;
}

- (NSMapTable *)cacheTable
{
    if (!_cacheTable) {
        _cacheTable = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsStrongMemory capacity:10];
    }
    return _cacheTable;
}

+ (void)registView:(Class)viewClass forURL:(NSString *)url
{
    [MGJRouter registerURLPattern:url toObjectHandler:^id(NSDictionary *routerParameters) {
        __kindof MVPView* v = [[viewClass alloc] initWithUserInfo:routerParameters];
        return v;
    }];
}


+ (MVPView *)viewForURL:(NSString*)url withUserInfo:(NSDictionary * _Nullable)userInfo
{
    return [MGJRouter objectForURL:url withUserInfo:userInfo];
}

+ (void)registRouter{
    
}

- (void)regiestTarget:(id)target selector:(SEL)selector asRouter:(NSString *)url
{
    [self regiestTarget:target selector:selector asRouter:url staticed:NO];
}

- (void)regiestTarget:(id)target selector:(SEL)selector asStaticRouter:(NSString *)url
{
     [self regiestTarget:target selector:selector asRouter:url staticed:YES];
}

- (void)regiestTarget:(id)target selector:(SEL)selector asRouter:(NSString *)url staticed:(BOOL)flag
{
    __weak typeof(target) weakTarget = target;
//    __weak typeof(self) weakSelf = self;
    
    [MGJRouter registerURLPattern:url toObjectHandler:^id(NSDictionary *routerParameters) {
        
        if (flag) {
            if ([[MVPRouter sharedRouter].cacheTable objectForKey:url]) {
                return [[MVPRouter sharedRouter].cacheTable objectForKey:url];
            }
        }
        
        if ([weakTarget respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id d = [weakTarget performSelector:selector withObject:routerParameters];
            [[MVPRouter sharedRouter].cacheTable setObject:[d copy] forKey:url];
            return d;
#pragma clang diagnostic pop
        }
        else {
            NSLog(@"warining %@ didn't response selector %@",weakTarget,NSStringFromSelector(selector));
        }
        return nil;
    }];
    
    if (flag) {
        [MGJRouter objectForURL:url];
    }
}

- (void)unregistRouter:(NSString *)url
{
    [MGJRouter deregisterURLPattern:url];
}

- (id)valueForRouterURL:(NSString *)url
{
    return [MGJRouter objectForURL:url];
}

@end
