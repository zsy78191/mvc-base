//
//  MVPCellBindProtocol.h
//  mvc-base
//
//  Created by 张超 on 2018/12/25.
//  Copyright © 2018 orzer. All rights reserved.
//

#ifndef MVPCellBindProtocol_h
#define MVPCellBindProtocol_h

@protocol MVPModelProtocol;
@protocol MVPCellBindProtocol <NSObject>

@required
- (void)mvp_value:(id)value updateForKeypath:(NSString*)keypath;
- (void)loadModel:(id<MVPModelProtocol>)model;

@end

#endif /* MVPCellBindProtocol_h */
