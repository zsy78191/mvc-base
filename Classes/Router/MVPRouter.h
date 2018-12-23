//
//  MVPRouter.h
//  mvc-base
//
//  Created by 张超 on 2018/12/23.
//  Copyright © 2018 orzer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class MVPView;
@interface MVPRouter : NSObject

+ (void)registView:(Class)viewClass forURL:(NSString*)url;
+ (__kindof MVPView*)viewForURL:(NSString*)url withUserInfo:(NSDictionary * __nullable)userInfo;

+ (void)registRouter;

@end

NS_ASSUME_NONNULL_END
