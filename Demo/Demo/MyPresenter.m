//
//  MyPresenter.m
//  mvc-base
//
//  Created by 张超 on 2018/12/14.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MyPresenter.h"
#import "Maininput.h"
#import "MyView.h"
#import "MyModel.h"



@interface MyPresenter()
{
    
}
@property (nonatomic, strong) MainInput* mainInput;

@end

@implementation MyPresenter

- (MainInput *)mainInput
{
    if (!_mainInput) {
        _mainInput = [[MainInput alloc] init];
    }
    return _mainInput;
}


- (id)mvp_inputerWithOutput:(id<MVPOutputProtocol>)output
{
    return self.mainInput;
}

- (void)addModel
{
    MyModel* m = [[MyModel alloc] init];
    m.name = [[NSDate date] description];
    [self.mainInput mvp_addModel:m];
}

- (void)cleanAll
{
    [self.mainInput mvp_cleanAll];
}

- (void)mvp_action_selectItemAtIndexPath:(NSIndexPath *)path
{
    [self.mainInput mvp_deleteModelAtIndexPath:path];
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

@end


@implementation model



@end
