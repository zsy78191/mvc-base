//
//  MVCListView.m
//  mvc-base
//
//  Created by 张超 on 2018/12/17.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPListView.h"
#import "MVPOutputProtocol.h"
#import "MVPViewApperanceProtocol.h"
#import "MVPViewApperance.h"
@interface MVPListView ()
{
    
}

@property (nonatomic, strong) __kindof UIView* manageView;


@end

@implementation MVPListView

- (void)mvc_configMiddleware
{
    [super mvc_configMiddleware];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.presenter respondsToSelector:@selector(mvp_inputerWithOutput:)]) {
         self.inputMiddleware = [self.presenter mvp_inputerWithOutput:self.outputMiddleware];
    }
    else {
        NSLog(@"warning %@ did not has selector [mvp_inputerWithOutput:]",self.presenter);
    }
    
    if (self.outputMiddleware) {
        __kindof UIView* v = [self.outputMiddleware outputView];
        if ([v isKindOfClass:[UITableView class]] || [v isKindOfClass:[UICollectionView class]]) {
            self.manageView = v;
        }
    }
    else {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        label.text = @"没有设置Outputer";
        [label setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:label];
        label.center = self.view.center;
    }
    
    if (self.inputMiddleware) {
        self.outputMiddleware.inputer = self.inputMiddleware;
        self.inputMiddleware.outputer = self.outputMiddleware;
    }
    
    if (self.empty) {
        [self.outputMiddleware setEmpty:self.empty];
    }
    
//    NSLog(@"%s",__func__);
//    NSLog(@"%@",self.inputMiddleware);
    self.manageView.tag = MVPViewTagManageView;
    [self.view addSubview:self.manageView];
    
//    if (self.apperMiddleware) {
//        [self.apperMiddleware mvp_setupView:self.manageView];
//    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.manageView setFrame:self.view.bounds];
}



@end
