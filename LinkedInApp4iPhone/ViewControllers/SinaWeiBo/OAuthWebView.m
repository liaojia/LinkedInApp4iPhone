//
//  OAuthWebView.m
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//

#import "OAuthWebView.h"
//#import "WeiBoHttpManager.h"
//#import "SHKActivityIndicator.h"
//#import "ZJTStatusBarAlertWindow.h"
#import "ProfileVC.h"
@implementation OAuthWebView
@synthesize webV;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSString *) getStringFromUrl: (NSString*) url needle:(NSString *) needle {
	NSString * str = nil;
	NSRange start = [url rangeOfString:needle];
	if (start.location != NSNotFound) {
		NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
		NSUInteger offset = start.location+start.length;
		str = end.location == NSNotFound
		? [url substringFromIndex:offset]
		: [url substringWithRange:NSMakeRange(offset, end.location)];
		str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
	return str;
}

//剥离出url中的access_token的值
- (void) dialogDidSucceed:(NSURL*)url {
    NSString *q = [url absoluteString];
    token = [self getStringFromUrl:q needle:@"access_token="];
    
    //用户点取消 error_code=21330
    NSString *errorCode = [self getStringFromUrl:q needle:@"error_code="];
    if (errorCode != nil && [errorCode isEqualToString: @"21330"]) {
        NSLog(@"Oauth canceled");
    }
    
    NSString *refreshToken  = [self getStringFromUrl:q needle:@"refresh_token="];
    NSString *expTime       = [self getStringFromUrl:q needle:@"expires_in="];
    NSString *uid           = [self getStringFromUrl:q needle:@"uid="];
    NSString *remindIn      = [self getStringFromUrl:q needle:@"remind_in="];
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:USER_STORE_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:USER_STORE_USER_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    NSDate *expirationDate =nil;
    NSLog(@"jtone \n\ntoken=%@\nrefreshToken=%@\nexpTime=%@\nuid=%@\nremindIn=%@\n\n",token,refreshToken,expTime,uid,remindIn);
    if (expTime != nil) {
        int expVal = [expTime intValue]-3600;
        if (expVal == 0) 
        {
            
        } else {
            expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
            [[NSUserDefaults standardUserDefaults]setObject:expirationDate forKey:USER_STORE_EXPIRATION_DATE];
            [[NSUserDefaults standardUserDefaults] synchronize];
			NSLog(@"jtone time = %@",expirationDate);
        } 
    } 
    if (token) {
        
       // [[NSNotificationCenter defaultCenter] postNotificationName:DID_GET_TOKEN_IN_WEB_VIEW object:nil];
      //  [self.navigationController popViewControllerAnimated:YES];
        
     
        [self.navigationController popViewControllerAnimated:NO];
        [self.fatherController performSelector:@selector(gotoSinaWeiBo) withObject:nil afterDelay:0.0];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"登陆";
    self.navigationItem.hidesBackButton = YES;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_USER_ID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_EXPIRATION_DATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    webV.delegate = self;
    NSURL *url = [self getOauthCodeUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
	[webV loadRequest:request];

}

- (void)viewDidUnload
{
    [self setWebV:nil];
    [super viewDidUnload];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.selectedIndex = 0;
}

#pragma mark-
#pragma mark--功能函数
-(NSURL*)getOauthCodeUrl //留给webview用
{
    //https://api.weibo.com/oauth2/authorize
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   SINA_APP_KEY,                    @"client_id",       //申请的appkey
								   @"token",                        @"response_type",   //access_token
								   @"http://hi.baidu.com/jt_one",   @"redirect_uri",    //申请时的重定向地址
								   @"mobile",                       @"display",         //web页面的显示方式
                                   nil];
	
	NSURL *url = [self generateURL:SINA_API_AUTHORIZE params:params];
	NSLog(@"url= %@",url);
    return url;
}

- (NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
	if (params) {
		NSMutableArray* pairs = [NSMutableArray array];
		for (NSString* key in params.keyEnumerator) {
			NSString* value = [params objectForKey:key];
			NSString* escaped_value = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                  NULL, /* allocator */
                                                  (CFStringRef)value,
                                                  NULL, /* charactersToLeaveUnescaped */
                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                  kCFStringEncodingUTF8));
            
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
		}
		
		NSString* query = [pairs componentsJoinedByString:@"&"];
		NSString* url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
		return [NSURL URLWithString:url];
	} else {
		return [NSURL URLWithString:baseURL];
	}
}
#pragma mark-
#pragma mark--UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	//这里是几个重定向，将每个重定向的网址遍历，如果遇到＃号，则重定向到自己申请时候填写的网址，后面会附上access_token的值
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = nil;
    for (UIWindow *win in app.windows) {
        if (win.tag == 1) {
            window = win;
            window.windowLevel = UIWindowLevelNormal;
        }
        if (win.tag == 0) {
            [win makeKeyAndVisible];
        }
    }
    
	NSURL *url = [request URL];
    NSLog(@"webview's url = %@",url);
	NSArray *array = [[url absoluteString] componentsSeparatedByString:@"#"];
	if ([array count]>1) {
		[self dialogDidSucceed:url];
		return NO;
	}
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
   // [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[[SHKActivityIndicator currentIndicator] hide];
}

@end
