//
//  MVPContentCell.h
//  mvc-base
//
//  Created by 张超 on 2018/12/24.
//  Copyright © 2018 orzer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVPCellBindProtocol.h"
NS_ASSUME_NONNULL_BEGIN


@protocol MVPModelProtocol;
@interface MVPContentCell : UITableViewCell <MVPCellBindProtocol>

- (void)mvp_bindModel:(id<MVPModelProtocol>)model withProperties:(NSArray<NSString*>*)properties;
- (void)mvp_bindGesture:(__kindof UIGestureRecognizer*)gesture;
- (void)mvp_bindAction:(UIControlEvents)event target:(__kindof UIControl*)target actionName:(NSString*)name;
- (void)loadModel:(id<MVPModelProtocol>)model NS_REQUIRES_SUPER;
@end

NS_ASSUME_NONNULL_END
