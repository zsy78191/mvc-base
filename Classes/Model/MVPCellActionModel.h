//
//  MVPCellActionModel.h
//  mvc-base
//
//  Created by 张超 on 2019/3/20.
//  Copyright © 2019 orzer. All rights reserved.
//

#import "MVPModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MVPCellActionModel : MVPModel

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong, nullable) NSString* action;
@property (nonatomic, strong, nullable) UIColor* color;
@property (nonatomic, strong, nullable) UIImage* icon;


@end

NS_ASSUME_NONNULL_END
