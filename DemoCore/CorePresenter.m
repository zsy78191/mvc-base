//
//  CorePresenter.m
//  mvc-base
//
//  Created by 张超 on 2018/12/22.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "CorePresenter.h"
#import "CoreInput.h"
#import "CoreModel.h"
#import "Account+CoreDataProperties.h"
@interface CorePresenter ()
{
    
}
@property (nonatomic, strong) CoreInput* inputer;

@end

@implementation CorePresenter

- (Class)routerClass
{
    return NSClassFromString(@"CoreRouter");
}

- (id)mvp_inputerWithOutput:(id<MVPOutputProtocol>)output
{
    return self.inputer;
}

- (CoreInput *)inputer
{
    if (!_inputer) {
        _inputer = [[CoreInput alloc] init];
    }
    return _inputer;
}

- (void)addNew
{
    CoreModel* m = [[CoreModel alloc] init];
    m.name = @"1";
    [self.inputer mvp_addModel:m];
}

- (void)mvp_action_selectItemAtIndexPath:(NSIndexPath*)path
{
    [self.inputer mvp_deleteModelAtIndexPath:path];
}

@end
