//
//  GoTrainDetailView.h
//  iGoToronto
//
//  Created by Ryan Renna on 10-07-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "IGoScreenController.h"


@interface UnionBoardDetailController : IGoScreenController {
        UIWebView *webView;
        UIActivityIndicatorView* activityView;
        NSString *url;
}
@property (retain,nonatomic) UIWebView *webView;
@property (retain,nonatomic) UIActivityIndicatorView* activityView;
@property (retain,nonatomic) NSString *url;
@end
