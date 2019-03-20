//
//  MVPViewModel.h
//  mvc-base
//
//  Created by 张超 on 2018/12/26.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol MVPViewProtocol;
@interface MVPViewModel : MVPModel

@property (nonatomic, strong) id<MVPViewProtocol> view;
@property (nonatomic, assign) float height;

@end

NS_ASSUME_NONNULL_END
