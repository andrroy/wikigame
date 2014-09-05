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
    
    NSDictionary *dict = [self getTask];
    NSString *start_url = dict[@"start_url"];
    NSString *end_url = dict[@"end_url"];
    NSLog(@"START: %@", start_url);
    NSLog(@"END: %@", end_url);

    
    NSURL *pageUrl = [NSURL URLWithString:start_url];
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

//- (void)getTask
//{
//    NSError *error;
//    NSURL *url = [NSURL URLWithString:@"http://localhost:8000/tasks/"];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    
//    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//    if (error)
//    NSLog(@"JSONObjectWithData error: %@", error);
//    
//    for (NSMutableDictionary *dictionary in array)
//    {
//        NSString *start = dictionary[@"start_url"];
//        NSLog(@"START: %@", start);
//        
//        NSString *end = dictionary[@"start_url"];
//        NSLog(@"END: %@", end);
//        
//        
//        NSString *arrayString = dictionary[@"array"];
//        if (arrayString)
//        {
//            NSData *data = [arrayString dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *error = nil;
//            dictionary[@"array"] = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//            if (error)
//            NSLog(@"JSONObjectWithData for array error: %@", error);
//        }
//    }
//}

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
        NSString *end = dictionary[@"start_url"];
        
        dict = @{
                  @"start_url" : start,
                  @"end_url" : end,
                  };
    }
    
    
    return dict;
}

@end
