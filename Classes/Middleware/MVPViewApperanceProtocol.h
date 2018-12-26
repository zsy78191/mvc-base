//
//  MVPViewApperanceProtocol.h
//  mvc-base
//
//  Created by 张超 on 2018/12/25.
//  Copyright © 2018 orzer. All rights reserved.
//

#ifndef MVPViewApperanceProtocol_h
#define MVPViewApperanceProtocol_h
@class UIView;
@protocol MVPViewApperanceProtocol <NSObject>

@required
- (void)mvp_setupView:(__kindof UIView*)view;

@end

#endif /* MVPViewApperanceProtocol_h */
