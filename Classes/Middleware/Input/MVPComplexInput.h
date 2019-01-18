//
//  MVPComplexInput.h
//  mvc-base
//
//  Created by 张超 on 2019/1/8.
//  Copyright © 2019 orzer. All rights reserved.
//

#import "MVPBaseMiddleware.h"
#import "MVPOutputProtocol.h"
NS_ASSUME_NONNULL_BEGIN


/**
 组合其他Input使用的Input，当组合CoredataInput时，CoredataInput必须提供单section数据
 */
@interface MVPComplexInput : MVPBaseMiddleware <MVPInputProtocol>
{
    
}
- (void)addInput:(id<MVPInputProtocol>)input;
- (void)deleteInput:(id<MVPInputProtocol>)input;
- (id<MVPInputProtocol>)inputerAtIndexPath:(NSIndexPath*)path;

@end

NS_ASSUME_NONNULL_END
