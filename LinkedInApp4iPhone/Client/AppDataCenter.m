//
//  AppDataCenter.m
//  POS2iPhone
//
//  Created by  STH on 11/28/12.
//  Copyright (c) 2012 RYX. All rights reserved.
//

#import "AppDataCenter.h"
#import "Transfer.h"
#import "Transfer+ParseXML.h"
#import "RequestModel.h"

@interface AppDataCenter ()

@end

@implementation AppDataCenter

static AppDataCenter *instance = nil;

/*
 synchronized   这个主要是考虑多线程的程序，这个指令可以将{ } 内的代码限制在一个线程执行，如果某个线程没有执行完，其他的线程如果需要执行就得等着。
 */
+ (AppDataCenter *) sharedAppDataCenter
{
    @synchronized(self)
    {
        if (nil == instance) {
            instance = [[AppDataCenter alloc] init];

        }
    }
    
    
    return instance;
}

- (RequestModel*) getModelWithRequestId:(NSString*) name{
    NSArray *array = [Transfer paseRequestParamXML];
    for (RequestModel* model in array) {
        if ([model.requestId isEqualToString:name]) {
            return model;
        }
    }
    return nil;
}

/*
 是从制定的内存区域读取信息创建实例，所以如果需要的单例已经有了，就需要禁止修改当前单例。所以返回 nil
 */
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    
    return nil;
}


@end
