//
//  MVCProtocol.h
//  mvc-base
//
//  Created by 张超 on 2018/12/14.
//  Copyright © 2018 orzer. All rights reserved.
//

#ifndef MVCProtocol_h
#define MVCProtocol_h

//@protocol MVPTupleProtocol <NSObject>
//
//- (NSArray *)allObjects;
//@property (nonatomic, readonly, nullable) id first;
//@property (nonatomic, readonly, nullable) id second;
//@property (nonatomic, readonly, nullable) id third;
//@property (nonatomic, readonly, nullable) id fourth;
//@property (nonatomic, readonly, nullable) id fifth;
//@property (nonatomic, readonly, nullable) id last;
//@property (nonatomic, readonly) NSUInteger count;
//
//@end

@protocol MVPViewProtocol,MVPOutputProtocol,MVPInputProtocol;
@class UIViewController,MVPInitModel;

@protocol MVPModelProtocol <NSObject>

- (NSArray *)propertys;
@property (nonatomic, weak) id<MVPInputProtocol> inputer;

@end

@protocol MVPPresenterProtocol <NSObject>


@property (nonatomic, weak) id<MVPViewProtocol> view;

- (void)mvp_initFromModel:(MVPInitModel*)model;

- (void)mvp_bindItem:(id)item propertyName:(NSString *)name keypath:(NSString*)keypath;
- (void)mvp_bindBlock:(void (^)(id view,id value))block keypath:(NSString*)keypath;
- (void)mvp_bindChangeBlock:(void (^)(id view,id value,id add,id remove,id modify))block keypath:(NSString*)keypath;


#pragma mark - action
- (void)mvp_action_selectItemAtIndexPath:(NSIndexPath*)path;
- (void)mvp_action_withModel:(id<MVPModelProtocol>)model value:(id)value;


@required
- (id)mvp_inputerWithOutput:(id<MVPOutputProtocol>)output;


@end

@protocol MVPViewProtocol <NSObject>

- (void)mvp_pushViewController:(__kindof UIViewController*)vc;
- (void)mvp_popViewController:(__kindof UIViewController*)vc;
- (void)mvp_showViewController:(__kindof UIViewController*)vc;
- (void)mvp_presentViewController:(__kindof UIViewController*)vc animated: (BOOL)flag completion:(void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0);
- (void)mvp_dismissViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0);;

@required
- (Class)mvp_presenterClass;

@end
 

#endif /* MVCProtocol_h */
