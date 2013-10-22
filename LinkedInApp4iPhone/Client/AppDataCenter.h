

#import <Foundation/Foundation.h>

@class RequestModel;

@interface AppDataCenter : NSObject
{


}

@property (nonatomic, strong) NSArray                              *requestParamList;

@property (nonatomic, strong)NSString *version;
@property (nonatomic, strong)NSString *sid;
@property (nonatomic, strong)NSString *clientId;

+ (AppDataCenter *) sharedAppDataCenter;

- (RequestModel*) getModelWithRequestId:(NSString*) name;



@end
