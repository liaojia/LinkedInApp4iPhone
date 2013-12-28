//
//  KeyValueModel.m
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-12-28.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "KeyValueModel.h"

@implementation KeyValueModel

@synthesize key = _key;
@synthesize value = _value;

-(void)setKey:(NSString *)key{
    _key = key;
    
}

-(void)setValue:(NSString *)value{
    _value = value;
}

-(NSString *)getKey{
    return _key;
}
@end
