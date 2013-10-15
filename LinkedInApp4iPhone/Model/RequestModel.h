//
//  RequestModel.h
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-11.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestModel : NSObject

@property(nonatomic, strong)NSString *requestId;
@property(nonatomic, strong)NSString *url;
@property(nonatomic, strong)NSString *method;


-(RequestModel*)initWithId:(NSString*)requestId url:(NSString*)url method:(NSString*)method;
@end
