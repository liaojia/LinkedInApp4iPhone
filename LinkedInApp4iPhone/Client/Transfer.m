//
//  Transfer.m
//  LKOA4iPhone
//
//  Created by  STH on 7/27/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "Transfer.h"
#import "Transfer+ParseXML.h"
#import "MProgressAlertView.h"
#import "Reachability.h"
#import "FileManagerUtil.h"
#import "RequestModel.h"
//#import "ShowContentViewController.h"
//#import "GTMNSString+HTML.h"

#define KB      (1024.0)
#define MB      (1024.0 * 1024.0)

@implementation Transfer

@synthesize downloadOperation = _downloadOperation;
@synthesize downloadFileName = _downloadFileName;

static Transfer *instance = nil;
static AFHTTPClient *client = nil;
static NSString *totalSize = nil;

+ (Transfer *) sharedTransfer
{
    @synchronized(self)
    {
        if (nil == instance) {
            instance = [[Transfer alloc] init];
        }
    }
    
    return instance;
}

// 该方法只用于修正在登录界面修改IP时只有将程序彻底关掉后才能起作用的BUG。
+ (void) resetClient
{
    client = nil;
}

+ (AFHTTPClient *) sharedClient
{
    if (nil == client) {
        NSURL *url = [[NSURL alloc] initWithString:DEFAULTHOST];
        client = [[AFHTTPClient alloc] initWithBaseURL:url];
    }
    
    return client;
}

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

- (void) doQueueByOrder:(NSArray *) operationList
          completeBlock:(QueueCompleteBlock) completeBlock
{
    isCancelAction = NO;
    
    [[Transfer sharedClient].operationQueue setMaxConcurrentOperationCount:1];
    [[Transfer sharedClient].operationQueue setName:@"doQueueByOrder"];
    
    for (int i=0; i< [operationList count] - 1; i++) {
        [[operationList objectAtIndex:i+1] addDependency:[operationList objectAtIndex:i]];
    }
    
    [[Transfer sharedClient] enqueueBatchOfHTTPRequestOperations:operationList progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {
        [SVProgressHUD dismiss];
        
        if (completeBlock) {
            completeBlock(operations);
        }
    }];
}

- (void) doQueueByTogether:(NSArray *) operationList
                    prompt:(NSString *) prompt
             completeBlock:(QueueCompleteBlock) completeBlock
{
    isCancelAction = NO;
    
    if (prompt) {
//        [SVProgressHUD showWithStatus:prompt maskType:SVProgressHUDMaskTypeClear];
        
        
         [SVProgressHUD showWithStatus:prompt maskType:SVProgressHUDMaskTypeClear cancelBlock:^(id sender){
             NSLog(@"用户取消操作...");
             isCancelAction = YES;
             [[Transfer sharedClient].operationQueue cancelAllOperations];
             [[Transfer sharedClient] cancelAllHTTPOperationsWithMethod:@"POST" path:DEFAULTHOST];
             
             [SVProgressHUD dismiss];
             
         }];
         
    }
    
    [[Transfer sharedClient].operationQueue setMaxConcurrentOperationCount:[operationList count]];
    [[Transfer sharedClient].operationQueue setName:@"doQueueByTogether"];
    
    [[Transfer sharedClient] enqueueBatchOfHTTPRequestOperations:operationList progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {
       // [SVProgressHUD dismiss];
        
        if (completeBlock) {
            completeBlock(operations);
        }
        
    }];
}

/**
    不要直接使用该方法的返回值调用start方法执行联网请求。而是使用上面的队列方式来请求数据。。。
    
    如果使用doQueueByTogether则prompt失效
 
 **/


- (AFHTTPRequestOperation *) TransferWithRequestDic:(NSDictionary *)reqDic
                                           requesId:(NSString *)requesId
                                             prompt:(NSString *) prompt
                                          replaceId:(NSString *)replaceId
                                            success:(SuccessBlock) success
                                            failure:(FailureBlock) failure


{
    return [self TransferWithRequestDic:reqDic
                               requesId:requesId
                                 prompt:prompt
                              replaceId:replaceId
                             alertError:YES
                                success:^(id obj) {
                                 success(obj);
                             } failure:^(NSString *errMsg) {
                                 failure(errMsg);
                             }];
}

