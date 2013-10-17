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
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@", [UserDefaults stringForKey:kHOSTNAME]]];
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
        //[SVProgressHUD showWithStatus:prompt maskType:SVProgressHUDMaskTypeClear];
        
        
         [SVProgressHUD showWithStatus:prompt maskType:SVProgressHUDMaskTypeClear cancelBlock:^(id sender){
             NSLog(@"用户取消操作...");
             isCancelAction = YES;
             [[Transfer sharedClient].operationQueue cancelAllOperations];
             [[Transfer sharedClient] cancelAllHTTPOperationsWithMethod:@"POST" path:[UserDefaults stringForKey:kHOSTNAME]];
             
             [SVProgressHUD dismiss];
             
         }];
         
    }
    
    [[Transfer sharedClient].operationQueue setMaxConcurrentOperationCount:[operationList count]];
    [[Transfer sharedClient].operationQueue setName:@"doQueueByTogether"];
    
    [[Transfer sharedClient] enqueueBatchOfHTTPRequestOperations:operationList progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {
        [SVProgressHUD dismiss];
        
        if (completeBlock) {
            completeBlock(operations);
        }
        
    }];
}

/**
    不要直接使用该方法的返回值调用start方法执行联网请求。而是使用上面的队列方式来请求数据。。。
    
    如果使用doQueueByTogether则prompt失效
 
 **/

- (AFHTTPRequestOperation *) TransferWithRequestDic:(NSDictionary *) reqDic
                                           requesId:(NSString *)requesId
                                             prompt:(NSString *) prompt
                                            success:(SuccessBlock) success
                                            failure:(FailureBlock) failure

{
    return [self TransferWithRequestDic:reqDic
                               requesId:requesId
                                 prompt:prompt
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
            [[Transfer sharedClient] cancelAllHTTPOperationsWithMethod:requestModel.method path:kHOSTNAME];
            
            [SVProgressHUD dismiss];
        }];
        
    }
    
    
    [[Transfer sharedClient]  registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [[Transfer sharedClient] setDefaultHeader:@"Content-Type" value:@"application/json"];
    [Transfer sharedClient].parameterEncoding = AFJSONParameterEncoding;
    
    
    NSString *path = [NSString stringWithFormat:@"/alumni/service%@?v=%@&cid=%@&sid=%@", requestModel.url, VERSION, CLIENT_ID, SESSION_ID];
    
    NSMutableURLRequest *request = [client requestWithMethod:requestModel.method path:path parameters:reqDic];
    [request setTimeoutInterval:20];
    NSLog(@"request: %@", request.URL);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                        
                                                                                    
                                                                                            NSLog(@"respose: %@", JSON);success(JSON);
                                                                                            
//                                                                                            NSDictionary *jsonDict = (NSDictionary *) JSON;
//                                                                                            NSArray *products = [jsonDict objectForKey:@"products"];
//                                                                                            [products enumerateObjectsUsingBlock:^(id obj,NSUInteger idx, BOOL *stop){
//                                                                                                NSString *productIconUrl = [obj objectForKey:@"icon_url"];
//                                                                                            }];
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response,
                                                                                                    NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                            
                                                                                            [[Transfer sharedClient].operationQueue cancelAllOperations];
                                                                                            [[Transfer sharedClient] cancelAllHTTPOperationsWithMethod:@"POST" path:kHOSTNAME];
                                                                                            
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
    
//    [operation start];
    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        /***
//        if ([[Transfer sharedClient].operationQueue.operations count] == 0) {
//            [SVProgressHUD dismiss];
//        }
//         ***/
//        
//        NSLog(@"Response: %@", [operation responseString]);
//        
//#ifdef DEMO
////        id obj = [self DemoParse:[reqDic objectForKey:kMethodName]];
////        success(obj);
//#else
////        id obj = [self ParseXMLWithReqName:[reqDic objectForKey:kMethodName] xmlString:respXML];
////        success(obj);
//#endif
//        
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [SVProgressHUD dismiss];
//        
//        [[Transfer sharedClient].operationQueue cancelAllOperations];
//        [[Transfer sharedClient] cancelAllHTTPOperationsWithMethod:@"POST" path:[UserDefaults stringForKey:kHOSTNAME]];
//        
//        NSLog(@"--%@", [NSString stringWithFormat:@"%@",error]);
//        //[SVProgressHUD showErrorWithStatus:[self getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]]];
//        
//        // 点击取消的时候会报（The operation couldn’t be completed）,但是UserInfo中不存在NSLocalizedDescription属性，说明这不是一个错误，现用一BOOL值进行简单特殊控制,。。。
//        NSString *message = [Transfer getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
//        if (!isCancelAction && message && alertError) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        
//        
//        failure([Transfer getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]]);
//    }];
    
    return operation;
}

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
