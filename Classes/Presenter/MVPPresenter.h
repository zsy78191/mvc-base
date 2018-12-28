//
//  MVCPresenter.h
//  mvc-base
//
//  Created by 张超 on 2018/12/14.
//  Copyright © 2018 orzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVPProtocol.h"
#import "MVPRouter.h"
NS_ASSUME_NONNULL_BEGIN
@class MVPInitModel;
@interface MVPPresenter : NSObject <MVPPresenterProtocol>

- (Class)routerClass;
@property (nonatomic, strong) __kindof MVPRouter* router;


@end

NS_ASSUME_NONNULL_END