- (AFHTTPRequestOperation *) TransferWithRequestDic:(NSDictionary *) reqDic
                                           requesId:(NSString *) requestId
                                             prompt:(NSString *) prompt
                                          replaceId:(NSString *)replaceId
                                         alertError:(BOOL) alertError
                                            success:(SuccessBlock) success
                                            failure:(FailureBlock) failure
{
    if (![self checkNetAvailable]) {
        [SVProgressHUD dismiss];
        return nil;
    }
    
    RequestModel *requestModel = [[AppDataCenter sharedAppDataCenter] getModelWithRequestId:requestId];
    if (prompt && [[Transfer sharedClient].operationQueue.name isEqualToString:@"doQueueByOrder"]) {
        [SVProgressHUD showWithStatus:prompt maskType:SVProgressHUDMaskTypeClear];
        
        [SVProgressHUD showWithStatus:prompt maskType:SVProgressHUDMaskTypeClear cancelBlock:^(id sender){
            NSLog(@"用户取消操作...");
            isCancelAction = YES;
            
            [[Transfer sharedClient].operationQueue cancelAllOperations];
            [[Transfer sharedClient] cancelAllHTTPOperationsWithMethod:requestModel.method path:DEFAULTHOST];
            
            [SVProgressHUD dismiss];
        }];
        
    }
    
    
    [[Transfer sharedClient]  registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [[Transfer sharedClient] setDefaultHeader:@"Content-Type" value:@"application/json"];
    [Transfer sharedClient].parameterEncoding = AFJSONParameterEncoding;
    
    NSString *tmp = nil;
    if (replaceId) {
       tmp = [requestModel.url stringByReplacingOccurrencesOfString:@"${id}" withString:replaceId];
        tmp = [tmp stringByReplacingOccurrencesOfString:@"${nodeID}" withString:replaceId];
    }
    //@"/alumni/service%@?v=%@&cid=%@&sid=%@"
    NSString *path = [NSString stringWithFormat:@"service%@?v=%@&cid=%@&sid=%@", replaceId ? tmp:requestModel.url, [AppDataCenter sharedAppDataCenter].version, [AppDataCenter sharedAppDataCenter].clientId,[AppDataCenter sharedAppDataCenter].sid];
    
    NSMutableURLRequest *request = [client requestWithMethod:requestModel.method path:path parameters:reqDic];

    [request setTimeoutInterval:20];
    NSLog(@"request: %@", request.URL);
    if (reqDic!=nil)
    {
        NSLog(@"requestDict: %@",reqDic);
    }
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
    
            [SVProgressHUD dismiss];
            NSLog(@"respose: %@", JSON);
            success(JSON);
            
            
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response,
                    NSError *error, id JSON) {
            [SVProgressHUD dismiss];
            
            [[Transfer sharedClient].operationQueue cancelAllOperations];
            [[Transfer sharedClient] cancelAllHTTPOperationsWithMethod:@"POST" path:DEFAULTHOST];
            
            NSLog(@"--%@", [NSString stringWithFormat:@"%@",error]);
            //[SVProgressHUD showErrorWithStatus:[self getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]]];
            
            // 点击取消的时候会报（The operation couldn’t be completed）,但是UserInfo中不存在NSLocalizedDescription属性，说明这不是一个错误，现用一BOOL值进行简单特殊控制,。。。
            NSString *message = [Transfer getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
            if (!isCancelAction && message && alertError) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            
            failure([Transfer getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]]);

        }
];
    
    return operation;
}
#pragma mark-
#pragma mark--发送请求
/**
 *	@brief	发送请求
 *
 *	@param 	reqDic 	post请求时传递数据 发送get请求时传nil
 *	@param 	requestId 	请求标志
 *	@param 	messId 	需要填充的参数 暂时只有id要填充 不需填充时传nil
 *	@param 	success 	成功回调
 *	@param 	failure 	失败回调 不需要处理失败时传nil
 *
 *	@return	
 */
- (AFHTTPRequestOperation *) sendRequestWithRequestDic:(NSDictionary *)reqDic
                                              requesId:(NSString *)requestId
                                                messId:(NSString*)messId
                                               success:(SuccessBlock)success
                                               failure:(FailureBlock)failure

