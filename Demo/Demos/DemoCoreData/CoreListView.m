//
//  CoreListView.m
//  mvc-base
//
//  Created by 张超 on 2018/12/22.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "CoreListView.h"
#import "MVPTableViewOutput.h"

@interface CoreListView ()
{
}
@property (nonatomic, strong) NSString* type;
@end

@implementation CoreListView

- (instancetype)initWithUserInfo:(NSDictionary *)userinfo
{
    self = [super initWithUserInfo:userinfo];
    if (self) {
//        NSLog(@"%@",userinfo);

        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem* i = [self mvp_buttonItemWithActionName:@"addNew"];
    [i setTitle:@"add"];
    self.navigationItem.rightBarButtonItem = i;
}

- (Class)mvp_presenterClass
{
    return NSClassFromString(@"CorePresenter");
}

- (Class)mvp_outputerClass
{
    return NSClassFromString(@"MVPTableViewOutput");
}

- (void)mvp_configMiddleware
{
    [super mvp_configMiddleware];
    
    MVPTableViewOutput* o = (id)self.outputer;
    [o mvp_registerClass:NSClassFromString(@"CoreCell") forCellReuseIdentifier:@"CoreCell"];
    
    self.empty = [[MVPEmptyMiddleware alloc] init];
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
