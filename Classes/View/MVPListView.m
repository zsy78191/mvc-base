//
//  MVCListView.m
//  mvc-base
//
//  Created by 张超 on 2018/12/17.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPListView.h"
#import "MVPOutputProtocol.h"

@interface MVPListView ()
{
    
}



@property (nonatomic, strong) __kindof UIView* manageView;

@end

@implementation MVPListView

- (void)mvc_configMiddleware
{
    [super mvc_configMiddleware];
    self.inputMiddleware = [self.presenter mvp_inputerWithOutput:self.outputMiddleware];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.outputMiddleware) {
        __kindof UIView* v = [self.outputMiddleware outputView];
        if ([v isKindOfClass:[UITableView class]]) {
            self.manageView = v;
        }
    }
    
    if (self.inputMiddleware) {
        self.outputMiddleware.inputer = self.inputMiddleware;
        self.inputMiddleware.outputer = self.outputMiddleware;
    }
    
//    NSLog(@"%s",__func__);
//    NSLog(@"%@",self.inputMiddleware);
    [self.view addSubview:self.manageView];
    
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.manageView setFrame:self.view.bounds];
}



@end
