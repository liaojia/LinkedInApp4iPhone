//
//  Constant.h
//  LKOA4iPhone
//
//  Created by  STH on 7/27/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

typedef enum
{
    
    kAppTypeHaveCircle,  //有圈子模块
    kAppTypeNoCircel     //没有圈子模块
}kAPPTYPE;

#define APPTYPE kAppTypeHaveCircle

//#define DEMO                          1

#define BPUSH                           1

#define kVERSION                        @"6" // 当前程序的版本号，以此值与服务器进行比对，确定版本更新

#define UserDefaults [NSUserDefaults standardUserDefaults]

//#define LKCOLOR  ([UIColor colorWithRed:98/225.0f green:160/225.0f blue:220/225.0f alpha:1.0f])
#define LKCOLOR  ([UIColor colorWithRed:46/225.0f green:137/225.0f blue:224/225.0f alpha:1.0f])

//#define DEFAULTHOST                     @"http://115.47.56.228:8080"
#define DEFAULTHOST                     @"http://xy.cnu.edu.cn"

#define kEVERLaunched                   @"everLaunched"
#define kFIRSTLaunched                  @"firstLaunched"

#define kHOSTNAME                       @"hostName"

#define kTAPITEM                        @"TapItem"

#define kWebServiceName                 @"webServiceName"
#define kMethodName                     @"methodName"
#define kParamName                      @"paramName"

#define kUSERID                         @"userId"
#define KUSERNAME                       @"userName"
#define KUSERNAME_LK                    @"UserName_LK"
#define kDEPTID                         @"deptId" // 用户的部门ID
#define kDEPTNAME                       @"DeptName_LK" //用户部门名称
#define kPASSWORD                       @"password" // 保存用户输入的密码

#define kREMEBERPWD                     @"remeberPWD"
#define kAUTOLOGIN                      @"autoLogin"
#define kPASSWORD_MD5                   @"MD5_password" // 资金管理中取列表的时候需要用到密码的MD5值

#define kBGIMAGEID                      @"backgroundImageId"

#define kBGIMAGECOUNT                   3
#define kPAGESIZE                       @"5"

#define kCOUNT_DBGW                     @"count_DBGW"
#define kCOUNT_QSBG                     @"count_QSBG"
#define kCOUNT_XMGL                     @"count_XMGL"
#define kCOUNT_ZJGL                     @"count_ZJGL"
#define kCOUNT_XXZX                     @"count_XXZX"
#define kCOUNT_XXTZ                     @"count_XXTZ"

//*************sinaweibo*****************
#define SINA_V2_DOMAIN              @"https://api.weibo.com/2"
#define SINA_API_AUTHORIZE          @"https://api.weibo.com/oauth2/authorize"
#define SINA_API_ACCESS_TOKEN       @"https://api.weibo.com/oauth2/access_token"


//所以需要把这里的app key 和 app secret 换成你在新浪上注册的app key 和 app secret
//然后给你注册的应用添加几个测试账号，用测试账号登陆。
#define SINA_APP_KEY                @"3601604349"
#define SINA_APP_SECRET             @"7894dfdd1fc2ce7cc6e9e9ca620082fb"

#define USER_INFO_KEY_TYPE          @"requestType"

#define USER_STORE_ACCESS_TOKEN     @"SinaAccessToken"
#define USER_STORE_EXPIRATION_DATE  @"SinaExpirationDate"
#define USER_STORE_USER_ID          @"SinaUserID"
#define USER_STORE_USER_NAME        @"SinaUserName"
#define USER_OBJECT                 @"USER_OBJECT"
#define NeedToReLogin               @"NeedToReLogin"
//***********
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define STRETCH                                5
#define NODATA                          @"未知"





