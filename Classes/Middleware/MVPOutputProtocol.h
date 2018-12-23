//
//  MVPOutputProtocol.g.h
//  mvc-base
//
//  Created by 张超 on 2018/12/18.
//  Copyright © 2018 orzer. All rights reserved.
//

#ifndef MVPOutputProtocol_g_h
#define MVPOutputProtocol_g_h
@class UIView;
//@class MVCModel;
@protocol MVPOutputProtocol,MVPModelProtocol;
@protocol MVPInputProtocol <NSObject>

- (NSUInteger)numberOfSections;
- (NSUInteger)numberOfRowsInSection:(NSUInteger)section;



@required
- (Class)mvp_modelClass;
- (NSUInteger)mvp_addModel:(id<MVPModelProtocol>)model;
- (NSUInteger)mvp_insertModel:(id<MVPModelProtocol>)model atIndex:(NSUInteger)idx;
- (id<MVPModelProtocol>)mvp_deleteModelAtIndexPath:(NSIndexPath*)path;
- (void)mvp_updateModel:(id<MVPModelProtocol>)model atIndexPath:(NSIndexPath*)path;
- (id<MVPModelProtocol>)mvp_modelAtIndexPath:(NSIndexPath*)path;
- (NSUInteger)mvp_count;
@property (nonatomic, weak) id<MVPOutputProtocol> outputer;

@optional
- (NSString*)identifierForModel:(id<MVPModelProtocol>)model;
- (NSArray<NSSortDescriptor *> *) sortDescriptors;
- (NSPredicate*)predicate;



@end

@protocol MVPOutputProtocol <NSObject>

- (__kindof UIView*)outputView;
@property (nonatomic, weak) id<MVPInputProtocol> inputer;

- (void)beginUpdates;
- (void)endUpdates;
- (void)insertAtIndexPath:(NSIndexPath*)path;
- (void)deleleAtIndexPath:(NSIndexPath*)path;
- (void)updateAtIndexPath:(NSIndexPath*)path;

- (void)insertSectionAtIndex:(NSUInteger)idx;
- (void)deleteSectionAtIndex:(NSUInteger)idx;
@end

#endif /* MVPOutputProtocol_g_h */
