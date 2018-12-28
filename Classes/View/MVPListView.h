//
//  MVCListView.h
//  mvc-base
//
//  Created by 张超 on 2018/12/17.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPView.h"
#import "MVPEmptyMiddleware.h"
NS_ASSUME_NONNULL_BEGIN

/**
 MVPListView 支持两种Outputer，TableView和CollectionView
 */
@interface MVPListView : MVPView

@property (nonatomic, strong) MVPEmptyMiddleware* empty;


@end

NS_ASSUME_NONNULL_END
