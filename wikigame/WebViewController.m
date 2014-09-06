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

NSString *start_url = NULL;
NSString *end_url = NULL;

NSString *lastURL = NULL;
NSString *currentURL = NULL;

NSInteger counter = 0;


-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // If link is clicked
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        counter++;
//        clicksDisplayed.text = @"%i";
        clicksDisplayed.text = [NSString stringWithFormat:@"%li", (long)counter];
        lastURL = self.webView.request.URL.absoluteString;
        currentURL = [[request URL] absoluteString];
        NSLog(@"Last page was: %@", lastURL);
        NSLog(@"New page: %@", currentURL);
        NSLog(@"Clicks: %zd", counter);
        
        if( [currentURL isEqualToString:end_url] ){
            NSLog(@"DU VANT OMG ");
        }
    
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
    
    NSDictionary *dict = [self getTask];
    start_url = dict[@"start_url"];
    end_url = dict[@"end_url"];
    NSLog(@"START: %@", start_url);
    NSLog(@"END: %@", end_url);

    
    NSURL *pageUrl = [NSURL URLWithString:start_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:pageUrl];
    [webView loadRequest:request];
    NSLog(@"Done loading web view");
    NSLog(@"Clicks: %zd", counter);
    
}

- (void) webViewDidFinishLoad:(UIWebView *)WebView
{
    // Remove unwanted elements
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('header')[0].style.display='none'"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)getTask {
    
    NSDictionary *dict;
    
    NSError *error;
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:8000/tasks/"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    // Check if error
    if (error)
    NSLog(@"JSONObjectWithData error: %@", error);
    
    // Loop through json response
    for (NSMutableDictionary *dictionary in array)
    {
        NSString *start = dictionary[@"start_url"];
        NSString *end = dictionary[@"end_url"];
        
        dict = @{
                  @"start_url" : start,
                  @"end_url" : end,
                  };
    }
    
    
    return dict;
}

@end
