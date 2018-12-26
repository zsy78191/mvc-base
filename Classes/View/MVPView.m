//
//  UIViewController+mvc_base.m
//  mvc-base
//
//  Created by 张超 on 2018/12/14.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPView.h"
@import ReactiveObjC;
#import "MVPBaseMiddleware.h"
#import "MVPProtocol_private.h"
#import "MVPViewApperanceProtocol.h"
#import "MVPViewApperance.h"
#import "MVPSubview.h"
#import "MVPOutputProtocol.h"
//#import "MyItem.h"
@interface MVPView ()
@property (nonatomic, strong, readwrite) id<MVPPresenterProtocol,MVPPresenterProtocol_private> presenter;
@end

@implementation MVPView


- (instancetype)initWithUserInfo:(NSDictionary *)userinfo
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

void uibase_swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector);
 
+ (void)load
{
    uibase_swizzleMethod([MVPView class], @selector(viewDidLoad), @selector(viewDidLoad_mvcbase));
}

- (void)setInputMiddleware:(__kindof id<MVPInputProtocol>)inputMiddleware
{
    _inputMiddleware = inputMiddleware;
    [(MVPBaseMiddleware*)_inputMiddleware setPresenter:self.presenter];
}

- (void)setOutputMiddleware:(__kindof id<MVPOutputProtocol>)outputMiddleware
{
    _outputMiddleware = outputMiddleware;
    [(MVPBaseMiddleware*)_outputMiddleware setPresenter:self.presenter];
}

- (void)viewDidLoad_mvcbase;
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    id<MVPPresenterProtocol,MVPPresenterProtocol_private> p = [[[self mvp_presenterClass] alloc] init];
    self.presenter = p;
    p.view = self;
    
    if ([self respondsToSelector:@selector(mvc_configMiddleware)]) {
        [self mvc_configMiddleware];
    }
    
    [self viewDidLoad_mvcbase];
    
 
    
    if ([self respondsToSelector:@selector(mvc_configTable)]) {
        [self mvc_configTable];
    }
    
    if ([self respondsToSelector:@selector(mvc_configOther)]) {
        [self mvc_configOther];
    }
    
    if ([self respondsToSelector:@selector(mvc_bindData)]) {
        [self mvc_bindData];
    }
    
    if ([self respondsToSelector:@selector(mvc_bindAction)]) {
        [self mvc_bindAction];
    }
    
    self.view.tag = MVPViewTagContentView;
    
    if (self.apperMiddleware) {
        [self.apperMiddleware mvp_setupView:self.view];
    }
}

- (void)loadView
{
    self.view = ({
        MVPSubView* v = [[MVPSubView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [v setView:self];
        v;
    });
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if ([self.outputMiddleware respondsToSelector:@selector(setEditing:animated:)]) {
        [self.outputMiddleware setEditing:editing animated:animated];
    }
    
}

- (Class)mvp_presenterClass
{
    return NSClassFromString(@"MVCPresenter");
}

-(void)mvc_bindData
{
    
}

- (void)mvc_bindAction
{
    
}

- (void)mvc_configOther
{
    
}


- (void)mvc_configTable
{
    
}

- (void)mvc_configMiddleware
{
    
}

- (void)mvp_pushViewController:(__kindof UIViewController *)vc
{
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)mvp_popViewController:(__kindof UIViewController *)vc
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)mvp_showViewController:(__kindof UIViewController *)vc
{
    [self.navigationController showViewController:vc sender:nil];
}

- (void)mvp_presentViewController:(__kindof UIViewController *)vc animated:(BOOL)flag completion:(void (^)(void))completion
{
    [self presentViewController:vc animated:flag completion:completion];
}

- (void)mvp_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [self dismissViewControllerAnimated:flag completion:completion];
}

#pragma mark - action

- (void)mvc_action:(id)sender
{
    
}

- (UIBarButtonItem *)mvp_buttonItemWithActionName:(NSString *)name
{
    UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self.presenter action:@selector(mvc_action:)];
    [self.presenter mvp_registActionName:name item:b];
    return b;
}

- (void)mvp_bindAction:(UIControlEvents)event target:(__kindof UIControl*)target actionName:(nonnull NSString *)name
{
    [target addTarget:self.presenter action:@selector(mvc_action:) forControlEvents:event];
    [self.presenter mvp_registActionName:name item:target];
}

- (void)mvp_unbindAction:(UIControlEvents)event target:(__kindof UIControl *)target actionName:(NSString *)name
{
    [target removeTarget:self.presenter action:@selector(mvc_action:) forControlEvents:event];
    [self.presenter mvp_removeActionForItem:target];
}


@end
