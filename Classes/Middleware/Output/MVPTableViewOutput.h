//
//  TableViewOutput.h
//  mvc-base
//
//  Created by 张超 on 2018/12/17.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPBaseMiddleware.h"
#import "MVPOutputProtocol.h"
#import "MVPTableViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN
@class UINib;
@interface MVPTableViewOutput : MVPBaseMiddleware <MVPTableViewOutputProtocol>

- (void)mvp_registerNib:(nullable UINib *)nib forCellReuseIdentifier:(NSString *)identifier NS_AVAILABLE_IOS(5_0);
- (void)mvp_registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier NS_AVAILABLE_IOS(6_0);
@property (nonatomic, strong) MVPTableViewDelegate* delegate;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
- (void)mvp_bindTableRefreshActionName:(NSString*)name;
@property (nonatomic, assign) BOOL animation;
- (void)registNibCell:(NSString*)cell withIdentifier:(NSString*)identifier;
- (Class)tableviewClass;

@end

NS_ASSUME_NONNULL_END
