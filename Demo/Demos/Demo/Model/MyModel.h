//
//  MyModel.h
//  mvc-base
//
//  Created by 张超 on 2018/12/19.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyModel : MVPModel

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* title;

@end

NS_ASSUME_NONNULL_END
