//
//  KeyValueModel.h
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-12-28.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyValueModel : NSObject

@property(nonatomic, strong)    NSString *key;
@property(nonatomic, strong)    NSString *value;// 性别

-(NSString *)getKey;
@end
