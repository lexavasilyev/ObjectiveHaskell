//
//  LoginWindowController.m
//  PhotoUploader
//
//  Created by Justin Spahr-Summers on 19.07.12.
//  Copyright (c) 2012 Justin Spahr-Summers. All rights reserved.
//

#import "LoginWindowController.h"
#import "Users_stub.h"
#import <WebKit/WebKit.h>

@interface LoginWindowController ()
@property (nonatomic, weak) IBOutlet WebView *webView;
@end

@implementation LoginWindowController

- (id)init {
    return [self initWithWindowNibName:NSStringFromClass(self.class)];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://instagram.com/oauth/authorize/?client_id=4aaaec75a7e44968bd7c3d3a9ef3129b&redirect_uri=objhsexample://oauth_redirect&response_type=token"]];
	[self.webView.mainFrame loadRequest:request];
}

#pragma mark WebResourceLoadDelegate

- (NSURLRequest *)webView:(WebView *)sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(WebDataSource *)dataSource {
	if (![request.URL.scheme isEqualToString:@"objhsexample"])
		return request;
	
	// skip 'access_token='
	NSString *accessToken = [request.URL.fragment substringFromIndex:13];
	NSLog(@"access token: %@", accessToken);

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		HsStablePtr user = user_fetchCurrent(accessToken);
		NSLog(@"Hello, %@!", user_fullName(user));
	});

	return request;
}

@end
