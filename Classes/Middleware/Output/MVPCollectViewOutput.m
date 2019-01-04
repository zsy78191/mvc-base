//
//  MVPCollectViewOutput.m
//  mvc-base
//
//  Created by 张超 on 2018/12/25.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPCollectViewOutput.h"
@import UIKit;
#import "MVPModel.h"
#import "MVPOutputProtocol.h"
@import DZNEmptyDataSet;
@interface MVPCollectViewOutput () <UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView* collectionView;
@end

@implementation MVPCollectViewOutput

- (MVPCollectionViewDelegate *)delegate
{
    if (!_delegate) {
        _delegate = [[MVPCollectionViewDelegate alloc] init];
    }
    return _delegate;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.dragHideKeyboard) {
        [scrollView endEditing:YES];
    }
}

- (id)collectionViewLayout
{
    return [[UICollectionViewFlowLayout alloc] init];
}


- (void)deleteAll
{
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self collectionViewLayout]];
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.pagingEnabled = NO;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressed:)];
        [_collectionView addGestureRecognizer:longPress];
    }
    return _collectionView;
}

- (void)onLongPressed:(UILongPressGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:sender.view];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    // 只允许第一区可移动
    if (indexPath.section != 0) {
        return;
    }
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self.collectionView updateInteractiveMovementTargetPosition:point];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self.collectionView endInteractiveMovement];
            break;
        }
        default: {
            [self.collectionView cancelInteractiveMovement];
            break;
        }
    }
}


- (void)beginUpdates {
    
}

- (void)deleleAtIndexPath:(NSIndexPath *)path {
    [self.collectionView deleteItemsAtIndexPaths:@[path]];
    [self updateEmpty];
}

- (void)deleteSectionAtIndex:(NSUInteger)idx {
    [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:idx]];
    [self updateEmpty];
}

- (void)endUpdates {
    
}

- (void)performBatchUpdates:(void (^)(void))updates completion:(void (^)(BOOL))completion
{
    [self.collectionView performBatchUpdates:updates completion:completion];
}

- (void)insertAtIndexPath:(NSIndexPath *)path {
    [self.collectionView insertItemsAtIndexPaths:@[path]];
    [self updateEmpty];
}

- (void)insertAtIndexPaths:(NSArray *)paths
{
    [self.collectionView insertItemsAtIndexPaths:paths];
    [self updateEmpty];
}

- (void)deleleAtIndexPaths:(NSArray *)paths
{
    [self.collectionView deleteItemsAtIndexPaths:paths];
    [self updateEmpty];
}

- (void)updateAtIndexPaths:(NSArray *)paths
{
    [self.collectionView reloadItemsAtIndexPaths:paths];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.canMove;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if ([self.inputer respondsToSelector:@selector(mvp_moveModelFromIndexPath:toPath:)]) {
        [self.inputer mvp_moveModelFromIndexPath:sourceIndexPath toPath:destinationIndexPath];
    }
}

- (void)insertSectionAtIndex:(NSUInteger)idx {
    [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:idx]];
    [self updateEmpty];
}

- (void)updateEmpty
{
    if ([self.inputer numberOfSections] == 1 || [self.inputer numberOfSections] == 0) {
        [self.collectionView reloadEmptyDataSet];
    }
    else if ([self.inputer mvp_count] == 1 || [self.inputer mvp_count] == 0) {
        [self.collectionView reloadEmptyDataSet];
    }
}

- (__kindof UIView *)outputView {
    
    self.collectionView.delegate = self.delegate;
    self.delegate.dragHideKeyboard = self.dragHideKeyboard;
    self.delegate.presenter = self.presenter;
    return self.collectionView;
}

- (void)setEmpty:(__kindof MVPEmptyMiddleware *)empty {
    [self.collectionView setEmptyDataSetSource:empty];
    [self.collectionView setEmptyDataSetDelegate:empty];
}

- (void)updateAtIndexPath:(NSIndexPath *)path {
    [self.collectionView reloadItemsAtIndexPaths:@[path]];
}

@synthesize inputer;


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (!self.inputer) {
        UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        return cell;
    }
    MVPModel* m = [self.inputer mvp_modelAtIndexPath:indexPath];
//    NSLog(@"1 %@",m);
    if (![self.inputer respondsToSelector:@selector(mvp_identifierForModel:)]) {
        NSLog(@"error presenter need add selector identifierForModel:");
        return [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    }
    NSString* identifier = [[self inputer] mvp_identifierForModel:m];
    __kindof UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(loadModel:)]) {
        [(id)cell loadModel:m];
    }
    return cell;
}

- (void)loadModel:(id<MVPModelProtocol>)model
{
 
}

- (void)mvp_registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
{
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)mvp_registerNib:(nullable UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;
{
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}



- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
     return self.inputer?[self.inputer numberOfRowsInSection:section]:1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.inputer?[self.inputer numberOfSections]:1;
}



@synthesize canMove;

@synthesize dragHideKeyboard;

@end
