//
//  AppInfoModel.h
//  mvc-base
//
//  Created by 张超 on 2018/12/24.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppInfoModel : MVPModel
@property (nonatomic, strong) NSString* appName;
@property (nonatomic, strong) NSString* appVersion;
@end

NS_ASSUME_NONNULL_END
