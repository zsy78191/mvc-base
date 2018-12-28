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
@import DZNEmptyDataSet;
@interface MVPTableViewOutput () <UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (nonatomic, strong) UITableView* tableview;
@end

@implementation MVPTableViewOutput

- (void)loadModel:(id<MVPModelProtocol>)model
{
    
}



- (UITableView *)tableview
{
    if (!_tableview) {
        UITableView* table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        table.dataSource = self;
        [table setTableFooterView:[UIView new]];
        [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        UIRefreshControl *refreshController = [[UIRefreshControl alloc] init];

        self.refreshControl = refreshController;

        _tableview = table;
    }
    return _tableview;
}

- (void)mvp_bindTableRefreshActionName:(NSString *)name
{
    [self.refreshControl addTarget:self.presenter action:NSSelectorFromString(name) forControlEvents:UIControlEventValueChanged];
    [self.tableview addSubview:self.refreshControl];
}


#pragma mark - Handle Refresh Method

-(void)handleRefresh : (id)sender
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
    self.tableview.delegate = self.delegate;
    self.delegate.dragHideKeyboard = self.dragHideKeyboard;
    if (self.dragHideKeyboard) {
//        [self.tableview setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    }
    self.delegate.presenter = self.presenter;
    return self.tableview;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (!self.inputer) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        return cell;
    }
    MVPModel* m = [self.inputer mvp_modelAtIndexPath:indexPath];
    NSString* identifier = [[self inputer] mvp_identifierForModel:m];
    __kindof UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ([cell respondsToSelector:@selector(loadModel:)]) {
        [(id)cell loadModel:m];
    }
    return cell;
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
//    NSIndexPath* i = [NSIndexPath indexPathForRow:idx inSection:0];
    [self.tableview insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self updataEmpty];
}

- (void)deleleAtIndexPath:(NSIndexPath *)path
{
//    NSIndexPath* i = [NSIndexPath indexPathForRow:idx inSection:0];
    [self.tableview deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self updataEmpty];
}


- (void)updateAtIndexPath:(NSIndexPath *)path
{
//    NSIndexPath* i = [NSIndexPath indexPathForRow:idx inSection:0];
    [self.tableview reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    [self.tableview deleteSections:[NSIndexSet indexSetWithIndex:idx] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self updataEmpty];
}


- (void)insertSectionAtIndex:(NSUInteger)idx {
    [self.tableview insertSections:[NSIndexSet indexSetWithIndex:idx] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self updataEmpty];
}

- (void)setEmpty:(__kindof MVPEmptyMiddleware *)empty {
    [self.tableview setEmptyDataSetSource:empty];
    [self.tableview setEmptyDataSetDelegate:empty];
}

- (void)deleleAtIndexPaths:(NSArray *)paths {
    [self.tableview deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self updataEmpty];
}

- (void)updataEmpty
{
    if ([self.inputer mvp_count] == 1 || [self.inputer mvp_count] == 0) {
        [self.tableview reloadEmptyDataSet];
    }
    else if ([self.inputer numberOfSections] == 1 || [self.inputer numberOfSections] == 0) {
        [self.tableview reloadEmptyDataSet];
    }
}


- (void)insertAtIndexPaths:(NSArray *)paths {
    [self.tableview insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self updataEmpty];
}


- (void)updateAtIndexPaths:(NSArray *)paths {
     [self.tableview reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [[self tableview] setEditing:editing animated:animated];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
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



@synthesize inputer;

@synthesize canMove;

@synthesize dragHideKeyboard;

@end
