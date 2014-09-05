//
//  WebViewController.h
//  wikigame
//
//  Created by Andreas Røyrvik on 02.09.14.
//  Copyright (c) 2014 Andreas Røyrvik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate> {
    UIWebView* mWebView;
}
- (NSDictionary *)getTask;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
