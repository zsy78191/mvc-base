//
//  TableViewOutput.m
//  mvc-base
//
//  Created by 张超 on 2018/12/17.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPTableViewOutput.h"
@import UIKit;
#import "MVPModel.h"
#import "MVPContentCell.h"
@import DZNEmptyDataSet;
@import oc_string;
#import "MVPProtocol_private.h"

@interface MVPTableViewOutput () <UITableViewDelegate,UITableViewDataSource>
{
    
}
//@property (nonatomic, strong) UITableView* tableview;
@property (nonatomic, assign) BOOL scrollToTopWhenInsert;
@end

@implementation MVPTableViewOutput

- (void)loadModel:(id<MVPModelProtocol>)model
{
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.animation = NO;
    }
    return self;
}

- (Class)tableviewClass
{
    return [UITableView class];
}

- (void)registNibCell:(NSString *)cell withIdentifier:(NSString *)identifier
{
    [[self tableview] registerNib:[UINib nibWithNibName:cell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identifier];
}


- (UITableView *)tableview
{
    if (!_tableview) {
        UITableView* table = [[[self tableviewClass] alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        table.dataSource = self;
        [table setTableFooterView:[UIView new]];
        [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableview = table;
    }
    return _tableview;
}

- (void)mvp_bindTableRefreshActionName:(NSString *)name
{
    [self.refreshControl addTarget:self.presenter action:NSSelectorFromString(name) forControlEvents:UIControlEventValueChanged];
//    [self.tableview addSubview:self.refreshControl];
    self.tableview.refreshControl = self.refreshControl;
}

- (UIRefreshControl *)refreshControl
{
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
 
    }
    return _refreshControl;
}


#pragma mark - Handle Refresh Method

- (void)handleRefresh:(id)sender
{
    
}

- (MVPTableViewDelegate *)delegate
{
    if (!_delegate) {
        _delegate = [[MVPTableViewDelegate alloc] init];
    }
    return _delegate;
}

- (UIView *)outputView
{
    self.tableview.delegate = self;
    return self.tableview;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (!self.inputer) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        return cell;
    }
    MVPModel* m = [self.inputer mvp_modelAtIndexPath:indexPath];
    NSString* identifier = nil;
    if ([[self inputer] respondsToSelector:@selector(mvp_identifierForModel:)]) {
        NSString* idf = [[self inputer] mvp_identifierForModel:m];
        if (idf) {
            identifier = idf;
        }
    }
    if (!identifier) {
        identifier = [m cell_identifier];
    }
    __kindof UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ([cell isKindOfClass:[MVPContentCell class]]) {
        [(MVPContentCell*)cell setPresenter:self.inputer.presenter];
    }
    if ([cell respondsToSelector:@selector(loadModel:)]) {
        [(id)cell loadModel:m];
    }
    return cell;
}

- (void)setRegistBlock:(void (^)(id))registBlock
{
    _registBlock = registBlock;
    if (registBlock) {
        registBlock(self);
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"%@",self.inputer);
    return self.inputer?[self.inputer numberOfRowsInSection:section]:1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSLog(@"%@",self.inputer);
    return self.inputer?[self.inputer numberOfSections]:1;
}

- (void)insertAtIndexPath:(NSIndexPath *)path
{
    [self insertAtIndexPaths:@[path]];
}

- (void)deleleAtIndexPath:(NSIndexPath *)path
{
//    NSIndexPath* i = [NSIndexPath indexPathForRow:idx inSection:0];
    [self.tableview deleteRowsAtIndexPaths:@[path] withRowAnimation:[self currentAnimation:path action:@"delete"]];
    [self updataEmpty];
}

- (void)moveFromIndexPath:(NSIndexPath *)fidx toIndexPath:(NSIndexPath *)tidx
{
    [self.tableview moveRowAtIndexPath:fidx toIndexPath:tidx];
}

- (void)setScrollToTopWhenInsert:(BOOL)scrollToTopWhenInsert
{
    _scrollToTopWhenInsert = scrollToTopWhenInsert;
    if (_scrollToTopWhenInsert) {
        _scrollToInsertPosition = NO;
    }
}

- (void)setScrollToInsertPosition:(BOOL)scrollToBottomWhenInsert
{
    _scrollToInsertPosition = scrollToBottomWhenInsert;
    if (_scrollToInsertPosition) {
        _scrollToTopWhenInsert = NO;
    }
}

@synthesize scrollToTopWhenInsert = _scrollToTopWhenInsert;
@synthesize scrollToInsertPosition = _scrollToInsertPosition;


- (UITableViewRowAnimation)currentAnimation:(id)index action:(NSString*)action
{
    UITableViewRowAnimation a = UITableViewRowAnimationAutomatic;
    if (self.animationBlock) {
        a = self.animationBlock(action,index);
    }
    return self.animation?a:UITableViewRowAnimationNone;
}

- (void)updateAtIndexPath:(NSIndexPath *)path
{
//    NSIndexPath* i = [NSIndexPath indexPathForRow:idx inSection:0];
    [self.tableview reloadRowsAtIndexPaths:@[path] withRowAnimation:[self currentAnimation:path action:@"update"]];
}

- (void)mvp_registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier
{
    [self.tableview registerNib:nib forCellReuseIdentifier:identifier];
}

- (void)mvp_registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier
{
    [self.tableview registerClass:cellClass forCellReuseIdentifier:identifier];
}

- (void)beginUpdates
{
    [self.tableview beginUpdates];
}

- (void)endUpdates
{
    [self.tableview endUpdates];
}

- (void)deleteSectionAtIndex:(NSUInteger)idx {
    [self.tableview deleteSections:[NSIndexSet indexSetWithIndex:idx] withRowAnimation:[self currentAnimation:@(idx) action:@"delete"]];
    [self updataEmpty];
}


- (void)deleteAll
{
    [self.tableview reloadData];
}

- (void)insertSectionAtIndex:(NSUInteger)idx {
    [self.tableview insertSections:[NSIndexSet indexSetWithIndex:idx] withRowAnimation:[self currentAnimation:@(idx) action:@"insert"]];
    [self updataEmpty];
}

- (void)setEmpty:(__kindof MVPEmptyMiddleware *)empty {
    [self.tableview setEmptyDataSetSource:empty];
    [self.tableview setEmptyDataSetDelegate:empty];
}

- (void)deleleAtIndexPaths:(NSArray *)paths {
    [self.tableview deleteRowsAtIndexPaths:paths withRowAnimation:[self currentAnimation:paths action:@"delete"]];
    [self updataEmpty];
}

- (void)updataEmpty
{
    if ([self.inputer mvp_count] == 1 || [self.inputer mvp_count] == 0) {
        [self.tableview reloadEmptyDataSet];
    }
}


- (void)insertAtIndexPaths:(NSArray *)paths {
    if (self.tableview.decelerating) {
        [self.tableview insertRowsAtIndexPaths:paths withRowAnimation:[self currentAnimation:paths action:@"insert"]];
    }
    else {
        [self.tableview setContentOffset:self.tableview.contentOffset animated:NO];
        [self.tableview insertRowsAtIndexPaths:paths withRowAnimation:[self currentAnimation:paths action:@"insert"]];
        if (self.scrollToInsertPosition) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.14 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableview scrollToRowAtIndexPath:[paths firstObject] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            });
        }
        
    }
    [self updataEmpty];
}


