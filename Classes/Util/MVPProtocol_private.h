//
//  MVCProtocol_private.h
//  mvc-base
//
//  Created by 张超 on 2018/12/20.
//  Copyright © 2018 orzer. All rights reserved.
//

#ifndef MVCProtocol_private_h
#define MVCProtocol_private_h

 
@protocol MVPPresenterProtocol_private <NSObject>

@optional
- (void)mvp_registActionName:(NSString*)name item:(id)item;
- (void)mvp_removeActionForItem:(id)item;
- (void)mvp_runAction:(NSString*)actionName;
- (void)mvp_runAction:(NSString*)actionName value:(id)value;

@end

#endif /* MVCProtocol_private_h */
