//
//  mvc_baseTests.m
//  mvc-baseTests
//
//  Created by 张超 on 2018/12/14.
//  Copyright © 2018 orzer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MVPModel.h"
#import "MVPArrayInput.h"
@interface mvc_baseTests : XCTestCase

@end

@implementation mvc_baseTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testa
{
    MVPModel* m  = [[MVPModel alloc] init];
    MVPModel* m2  = [[MVPModel alloc] init];
    MVPModel* m3  = [[MVPModel alloc] init];
    MVPModel* m4  = [[MVPModel alloc] init];
    NSLog(@"%@",m);
    NSLog(@"%@",m2);
    NSLog(@"%@",m3);
    NSLog(@"%@",m4);
    
    
    MVPArrayInput* a = [[MVPArrayInput alloc] init];
    [a mvp_addModel:m];
    [a mvp_addModel:m2];
    [a mvp_addModel:m3];
    [a mvp_addModel:m4];
    
    [[a allModels] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",obj);
    }];
}

/**
 测试model是否相等
 */
- (void)atestForModelSame {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    MVPModel* m  = [[MVPModel alloc] init];
    
    NSString* s1 = @"123";
    NSString* s2 = [@"123456" stringByReplacingOccurrencesOfString:@"456" withString:@""];
    XCTAssertTrue([m same:s1 with:s2]);
    
    NSNumber* n1 = @(1.15);
    NSNumber* n2 = @(1.1500);
    XCTAssertTrue([m same:n1 with:n2]);
    
    NSNumber* n3 = @(1.15);
    NSNumber* n4 = @(1.1501);
    XCTAssertFalse([m same:n3 with:n4]);
    
    NSDate* d1 = [NSDate date];
    NSDate* d2 = [NSDate date];
    XCTAssertTrue([m same:d1 with:d2]);
    
    NSDate* d3 = [[NSDate date] dateByAddingTimeInterval:10];
    NSDate* d4 = [[[NSDate date] dateByAddingTimeInterval:20] dateByAddingTimeInterval:-10];
    XCTAssertTrue([m same:d3 with:d4]);
    
    NSDate* d5 = [[NSDate date] dateByAddingTimeInterval:10];
    NSDate* d6 = [[NSDate date] dateByAddingTimeInterval:11];
    XCTAssertFalse([m same:d5 with:d6]);

}
//
//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
