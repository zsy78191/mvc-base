//
//  MVPOutputProtocol.g.h
//  mvc-base
//
//  Created by 张超 on 2018/12/18.
//  Copyright © 2018 orzer. All rights reserved.
//

#ifndef MVPOutputProtocol_g_h
#define MVPOutputProtocol_g_h

NS_ASSUME_NONNULL_BEGIN

@class UIView,UITableView,UICollectionView;
@class MVPEmptyMiddleware;
@protocol MVPOutputProtocol,MVPModelProtocol,MVPPresenterProtocol,MVPPresenterProtocol_private;
@protocol MVPInputProtocol <NSObject>

- (NSUInteger)numberOfSections;
- (NSUInteger)numberOfRowsInSection:(NSUInteger)section;
- (id)allModels;

@required

- (NSUInteger)mvp_addModel:(id<MVPModelProtocol>)model;
- (NSUInteger)mvp_insertModel:(id<MVPModelProtocol>)model atIndex:(NSUInteger)idx;
- (NSIndexPath*)mvp_indexPathWithModel:(id<MVPModelProtocol>)model;
- (BOOL)containsModel:(id<MVPModelProtocol>)model;
- (id<MVPModelProtocol>)mvp_deleteModelAtIndexPath:(NSIndexPath*)path;
- (void)mvp_deleteModel:(id<MVPModelProtocol>)model;
- (void)mvp_updateModel:(id<MVPModelProtocol>)model atIndexPath:(NSIndexPath*)path;
- (void)mvp_moveModelFromIndexPath:(NSIndexPath*)path1 toPath:(NSIndexPath*)path2;
- (void)mvp_cleanAll;
- (id<MVPModelProtocol>)mvp_modelAtIndexPath:(NSIndexPath*)path;
- (NSUInteger)mvp_count;
@property (nonatomic, weak) id<MVPOutputProtocol> outputer;
@property (nonatomic, weak) id<MVPPresenterProtocol,MVPPresenterProtocol_private> presenter;
@property (nonatomic, assign) NSUInteger complexSection;

@optional
- (nullable NSString*)mvp_identifierForModel:(id<MVPModelProtocol>)model;

@end

@protocol MVPCoreDataInputProtocol <MVPInputProtocol>

@optional
- (NSArray<NSSortDescriptor *> *) sortDescriptors;
- (NSPredicate*)predicate;
- (NSString*)sectionKeyPath;
- (NSUInteger)fetchLimitCount; //defalut is 0 ，no limit
- (void)rebuildFetch;

@end

@protocol MVPOutputProtocol <NSObject>

- (__kindof UIView*)outputView;
@property (nonatomic, weak) id<MVPInputProtocol> inputer;
@property (nonatomic, assign) BOOL canMove;

@property (nonatomic, assign) BOOL scrollToInsertPosition;
@property (nonatomic, assign) BOOL dragHideKeyboard;

- (void)enableAnimation;
- (void)disableAnimation;

- (void)beginUpdates;
- (void)endUpdates;
- (void)reloadData;

- (void)insertAtIndexPath:(NSIndexPath*)path;
- (void)deleleAtIndexPath:(NSIndexPath*)path;
- (void)updateAtIndexPath:(NSIndexPath*)path;
- (void)insertAtIndexPaths:(NSArray*)paths;
- (void)deleleAtIndexPaths:(NSArray*)paths;
- (void)updateAtIndexPaths:(NSArray*)paths;

- (void)deleteAll;

- (void)insertSectionAtIndex:(NSUInteger)idx;
- (void)deleteSectionAtIndex:(NSUInteger)idx;
- (void)setEmpty:(__kindof MVPEmptyMiddleware*)empty;

- (void)moveFromIndexPath:(NSIndexPath*)fidx toIndexPath:(NSIndexPath*)tidx;

@property (nonatomic, strong) void(^registBlock)(id output);
- (void)registNibCell:(NSString*)cell withIdentifier:(NSString*)identifier;

@optional
- (void)performBatchUpdates:(void (^ _Nullable)(void))updates completion:(void (^ _Nullable)(BOOL finished))completion;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

@end

@protocol MVPTableViewOutputProtocol <MVPOutputProtocol>
@property (nonatomic, strong) UITableView* tableview;
@end

@protocol MVPCollectionViewOutputProtocol <MVPOutputProtocol>
@property (nonatomic, strong) UICollectionView* collectionView;
@end

NS_ASSUME_NONNULL_END

#endif /* MVPOutputProtocol_g_h */


