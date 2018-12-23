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
        _tableview = table;
    }
    return _tableview;
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
    self.delegate.presenter = self.presenter;
    return self.tableview;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (!self.inputer) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        return cell;
    }
    MVPModel* m = [self.inputer mvp_modelAtIndexPath:indexPath];
    NSString* identifier = [[self inputer] identifierForModel:m];
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
}

- (void)deleleAtIndexPath:(NSIndexPath *)path
{
//    NSIndexPath* i = [NSIndexPath indexPathForRow:idx inSection:0];
    [self.tableview deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
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
}


- (void)insertSectionAtIndex:(NSUInteger)idx {
    [self.tableview insertSections:[NSIndexSet indexSetWithIndex:idx] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}


@synthesize inputer;

@end
