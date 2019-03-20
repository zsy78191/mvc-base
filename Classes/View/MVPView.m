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
#import "MVPInitModel.h"
@import ui_base;

//#import "MyItem.h"
@interface MVPView ()
@property (nonatomic, strong, readwrite) id<MVPPresenterProtocol,MVPPresenterProtocol_private> presenter;
@property (nonatomic, strong, readwrite) id<MVPOutputProtocol> outputer;
@end

@implementation MVPView

- (Class)mvp_outputerClass
{
    return NSClassFromString(@"MVPTableViewOutput");
}

@synthesize outputer = _outputer;

- (__kindof id<MVPOutputProtocol>)outputer
{
    if (!_outputer) {
        _outputer = [[[self mvp_outputerClass] alloc] init];
        [(MVPBaseMiddleware*)_outputer setPresenter:self.presenter];
    }
    return _outputer;
}

- (void)mvp_initFromModel:(MVPInitModel *)model
{
    
}

- (instancetype)initWithUserInfo:(NSDictionary *)userinfo
{
    self = [super init];
    if (self) {
        MVPInitModel* m = [[MVPInitModel alloc] initWithMJDictionary:userinfo];
        if ([self respondsToSelector:@selector(mvp_initFromModel:)]) {
            [self mvp_initFromModel:m];
        }
        if ([self.presenter respondsToSelector:@selector(mvp_initFromModel:)]) {
            [self.presenter mvp_initFromModel:m];
        }
    }
    return self;
}

void uibase_swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector);
 
+ (void)load
{
    uibase_swizzleMethod([MVPView class], @selector(viewDidLoad), @selector(viewDidLoad_mvcbase));
}

- (void)setInputer:(__kindof id<MVPInputProtocol>)inputMiddleware
{
    _inputer = inputMiddleware;
    [(MVPBaseMiddleware*)_inputer setPresenter:self.presenter];
}

- (void)setOutputer:(__kindof id<MVPOutputProtocol>)outputMiddleware
{
    _outputer = outputMiddleware;
    [(MVPBaseMiddleware*)_outputer setPresenter:self.presenter];
}


- (id<MVPPresenterProtocol,MVPPresenterProtocol_private>)presenter
{
    if (!_presenter) {
        _presenter = [[[self mvp_presenterClass] alloc] init];
        _presenter.view = self;
    }
    return _presenter;
}

- (void)viewDidLoad_mvcbase;
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if ([self respondsToSelector:@selector(mvp_configMiddleware)]) {
        [self mvp_configMiddleware];
    }
    
    [self viewDidLoad_mvcbase];
    
 
    if ([self respondsToSelector:@selector(mvp_configTable)]) {
        [self mvp_configTable];
    }
    
    if ([self respondsToSelector:@selector(mvp_configOther)]) {
        [self mvp_configOther];
    }
    
    if ([self respondsToSelector:@selector(mvp_bindData)]) {
        [self mvp_bindData];
    }
    
    if ([self respondsToSelector:@selector(mvp_bindAction)]) {
        [self mvp_bindAction];
    }
    
    self.view.tag = MVPViewTagContentView;
    
    if (self.appear) {
        [self.appear mvp_setupView:self.view];
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
    if ([self.outputer respondsToSelector:@selector(setEditing:animated:)]) {
        [self.outputer setEditing:editing animated:animated];
    }
    
}

- (Class)mvp_presenterClass
{
    return NSClassFromString(@"MVPPresenter");
}

-(void)mvp_bindData
{
   
}

- (void)mvp_bindAction
{
    
}

- (void)mvp_configOther
{
    
}


- (void)mvp_configTable
{
    
}

- (void)mvp_configMiddleware
{
    
}

- (void)mvp_reloadData
{
    [self.outputer reloadData];
}

- (void)mvp_runAction:(SEL)selector
{
    if ([self respondsToSelector:selector]) {
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(self, selector);
    }
    else {
        NSLog(@"%@ can't responds To Selector %@",self,NSStringFromSelector(selector));
    }
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

- (UIBarButtonItem *)mvp_buttonItemWithActionName:(NSString *)name title:(nonnull NSString *)title
{
    UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self.presenter action:@selector(mvc_action:)];
    b.accessibilityLabel = title;
    [self.presenter mvp_registActionName:name item:b];
    return b;
}

- (UIBarButtonItem*)mvp_buttonItemWithSystem:(UIBarButtonSystemItem)systemItem actionName:(NSString *)name title:(NSString *)title
{
    UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self.presenter action:@selector(mvc_action:)];
    b.title = title;
    b.accessibilityLabel = title;
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

- (void)mvp_bindGesture:(__kindof UIGestureRecognizer *)gesture
{
    id<MVPPresenterProtocol> presenter = self.presenter;
    [[[gesture rac_gestureSignal] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        if ([presenter respondsToSelector:@selector(mvp_gestrue:)]) {
            [presenter mvp_gestrue:x];
        }
    }];
}

- (void)mvp_bindSelector:(SEL)selector
{
    [[self rac_signalForSelector:selector] subscribeNext:^(RACTuple * _Nullable x) {
        if ([self.presenter respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.presenter performSelector:selector withObject:x];
#pragma clang diagnostic pop
        }
        else
        {
            NSLog(@"warning presenter %@ didn't have selector named %@",self.presenter,NSStringFromSelector(selector));
        }
    }];
}


@end