- (void)updateAtIndexPaths:(NSArray *)paths {
     [self.tableview reloadRowsAtIndexPaths:paths withRowAnimation:[self currentAnimation:paths action:@"update"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [[self tableview] setEditing:editing animated:animated];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.leadActionsArrays.count == 0  && self.actionsArrays.count == 0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if ([self.inputer respondsToSelector:@selector(mvp_moveModelFromIndexPath:toPath:)]) {
        [self.inputer mvp_moveModelFromIndexPath:sourceIndexPath toPath:destinationIndexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.canMove;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.presenter respondsToSelector:@selector(mvp_action_selectItemAtIndexPath:)]) {
        [self.presenter mvp_action_selectItemAtIndexPath:indexPath];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.dragHideKeyboard) {
        [scrollView endEditing:YES];
    }
}

- (void)enableAnimation
{
    self.animation = YES;
}

- (void)disableAnimation
{
    self.animation = NO;
}

- (void)reloadData
{
    [self.tableview reloadData];
}

- (NSMutableArray<MVPCellActionModel *> *)actionsArrays
{
    if (!_actionsArrays) {
        _actionsArrays = [[NSMutableArray alloc] init];
    }
    return _actionsArrays;
}

- (NSMutableArray<MVPCellActionModel *> *)leadActionsArrays
{
    if (!_leadActionsArrays) {
        _leadActionsArrays = [[NSMutableArray alloc] init];
    }
    return _leadActionsArrays;
}

- (NSArray<UITableViewRowAction *> *)actions
{
    NSArray* t = self.actionsArrays.filter(^BOOL(MVPCellActionModel*  _Nonnull x) {
        return x.icon == nil;
    });
    if (t.count == 0) {
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    return
    t.map(^id _Nonnull(MVPCellActionModel*  _Nonnull x) {
        UITableViewRowAction* action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:x.title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [weakSelf.presenter mvp_runAction:x.action value:indexPath];
        }];
        if (x.color) {
            action.backgroundColor = x.color;
        }
        return action;
    });
}

- (NSArray<UIContextualAction *> *)tailActions:(NSIndexPath*)indexPath
{
    NSMutableArray* t = self.actionsArrays;
    if (self.actionArraysBeforeUseBlock) {
        t = self.actionArraysBeforeUseBlock(t,[self.inputer mvp_modelAtIndexPath:indexPath]);
    }
    if (t.count == 0) {
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    return
    t.map(^id _Nonnull(MVPCellActionModel*  _Nonnull x) {
        UIContextualAction* action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:x.title handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.presenter mvp_runAction:x.action value:indexPath];
            });
            
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.24 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            completionHandler(NO);
            //            });
        }];
        if (x.color) {
            action.backgroundColor = x.color;
        }
        if (x.icon) {
            action.image = x.icon;
        }
        return action;
    });
}

- (NSArray<UIContextualAction *> *)leadActions:(NSIndexPath*)indexPath
{
    NSMutableArray* t = self.leadActionsArrays;
    if (self.leadActionsArraysBeforeUseBlock) {
        t = self.leadActionsArraysBeforeUseBlock(t,[self.inputer mvp_modelAtIndexPath:indexPath]);
    }
    if (t.count == 0) {
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    return
    t.map(^id _Nonnull(MVPCellActionModel*  _Nonnull x) {
        UIContextualAction* action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:x.title handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.presenter mvp_runAction:x.action value:indexPath];
            });
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.24 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            completionHandler(NO);
            //            });
        }];
        if (x.color) {
            action.backgroundColor = x.color;
        }
        if (x.icon) {
            action.image = x.icon;
        }
        return action;
    });
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self actions];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* a = [self tailActions:indexPath];
    if (a.count == 0) {
        return nil;
    }
    return [UISwipeActionsConfiguration configurationWithActions:a];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* a = [self leadActions:indexPath];
    if (a.count == 0) {
        return nil;
    }
    return [UISwipeActionsConfiguration configurationWithActions:a];
}

@synthesize inputer;

@synthesize canMove;

@synthesize dragHideKeyboard;

@synthesize tableview = _tableview;

@synthesize registBlock = _registBlock;

@end
