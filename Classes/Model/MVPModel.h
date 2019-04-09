//
//  MVCModel.h
//  mvc-base
//
//  Created by 张超 on 2018/12/14.
//  Copyright © 2018 orzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVPProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@class MVPModel;
typedef void (^MVPModelInitailBlock)(__kindof MVPModel*);
typedef __kindof MVPModel* _Nullable (^MVPModelNewInstanceBlock)(MVPModelInitailBlock);

@interface MVPModel : NSObject <MVPModelProtocol>

- (BOOL)same:(id)v1 with:(id)v2;
@property (nonatomic, readonly, class) MVPModelNewInstanceBlock m;

@end

NS_ASSUME_NONNULL_END
