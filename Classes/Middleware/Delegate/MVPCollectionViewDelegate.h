//
//  MVPCollectionViewDelegate.h
//  mvc-base
//
//  Created by 张超 on 2018/12/25.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPBaseMiddleware.h"
@import UIKit;
NS_ASSUME_NONNULL_BEGIN

@interface MVPCollectionViewDelegate : MVPBaseMiddleware <UICollectionViewDelegate>

@property (nonatomic, assign) BOOL dragHideKeyboard;

@end

NS_ASSUME_NONNULL_END
