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
@interface MVPCollectViewOutput : MVPBaseMiddleware <MVPCollectionViewOutputProtocol>

- (__kindof UICollectionViewLayout*)collectionViewLayout;

@property (nonatomic, strong) MVPCollectionViewDelegate* delegate;

- (void)mvp_registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)mvp_registerNib:(nullable UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registNibCell:(NSString*)cell withIdentifier:(NSString*)identifier;
- (Class)collectionViewClass;


@end

NS_ASSUME_NONNULL_END
