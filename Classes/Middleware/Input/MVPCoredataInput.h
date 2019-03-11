//
//  MVPCoredataInput.h
//  mvc-base
//
//  Created by 张超 on 2018/12/22.
//  Copyright © 2018 orzer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVPBaseMiddleware.h"
#import "MVPOutputProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@class NSManagedObject;
@protocol MVPModelProtocol,NSFetchRequestResult;
@interface MVPCoredataInput : MVPBaseMiddleware <MVPCoreDataInputProtocol>

- (Class)mvp_modelClass;
- (void)loadCoreData:(__kindof NSManagedObject*)obj fromModel:(id<MVPModelProtocol>)model;

@end

NS_ASSUME_NONNULL_END
