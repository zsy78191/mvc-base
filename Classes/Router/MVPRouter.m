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
@implementation MVPRouter

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
 
@end
