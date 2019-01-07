//
//  DVPresenter.m
//  mvc-base
//
//  Created by 张超 on 2018/12/24.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "DMPresenter.h"
#import "DMInput.h"
#import "AppInfoModel.h"
#import "MVPViewModel.h"

@import ui_base;
@interface DMPresenter()
{
    
}
@property (nonatomic, strong) DMInput* inputer;

@end

@implementation DMPresenter

- (DMInput *)inputer
{
    if (!_inputer) {
        _inputer = [[DMInput alloc] init];
    }
    return _inputer;
}

- (id)mvp_inputerWithOutput:(id<MVPOutputProtocol>)output
{
    return self.inputer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        AppInfoModel* app = [[AppInfoModel alloc] init];
        app.appName = UIApplication.sharedApplication.bundleDispalyName();
        app.appVersion =  UIApplication.sharedApplication.buildVersion();
        [self.inputer mvp_addModel:app];

        MVPViewModel* m = [[MVPViewModel alloc] init];
        m.view = [MVPRouter viewForURL:@"demo://democollectionview" withUserInfo:@{}];
        m.height = 120;
        [self.inputer mvp_addModel:m];
        
        self.testCount = 0;
        
        [self.router regiestTarget:self selector:@selector(testString) asStaticRouter:@"demo://getTestString2"];
    }
    return self;
}

- (void)dealloc
{
    
}

- (NSString*)testString
{

    return @"321";
}

- (void)mvp_action_selectItemAtIndexPath:(NSIndexPath *)path
{
   
}

- (void)mvp_action_withModel:(id<MVPModelProtocol>)model value:(id)value
{
    if ([model isKindOfClass:[AppInfoModel class]]) {
        NSLog(@"%@",value);
    }
}

- (void)actionEdit
{
    NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
    AppInfoModel* m = [self.inputer mvp_modelAtIndexPath:path];
    
    self.testCount ++;
    m.appVersion = [@(self.testCount) description];
}


- (void)mvp_initFromModel:(MVPInitModel *)model
{
    NSLog(@"%@",model);
}

- (void)actionBtn:(id)sender
{
    NSLog(@"%@",sender);
    NSLog(@"%@",[self.router valueForRouterURL:@"demo://getTestString2"]);
}

- (void)mvp_gestrue:(__kindof UIGestureRecognizer *)gesture model:(id<MVPModelProtocol>)model
{
    NSLog(@"%@",gesture);
}



- (id)asd
{
    return @(YES);
}

@end
