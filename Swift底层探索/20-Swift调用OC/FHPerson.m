//
//  FHPerson.m
//  20-Swift调用OC
//
//  Created by wangfh on 2020/3/16.
//  Copyright © 2020 wangfh. All rights reserved.
//

#import "FHPerson.h"
#import "_0_Swift调用OC-Swift.h"

@implementation FHPerson

- (instancetype)initWithAge:(NSInteger)age name:(NSString *)name {
    NSLog(@"1");
    if (self = [super init]) {
        self.age = age;
        self.name = name;
    }
    return self;
}

+ (instancetype)personWithAge:(NSInteger)age name:(NSString *)name {
    NSLog(@"2");
    return [[self alloc] initWithAge:age name:name];
}

+ (void)run {
    NSLog(@"Person +run");
}

- (void)run {
    NSLog(@"%zd %@ -run", _age, _name);
}

+ (void)eat:(NSString *)food other:(NSString *)other {
    NSLog(@"Person +eat %@ %@", food, other);
}

- (void)eat:(NSString *)food other:(NSString *)other {
    NSLog(@"%zd %@ -eat %@ %@", _age, _name, food, other);
}

@end

int sum(int a, int b) {
    return a + b;
}

//测试OC调用Swift的代码
void testSwift(void) {
    FHCar *car = [[FHCar alloc] initWithPrice:11.1 band:@"人民银行"];
    car.name = @"建设银行";
    [car test];   //11.1 建设银行 test   使用Swift的函数在OC里调用,其实走的也是objc_msgsend那套流程
    [car drive];  //11.1 建设银行 run
    [FHCar run];  //Car run
    [car test];   //11.1 建设银行 test
}




