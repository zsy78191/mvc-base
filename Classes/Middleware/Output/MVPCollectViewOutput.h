//
//  MVPCollectViewOutput.h
//  mvc-base
//
//  Created by 张超 on 2018/12/25.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPBaseMiddleware.h"
#import "MVPOutputProtocol.h"
#import "MVPCollectionViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN
@class UICollectionViewLayout;
@interface MVPCollectViewOutput : MVPBaseMiddleware <MVPOutputProtocol>

- (__kindof UICollectionViewLayout*)collectionViewLayout;

@property (nonatomic, strong) MVPCollectionViewDelegate* delegate;

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(nullable UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;


@end

NS_ASSUME_NONNULL_END