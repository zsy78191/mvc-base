//
//  MVPScrollView.h
//  mvc-base
//
//  Created by 张超 on 2018/12/24.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPListView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 MVPTableView 仅支持一种Output，TableView
 */
@interface MVPTableView : MVPListView

@property (nonatomic) BOOL allowsSelection;

@end

NS_ASSUME_NONNULL_END
