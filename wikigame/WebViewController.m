//
//  WebViewController.m
//  wikigame
//
//  Created by Andreas Røyrvik on 02.09.14.
//  Copyright (c) 2014 Andreas Røyrvik. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize webView = webView;

NSString *currentURL = NULL;
NSInteger counter = 0;


-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        counter++;
        currentURL = self.webView.request.URL.absoluteString;
        NSLog(@"Last page was: %@", currentURL);
        NSLog(@"New page: %@", request);
        NSLog(@"Clicks: %zd", counter);
    }
    
    return YES;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
    NSURL *pageUrl = [NSURL URLWithString:@"http://no.wikipedia.org/wiki/GE_Vingmed_Ultrasound"];
    NSURLRequest *request = [NSURLRequest requestWithURL:pageUrl];
    [webView loadRequest:request];
    NSLog(@"Done loading web view");
    NSLog(@"Clicks: %zd", counter);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
