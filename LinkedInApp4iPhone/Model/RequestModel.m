//
//  RequestModel.m
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-11.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "RequestModel.h"

@implementation RequestModel

@synthesize requestId = _requestId;
@synthesize url = _url;
@synthesize method = _method;

-(RequestModel*)initWithId:(NSString*)requestId url:(NSString*)url method:(NSString*)method{
    _requestId = requestId;
    _url = url;
    _method = method;
    
    return self;
}
@end
