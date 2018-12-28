//
//  UIViewController+mvc_base.h
//  mvc-base
//
//  Created by 张超 on 2018/12/14.
//  Copyright © 2018 orzer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVPProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@class MVPInitModel;
@class MVPViewApperance;
@protocol MVPOutputProtocol,MVPInputProtocol,MVPPresenterProtocol_private;
@interface MVPView : UIViewController <MVPViewProtocol>
{
    
}

@property (nonatomic, strong, readonly) id<MVPPresenterProtocol,MVPPresenterProtocol_private> presenter;
- (void)mvp_configMiddleware NS_REQUIRES_SUPER;
- (UIBarButtonItem*)mvp_buttonItemWithActionName:(NSString*)name;

#pragma mark - config

- (void)mvp_bindData;
- (void)mvp_bindAction;
- (void)mvp_configTable;
- (void)mvp_configOther;


- (void)mvp_bindAction:(UIControlEvents)event target:(__kindof UIControl*)target actionName:(NSString*)name;
- (void)mvp_unbindAction:(UIControlEvents)event target:(__kindof UIControl*)target actionName:(NSString*)name;

@property (nonatomic, strong) __kindof id<MVPOutputProtocol> outputMiddleware;
@property (nonatomic, strong) __kindof id<MVPInputProtocol> inputMiddleware;
@property (nonatomic, strong) __kindof MVPViewApperance* apperMiddleware;

- (void)mvp_initFromModel:(MVPInitModel*)model;

- (instancetype)initWithUserInfo:(NSDictionary*)userinfo;


@end

NS_ASSUME_NONNULL_END
