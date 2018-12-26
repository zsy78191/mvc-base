//
//  MVPViewApperance.h
//  mvc-base
//
//  Created by 张超 on 2018/12/25.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPBaseMiddleware.h"
#import "MVPViewApperanceProtocol.h"
@import UIKit;

typedef enum : NSUInteger {
    MVPViewTagManageView = 0x89ab1,
    MVPViewTagContentView = 0x89ab2,
} MVPViewTag;

NS_ASSUME_NONNULL_BEGIN

@interface MVPViewApperance : MVPBaseMiddleware <MVPViewApperanceProtocol>

@end

NS_ASSUME_NONNULL_END
