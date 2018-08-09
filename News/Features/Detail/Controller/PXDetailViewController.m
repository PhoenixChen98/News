//
//  PXDetailViewController.m
//  News
//
//  Created by Futu on 2018/8/7.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import "PXDetailViewController.h"
#import <WebKit/WebKit.h>
@interface PXDetailViewController ()
@property (strong, nonatomic) WKWebView *webView;
@end

@implementation PXDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
	
	NSURL *url = [NSURL URLWithString:[self.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[self.webView loadRequest: request];
}

- (WKWebView *)webView {
    if (!_webView) {
        CGFloat width = CGRectGetWidth(self.view.frame);
        CGFloat height = CGRectGetHeight(self.view.frame);
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    }
    return _webView;
}

@end
