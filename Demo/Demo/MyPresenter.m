//
//  MyPresenter.m
//  mvc-base
//
//  Created by 张超 on 2018/12/14.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MyPresenter.h"
#import "Maininput.h"
#import "MVPComplexInput.h"
#import "CoreInput.h"
#import "MyView.h"
#import "MyModel.h"



@interface MyPresenter()
{
    
}
@property (nonatomic, strong) MainInput* mainInput;
@property (nonatomic, strong) CoreInput* coreInput;
@property (nonatomic, strong) MVPComplexInput* ci;
@property (nonatomic, strong) NSString* testString;
@end

@implementation MyPresenter

- (MainInput *)mainInput
{
    if (!_mainInput) {
        _mainInput = [[MainInput alloc] init];
    }
    return _mainInput;
}


- (CoreInput *)coreInput
{
    if (!_coreInput) {
        _coreInput = [[CoreInput alloc] init];
    }
    return _coreInput;
}

- (MVPComplexInput *)ci
{
    if (!_ci) {
        _ci = [[MVPComplexInput alloc] init];
    }
    return _ci;
}


- (id)mvp_inputerWithOutput:(id<MVPOutputProtocol>)output
{
    [self.ci addInput:self.coreInput];
    [self.ci addInput:self.mainInput];
    return self.ci;
}

- (void)addModel
{
    MyModel* m = [[MyModel alloc] init];
    m.name = [[NSDate date] description];
    [self.mainInput mvp_addModel:m];
}

- (void)cleanAll
{
    [self.ci mvp_cleanAll];
}

- (void)mvp_action_selectItemAtIndexPath:(NSIndexPath *)path
{
    [self.ci mvp_deleteModelAtIndexPath:path];
}

- (void)openCore
{
//    CoreListView* view = [[CoreListView alloc] init];
    id view = [MVPRouter viewForURL:@"demo://corelistview" withUserInfo:@{@"a":@(1)}];
    [self.view mvp_pushViewController:view];
}

- (void)openCore2
{
    //    CoreListView* view = [[CoreListView alloc] init];
    id view = [MVPRouter viewForURL:@"demo://democollectionview" withUserInfo:@{@"type":@"collection"}];
    [self.view mvp_pushViewController:view];
}


- (void)openUI
{
    id view = [MVPRouter viewForURL:@"demo://demoui?asd=123" withUserInfo:@{@"a":@(1)}];
    [self.view mvp_pushViewController:view];
}

- (void)openCollectionView:(id)a
{
    id view = [MVPRouter viewForURL:@"demo://democollectionview" withUserInfo:nil];
    [self.view mvp_pushViewController:view];
}

- (void)refreshData:(UIRefreshControl*)control
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [control endRefreshing];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@",@(animated));
}

- (void)mvp_gestrue:(__kindof UIGestureRecognizer *)gesture
{
    NSLog(@"%@",gesture);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self.router regiestTarget:self selector:@selector(testString) asRouter:@"demo://getTestString"];
        self.testString = @"123";
        
        
    }
    return self;
}

- (void)testRouterURL
{
    NSLog(@"%@",[self.router valueForRouterURL:@"demo://getTestString2"]);
}

@end


@implementation model



@end
