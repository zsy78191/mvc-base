//
//  MVPSubView.h
//  mvc-base
//
//  Created by 张超 on 2018/12/25.
//  Copyright © 2018 orzer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVPView.h"
NS_ASSUME_NONNULL_BEGIN

@interface MVPSubView : UIView

@property (nonatomic, weak) MVPView* view;
@end

NS_ASSUME_NONNULL_END
