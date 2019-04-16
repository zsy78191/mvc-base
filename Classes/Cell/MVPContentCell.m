//
//  MVPContentCell.m
//  mvc-base
//
//  Created by 张超 on 2018/12/24.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPContentCell.h"
@import ReactiveObjC;
#import "MVPCellBindProtocol.h"
#import "MVPOutputProtocol.h"
#import "MVPProtocol.h"
#import "MVPProtocol_private.h"
#import "MVPViewModel.h"
@import Masonry;

@interface MVPContentCell()
{
    
}

@property (nonatomic, strong) NSHashTable* table;
@property (nonatomic, strong) NSHashTable* actionTable;

@property (nonatomic, weak) id<MVPModelProtocol> model;

@end

@implementation MVPContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self mvp_setup];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self mvp_setup];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)mvp_setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)mvp_bindModel:(id<MVPModelProtocol>)model withProperties:(NSArray<NSString *> *)properties
{
//    NSLog(@"%s",__func__);
    [properties enumerateObjectsUsingBlock:^(NSString * _Nonnull keypath, NSUInteger idx, BOOL * _Nonnull stop) {
        RACSignal* s =
        [[[(id)model rac_valuesForKeyPath:keypath observer:self]
          takeUntil:[self rac_signalForSelector:@selector(prepareForReuse)]]
         takeUntil:[self rac_willDeallocSignal]];
        @weakify(self);
        RACDisposable* d = [s subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if ([self respondsToSelector:@selector(mvp_value:updateForKeypath:)]) {
                [(id)self mvp_value:x updateForKeypath:keypath];
            }
        } error:^(NSError * _Nullable error) {
            
        } completed:^{
            
        }];
        [self.table addObject:d];
    }];
}

- (NSHashTable *)table
{
    if (!_table) {
        _table = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:20];
    }
    return _table;
}

- (NSHashTable *)actionTable
{
    if (!_actionTable) {
        _actionTable = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsStrongMemory capacity:10];
    }
    return _actionTable;
}

- (void)cleanHook
{
    NSEnumerator* e = [self.table objectEnumerator];
    RACDisposable* d = [e nextObject];
    while (d) {
        [d dispose];
        d = [e nextObject];
    }
    [self.table removeAllObjects];
    
}

- (void)prepareForReuse
{
//    NSLog(@"%s",__func__);
    [super prepareForReuse];
    [self cleanHook];
//    id<MVPPresenterProtocol,MVPPresenterProtocol_private> presenter = [[model inputer] presenter];
//    UIViewController* vc = (UIViewController*)presenter.view;
    if ([self.model isKindOfClass:[MVPViewModel class]]) {
        MVPViewModel* m = self.model;
        UIViewController* vc2 = (UIViewController*)m.view;
        [vc2.view removeFromSuperview];
        [vc2 removeFromParentViewController];
    }
    
    self.model = nil;
}

- (void)mvp_bindGesture:(__kindof UIGestureRecognizer *)gesture
{
    [self.actionTable addObject:[gesture rac_gestureSignal]];
}

- (void)mvp_bindAction:(UIControlEvents)event target:(__kindof UIControl *)target actionName:(NSString *)name
{
    RACSignal* s = [[target rac_signalForControlEvents:event] map:^id _Nullable(__kindof UIControl * _Nullable value) {
        return RACTuplePack(value,name);
    }];
    [self.actionTable addObject:s];
}

- (void)loadModel:(id<MVPModelProtocol>)model
{
//     NSLog(@"%s",__func__);
    
    [self cleanHook];
    
    if ([model isMemberOfClass:[MVPViewModel class]]) {
        [self loadViewModel:model];
        return;
    }
    
    id<MVPPresenterProtocol,MVPPresenterProtocol_private> presenter = self.presenter;
    NSEnumerator* e = [self.actionTable objectEnumerator];
    RACSignal* s = [e nextObject];
    s = [[s takeUntil:[self rac_signalForSelector:@selector(prepareForReuse)]] takeUntil:[self rac_willDeallocSignal]];
    while(s){
        RACDisposable* d =  [s subscribeNext:^(id  _Nullable x) {
       
            if ([x isKindOfClass:[RACTuple class]]) {
                id value = x[0];
                NSString* actionName = x[1];
                [presenter mvp_runAction:actionName value:value];
            }
            else if([x isKindOfClass:[UIGestureRecognizer class]])
            {
                if ([presenter respondsToSelector:@selector(mvp_gestrue:model:)]) {
                    [presenter mvp_gestrue:x model:model];
                }
            }
            else {
                if ([presenter respondsToSelector:@selector(mvp_action_withModel:value:)]) {
                    [presenter mvp_action_withModel:model value:x];
                }
            }
        }];
        [self.table addObject:d];
        s = [e nextObject];
    }
    [self setModel:model];
}

- (void)loadViewModel:(__kindof MVPViewModel*)model
{
    id<MVPPresenterProtocol,MVPPresenterProtocol_private> presenter = [[model inputer] presenter];
    UIViewController* vc = (UIViewController*)presenter.view;
    UIViewController* vc2 = (UIViewController*)model.view;
 
    [vc addChildViewController:vc2];
    [self addSubview:vc2.view];
    [vc2.view setFrame:self.bounds];
    
    [vc2.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.height.equalTo(@(model.height));
    }];
    
    self.model = model;
}

- (void)mvp_value:(id)value updateForKeypath:(NSString *)keypath {

}

- (void)dealloc
{
    [self.actionTable removeAllObjects];
}

@end
