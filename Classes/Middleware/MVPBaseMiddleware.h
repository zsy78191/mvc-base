//
//  MVCBaseMiddleware.h
//  mvc-base
//
//  Created by 张超 on 2018/12/17.
//  Copyright © 2018 orzer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MVPPresenterProtocol;
@interface MVPBaseMiddleware : NSObject

@property (nonatomic, weak) id<MVPPresenterProtocol> presenter;

@end

NS_ASSUME_NONNULL_END
