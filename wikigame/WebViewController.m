//
//  WebViewController.m
//  wikigame
//
//  Created by Andreas Røyrvik on 02.09.14.
//  Copyright (c) 2014 Andreas Røyrvik. All rights reserved.
//

#import "WebViewController.h"
#import "HomeScreenViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize webView = webView;

NSURL *start_url = NULL;
NSURL *end_url = NULL;

NSURL *lastURL = NULL;
NSURL *currentURL = NULL;

NSInteger counter = 0;


-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // If link is clicked
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        // Update counter and GUI
        counter++;
        clicksDisplayed.text = [NSString stringWithFormat:@"%li", (long)counter];
        
        // Get current at previous url
        lastURL = self.webView.request.URL;
        currentURL = [request URL] ;
        
        // If true, user has won
        if( [currentURL isEqual:end_url] )
        {
            counter = 0; // Reset counter
            
            // Temp dialog
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You won (temp)"
                                                            message:[NSString stringWithFormat:@"You found the page in %li clicks", (long)counter]
                                                            delegate:self
                                                            cancelButtonTitle:@"Home"
                                                            otherButtonTitles:nil, nil];
            
            [alert show];
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
    start_url = [NSURL URLWithString: dict[@"start_url"] ];
    end_url = [NSURL URLWithString: dict[@"end_url"] ];
    NSLog(@"START: %@", start_url);
    NSLog(@"END: %@", end_url);
    
    NSLog(@"Path::: %@", [start_url path]);
    NSLog(@"Path::: %@", [end_url path]);
    
    NSLog(@"Host::: %@", [end_url host]);
    
    
    NSURL *pageUrl = start_url;
    NSURLRequest *request = [NSURLRequest requestWithURL:pageUrl];
    [webView loadRequest:request];
    NSLog(@"Done loading web view");
    
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


// Get task from REST server
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

// When alert View is interacted with
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked Home
    if (buttonIndex == 0)
    {
        // Go to home view
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"Main" bundle:[NSBundle mainBundle]];
        UIViewController *homeScreenViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenViewController"];
        [self presentViewController:homeScreenViewController animated:YES completion:nil];
        
    }
}

@end
