//
//  ViewController.m
//  mvc-base
//
//  Created by 张超 on 2018/12/14.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MyView.h"
@import CoreData;
#import "MVPTableViewOutput.h"
#import "MVPArrayInput.h"
#import "MyEmpty.h"
#import "MVPCellActionModel.h"
@interface MyView ()  
{
    
}
 

@end

@implementation MyView


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.rightBarButtonItem = ;
//    self.navigationItem.rightBarButtonItem.title = @"添加";
    
    
    
    UIBarButtonItem* item = [self mvp_buttonItemWithActionName:@"addModel"];
    [item setTitle:@"添加"];
    UIBarButtonItem* item2 = [self mvp_buttonItemWithActionName:@"openCore"];
    [item2 setTitle:@"Coredata"];
    UIBarButtonItem* item6 = [self mvp_buttonItemWithActionName:@"cleanAll"];
    [item6 setTitle:@"全部删除"];
    self.navigationItem.rightBarButtonItems = @[item,self.editButtonItem,item6];
 
    UIBarButtonItem* item3 = [self mvp_buttonItemWithActionName:@"openUI"];
    [item3 setTitle:@"列表视图UI"];
    self.navigationItem.leftBarButtonItem = item3;
    
    UIBarButtonItem* item4 = [self mvp_buttonItemWithActionName:@"openCollectionView:"];
    [item4 setTitle:@"C测试"];
    
    UIBarButtonItem* item5 = [self mvp_buttonItemWithActionName:@"openCore2"];
    [item5 setTitle:@"CC测试"];
    
   
    
    [[self navigationController] setToolbarHidden:NO];
    
    [self mvp_bindSelector:@selector(viewWillAppear:)];
    
    
    UIBarButtonItem* item7 = [self mvp_buttonItemWithActionName:@"testRouterURL"];
    item7.title = @"router测试";
     self.toolbarItems = @[item4,item2,item5,item7];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}



- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (Class)mvp_presenterClass
{
    return NSClassFromString(@"MyPresenter");
}

- (Class)mvp_outputerClass
{
    return NSClassFromString(@"MVPTableViewOutput");
}

#pragma mark - mvc

- (void)mvp_configMiddleware
{
    [super mvp_configMiddleware];
    MVPTableViewOutput* o = (id)self.outputer;
    [o mvp_registerNib:[UINib nibWithNibName:@"MyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyCell"];
    [o mvp_registerClass:NSClassFromString(@"CoreCell") forCellReuseIdentifier:@"CoreCell"];
    [o setCanMove:YES];
    [o setScrollToInsertPosition:YES];
    [o mvp_bindTableRefreshActionName:@"refreshData:"];
    
   
    [o.actionsArrays addObject: MVPCellActionModel.m(^(__kindof MVPCellActionModel * _Nonnull m) {
        m.title = @"1";
        m.color = [UIColor blueColor];
    })];
    
    [o.actionsArrays addObject: MVPCellActionModel.m(^(__kindof MVPCellActionModel * _Nonnull m) {
        m.title = @"\u267A \n2";
        m.action = @"actionDel:";
        m.color = [UIColor clearColor];
    })];
    
    [o.leadActionsArrays addObject: MVPCellActionModel.m(^(__kindof MVPCellActionModel * _Nonnull m) {
        m.title = @"\u267A \n2";
        m.action = @"actionDel:";
        m.color = [UIColor clearColor];
    })];
    
    [o setLeadActionsArraysBeforeUseBlock:^NSMutableArray * _Nonnull(NSMutableArray * _Nonnull actionsArrays, id  _Nonnull model) {
        NSLog(@"%@",model);
        return [@[] mutableCopy];
    }];
//    [self setAllowsSelection:NO];
//    self.empty = [[MyEmpty alloc] init];
}

- (void)mvp_bindAction
{
    UILongPressGestureRecognizer* l = [[UILongPressGestureRecognizer alloc] initWithTarget:nil action:nil];
    [[self view] addGestureRecognizer:l];
    [self mvp_bindGesture:l];
}

#pragma mark - lazy

@end
