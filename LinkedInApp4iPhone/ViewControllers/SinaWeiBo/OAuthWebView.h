//
//  OAuthWebView.h
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//



@interface OAuthWebView : UIViewController<UIWebViewDelegate>{
    UIWebView *webV;
    NSString *token;
}
@property (strong, nonatomic) IBOutlet UIWebView *webV;
@property (assign, nonatomic) UIViewController *fatherController;

@end
