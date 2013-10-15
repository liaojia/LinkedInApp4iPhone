

#import <Foundation/Foundation.h>
@class RequestModel;
@interface AppDataCenter : NSObject
{
    

}

@property (nonatomic, strong) NSArray                              *requestParamList;


+ (AppDataCenter *) sharedAppDataCenter;

- (RequestModel*) getModelWithRequestId:(NSString*) name;



@end