{
    //没有网络连接时给出提示 直接返回
    if (![self checkNetAvailable])
    {
        [SVProgressHUD dismiss];
        return nil;
    }
    
    RequestModel *requestModel = [[AppDataCenter sharedAppDataCenter] getModelWithRequestId:requestId];    

    [[Transfer sharedClient]  registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    //履历更新||新建履历 带有图片上传的
//    if ([requestId isEqualToString:@"TIMELINE_NODE_CREATE"]
//        ||[requestId isEqualToString:@"TIMELINE_NODE_UPDATE"])
//    {
////        [[Transfer sharedClient] setDefaultHeader:@"Content-Type" value:@"multipart/form-data"];
//
//        
//    }
//    else
//    {
        [[Transfer sharedClient] setDefaultHeader:@"Content-Type" value:@"application/json"];
//    }
    
       [Transfer sharedClient].parameterEncoding = AFJSONParameterEncoding;
    

    if (messId!=nil&&[messId rangeOfString:@"###"].location==NSNotFound) //需要填充id 将id字段替换
    {
        requestModel.url = [requestModel.url stringByReplacingOccurrencesOfString:@"${id}" withString:messId];
        requestModel.url = [requestModel.url stringByReplacingOccurrencesOfString:@"${nodeID}" withString:messId];
    }
    else if(messId!=nil&&[messId rangeOfString:@"###"].location!=NSNotFound)
        //以前的接口都只有一个需要填充的字段 但是圈子踢人字段有两个  所以加个判断 还是传一个字符 但是用两个值###分开
    {
        NSArray *ids = [messId componentsSeparatedByString:@"###"];
         requestModel.url = [requestModel.url stringByReplacingOccurrencesOfString:@"${id}" withString:ids[0]];
        requestModel.url = [requestModel.url stringByReplacingOccurrencesOfString:@"${personId}" withString:ids[1]];
    }
    ///alumni/service%@?v=%@&cid=%@&sid=%@"
    NSString *path = [NSString stringWithFormat:@"service%@?v=%@&cid=%@&sid=%@", requestModel.url, [AppDataCenter sharedAppDataCenter].version, [AppDataCenter sharedAppDataCenter].clientId,[AppDataCenter sharedAppDataCenter].sid];
    
    NSMutableURLRequest *request = [client requestWithMethod:requestModel.method path:path parameters:reqDic];
    [request setTimeoutInterval:20];
    NSLog(@"request: %@", request.URL);
    if (reqDic!=nil)
    {
        NSLog(@"requestDict: %@",reqDic);
    }
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
       {
        
         //  NSLog(@"请求成功(%@)--respose: %s", requestId, [[JSON description] cStringUsingEncoding:NSISOLatin2StringEncoding ]);
           
           NSData *data = [NSJSONSerialization dataWithJSONObject:JSON
                                                          options:0 
                                                            error:nil];
     
           
           NSLog(@"请求返回数据:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
           [SVProgressHUD dismiss];
            success(JSON);
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response,
                    NSError *error, id JSON)
       {
            [SVProgressHUD dismiss];
            
            [[Transfer sharedClient].operationQueue cancelAllOperations];
            [[Transfer sharedClient] cancelAllHTTPOperationsWithMethod:@"POST" path:DEFAULTHOST];
            
            NSLog(@"请求失败--err:%@", [NSString stringWithFormat:@"%@",error]);
            //[SVProgressHUD showErrorWithStatus:[self getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]]];
            
            // 点击取消的时候会报（The operation couldn’t be completed）,但是UserInfo中不存在NSLocalizedDescription属性，说明这不是一个错误，现用一BOOL值进行简单特殊控制,。。。
            NSString *message = [Transfer getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
            if (message)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
           
           if (failure!=nil)
           {
                failure([Transfer getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]]);
           }
        }
      ];

    return operation;
    
}

#pragma mark-
#pragma mark--文件下载相关
- (void) downloadFileWithName:(NSString *) name
                         link:(NSString *) link
               viewController:(UIViewController *) vc
                      success:(SuccessBlock) success
                      failure:(FailureBlock) failure
{
    [self downloadFileWithName:name
                          link:link
                repeatDownload:NO
                viewController:vc
                       success:success
                       failure:failure];
}

/**
 repeatDownload参数控制是否需要重新下载,如果需要重新下载，则不检查是否存在原文件，直接下载
 **/
- (void) downloadFileWithName:(NSString *) name
                         link:(NSString *) link
               repeatDownload:(BOOL) repeatDownload
               viewController:(UIViewController *) vc
                      success:(SuccessBlock) success
                      failure:(FailureBlock) failure
{
    self.downloadFileName = [NSString stringWithFormat:@"%@", name];
    
    if (!repeatDownload && [FileManagerUtil fileExistWithName:name]) {
        success(nil);
        return;
    }
    
    if (![self checkNetAvailable]) {
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:link]];
    [request setTimeoutInterval:20];
    downloadOperation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // 保存文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:name];
    downloadOperation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    
    // 显示进度条
    MProgressAlertView *progressView =[[MProgressAlertView alloc] initWithTitle:@"正在下载文件" message:nil delegate:self cancelButtonTitle:@"取消下载" otherButtonTitles:nil, nil];
    progressView.tag = 100;
    [progressView show];
    
    [downloadOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if (!totalSize) {
            totalSize = [Transfer formatDownloadData:totalBytesExpectedToRead];
        }
        
        // 更新进度
        float percent = (float)totalBytesRead / totalBytesExpectedToRead;
        progressView.progressView.progress = percent;
        /***
         progressView.message = [NSString stringWithFormat:@"%@ / %@", [self formatDownloadData:totalBytesRead], totalSize];
         progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", percent*100];
         ***/
        
        progressView.progressLabel.text = [NSString stringWithFormat:@"%@ / %@", [Transfer formatDownloadData:totalBytesRead], totalSize];
    }];
    
    [downloadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"downloadComplete!");
        
        [SVProgressHUD dismiss];
        
        totalSize = nil;
        [progressView dismissWithClickedButtonIndex:0 animated:YES];
        
        success(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure! %@", error);
        
        [operation cancel];
        [SVProgressHUD dismiss];
        
        // 文件下载失败直接删除缓存文件
        [FileManagerUtil deleteFileWithName:name];
        
        totalSize = nil;
        [progressView dismissWithClickedButtonIndex:0 animated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件下载失败。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        failure([Transfer getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]]);
    }];
    
    [downloadOperation start];
}

