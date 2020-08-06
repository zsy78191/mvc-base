//
//  MyPresenter.h
//  mvc-base
//
//  Created by 张超 on 2018/12/14.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPPresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface model : NSObject
@property (nonatomic, strong) NSString* name;
@end

@interface MyPresenter : MVPPresenter

@property (nonatomic, strong) NSString* txt;
@property (nonatomic, strong) NSString* txt2;
@property (nonatomic, strong) model* model;
@property (nonatomic, strong) NSArray* result;
@property (nonatomic, strong) NSMutableArray* some;

@end

NS_ASSUME_NONNULL_END
