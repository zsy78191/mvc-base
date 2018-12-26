//
//  DMView.m
//  mvc-base
//
//  Created by 张超 on 2018/12/24.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "DMView.h"
#import "MVPTableViewOutput.h"
#import "DMApperance.h"
@interface DMView ()

@end

@implementation DMView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem* item = [self mvp_buttonItemWithActionName:@"actionEdit"];
    [item setTitle:@"修改测试"];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.presenter mvp_bindBlock:^(id view, id value) {
//        NSLog(@"%@",value);
        DMView* v = view;
        v.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"修改 %@",value];
    } keypath:@"testCount"];
    
}

- (Class)mvp_presenterClass
{
    return NSClassFromString(@"DMPresenter");
}

- (void)mvc_configMiddleware
{
    [super mvc_configMiddleware];
    
    MVPTableViewOutput* o = [[MVPTableViewOutput alloc] init];
    self.outputMiddleware = o;
    
    [o mvp_registerNib:[UINib nibWithNibName:@"AppTitleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AppTitleCell"];
    [o mvp_registerClass:NSClassFromString(@"MVPContentCell") forCellReuseIdentifier:@"Cell"];
    
    self.apperMiddleware = [[DMApperance alloc] init];
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
