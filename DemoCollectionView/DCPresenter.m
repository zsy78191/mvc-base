//
//  DCPresenter.m
//  mvc-base
//
//  Created by 张超 on 2018/12/25.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "DCPresenter.h"
#import "DCInput.h"
#import "CoreModel.h"
#import "DCColor.h"
#import "CoreInput.h"
#import "CoreModel.h"
@interface DCPresenter()
{
    
}
@property (nonatomic, strong) DCInput* inputer;
@property (nonatomic, strong) CoreInput* inputerCore;
@end

@implementation DCPresenter

- (DCInput *)inputer
{
    if (!_inputer) {
        _inputer = [[DCInput alloc] init];
    }
    return _inputer;
}

- (CoreInput *)inputerCore
{
    if (!_inputerCore) {
        _inputerCore = [[CoreInput alloc] init];
    }
    return _inputerCore;
}

- (id)mvp_inputerWithOutput:(id<MVPOutputProtocol>)output
{
    if ([output isKindOfClass:NSClassFromString(@"DCOutput")]) {
        return self.inputerCore;
    }
    return self.inputer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        DCColor* c = [[DCColor alloc] init];
        c.colorName = @"bgColor";
        NSUInteger x = [self.inputer mvp_addModel:c];
        NSLog(@"%ld",x);
        
        DCColor* c1 = [[DCColor alloc] init];
        c1.colorName = @"mainColor";
        NSUInteger x2 = [self.inputer mvp_addModel:c1];
        NSLog(@"%ld",x2);
        NSLog(@"%@",[self.inputer allModels]);
        
    }
    return self;
}

- (void)addNew
{
    CoreModel* m = [[CoreModel alloc] init];
    m.name = @"asd";
    [self.inputerCore mvp_addModel:m];
}



@end
