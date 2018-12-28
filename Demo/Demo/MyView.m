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
    self.navigationItem.rightBarButtonItems = @[item,self.editButtonItem];
 
    UIBarButtonItem* item3 = [self mvp_buttonItemWithActionName:@"openUI"];
    [item3 setTitle:@"列表视图UI"];
    self.navigationItem.leftBarButtonItem = item3;
    
    UIBarButtonItem* item4 = [self mvp_buttonItemWithActionName:@"openCollectionView:"];
    [item4 setTitle:@"CollectionView"];
    
    UIBarButtonItem* item5 = [self mvp_buttonItemWithActionName:@"openCore2"];
    [item5 setTitle:@"CollectionViewCore"];
    
    self.toolbarItems = @[item4,item2,item5];
    
    [[self navigationController] setToolbarHidden:NO];
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
    MVPTableViewOutput* o = self.outputer;
    [o mvp_registerNib:[UINib nibWithNibName:@"MyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyCell"];
    [o setCanMove:YES];
    [o mvp_bindTableRefreshActionName:@"refreshData:"];
    self.empty = [[MyEmpty alloc] init];
}

#pragma mark - lazy

@end
