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
    self.navigationItem.rightBarButtonItems = @[item,item2];
 
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
 
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (Class)mvc_presenterClass
{
    return NSClassFromString(@"MyPresenter");
}

#pragma mark - mvc

- (void)mvc_configMiddleware
{
    [super mvc_configMiddleware];
    MVPTableViewOutput* o = [[MVPTableViewOutput alloc] init];
    [o mvp_registerNib:[UINib nibWithNibName:@"MyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyCell"];
    self.outputMiddleware = o;
    
    self.empty = [[MVPEmptyMiddleware alloc] init];
}


#pragma mark - lazy

@end
