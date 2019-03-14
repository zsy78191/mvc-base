//
//  DCView.m
//  mvc-base
//
//  Created by 张超 on 2018/12/25.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "DCView.h"
#import "MVPCollectViewOutput.h"
#import "DCApper.h"
#import "DCOutput.h"
@interface DCView ()
{
}
@property (nonatomic, strong) NSString* type;
@end

@implementation DCView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIBarButtonItem* i = [self mvp_buttonItemWithActionName:@"addNew"];
    i.title = @"添加";
    self.navigationItem.rightBarButtonItems = @[i,self.editButtonItem];
}

- (instancetype)initWithUserInfo:(NSDictionary *)userinfo
{
    self = [super initWithUserInfo:userinfo];
    if (self) {
        NSDictionary* d = userinfo[@"MGJRouterParameterUserInfo"];
        self.type = [d valueForKey:@"type"];
    }
    return self;
}

- (Class)mvp_outputerClass
{
    if ([self.type isEqualToString:@"collection"]) {
        return NSClassFromString(@"DCOutput");
    }
    return NSClassFromString(@"MVPCollectViewOutput");
}

- (void)mvp_configMiddleware
{
    [super mvp_configMiddleware];
    
    if ([self.type isEqualToString:@"collection"]) {
        DCOutput* o = (id)self.outputer;
        [o mvp_registerNib:[UINib nibWithNibName:@"DCCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CoreCell"];
    }
    else {
        MVPCollectViewOutput* o = (id)self.outputer;
        [o mvp_registerNib:[UINib nibWithNibName:@"DCCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    }

    self.appear = [[DCApper alloc] init];
    self.empty = [[MVPEmptyMiddleware alloc] init];
}

- (Class)mvp_presenterClass
{
    return NSClassFromString(@"DCPresenter");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