+ (NSString *) formatDownloadData:(long long)length
{
    if (length < (MB/10.0)) {
        return [NSString stringWithFormat:@"%.2f K", length/KB];
    } else {
        return [NSString stringWithFormat:@"%.2f M", length/MB];
    }
}

// 检测网络
- (BOOL) checkNetAvailable
{
    if (([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable) &&
        ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"无法链接到互联网，请检查您的网络设置"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    return YES;
}

+ (NSString *) getErrorMsg:(NSString *)enMsg
{
    // 如果enMsg为nil，则[nil rangeOfString:@"111"].location != NSNotFound 
    if (enMsg) {
        if ([enMsg rangeOfString:@"The request timed out"].location != NSNotFound) {
            // The request timed outtimed out
            return @"服务器响应超时";
        } else if ([enMsg rangeOfString:@"got 500"].location != NSNotFound) {
            //Expected status code in (200-299), got 500
            return [NSString stringWithFormat:@"服务器异常[%@]", enMsg];
        } else if ([enMsg rangeOfString:@"The Internet connection appears to be offline"].location != NSNotFound) {
            // The Internet connection appears to be offline
            return @"无法连接服务器，请检查网络设置";
        } else if ([enMsg rangeOfString:@"Could not connect to the server"].location != NSNotFound) {
            // Could not connect to the server
            return @"无法连接服务器，请检查网络设置";
        } else if ([enMsg rangeOfString:@"got 404"].location != NSNotFound) {
            // Expected status code in (200-299), got 404
            return @"服务器无法响应功能请求(404)";
        }
        else if ([enMsg rangeOfString:@"got 415"].location != NSNotFound) {
            // Expected status code in (200-299), got 404
            return @"服务器无法响应功能请求(415) 不支持的媒体类型";
        }
    }
    
    //return @"未知错误，请重试";
    return nil;
}

#pragma mark - UIAlertDialogDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            [downloadOperation cancel];
            [SVProgressHUD dismiss];
            
            // 文件下载失败直接删除缓存文件
            [FileManagerUtil deleteFileWithName:self.downloadFileName];
            
            totalSize = nil;
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
}

@end
