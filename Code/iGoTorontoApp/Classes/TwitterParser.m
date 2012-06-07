//
//  TwitterParser.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-10-27.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "TwitterParser.h"
#import "NSString+XMLEntities.h"

static NSString* uriFormat = @"https://twitter.com/statuses/user_timeline/%@.rss?count=%i";

@implementation TwitterParser

-(NSMutableArray*)getLast:(int)number TweetsForUser:(NSString*)username
{
    NSMutableArray* tweetArray = [NSMutableArray new];
    NSString* url = [[NSString alloc] initWithFormat:uriFormat,username,number];
	NSURL* uri = [[NSURL alloc] initWithString:url];
	
    ASIHTTPRequest* twitterRequest = [[ASIHTTPRequest alloc] initWithURL:uri];
	
	[url release];
	[uri release];
	
	
	[twitterRequest setRetryCount:2];
	[twitterRequest setTimeOutSeconds:15];
	[twitterRequest startSynchronous];
	
    NSString* response = [twitterRequest responseString];
    
    if(response && ![response isEqualToString:@""])
    {
        TBXML* twitterXMLResponse = nil;
        @try
        {
            twitterXMLResponse = [TBXML tbxmlWithXMLString:response];
        }
        @catch(id exception) 
        {
            twitterXMLResponse = nil;
        }
        //If response is returned in xml format...
        if(twitterXMLResponse)
        {
            TBXMLElement *rootXMLElement = twitterXMLResponse.rootXMLElement;
            TBXMLElement *channelElement = rootXMLElement->firstChild;		
            TBXMLElement *channelChild = channelElement->firstChild;
            //If a rate limit is exceeded, the xml will not have a 
            //channel node
            if(channelChild)
            {
                TBXMLElement *itemElement = [TBXML nextSiblingNamed:@"item" searchFromElement:channelChild];
                
               while(itemElement)
               {
                   TBXMLElement *itemProperty = itemElement->firstChild;
                   
                   if(itemProperty)
                   {
                       do
                       {
                           if([[TBXML elementName:itemProperty] isEqualToString:@"title"])
                           {
                               NSString* unencodedString = [TBXML textForElement:itemProperty];
                
                               [tweetArray addObject:[unencodedString stringByDecodingHTMLEntities]];
                           }
                           
                       }
                       while((itemProperty = itemProperty->nextSibling));
                   }
                   itemElement = [TBXML nextSiblingNamed:@"item" searchFromElement:itemElement];
               }
            }
        }
        //If anything else was returned from the server
        else
        {
            DLog(@"Unknown Response: %@",response);
        }
    }
    [twitterRequest release];
    return [tweetArray autorelease];
}

- (void)dealloc 
{
    [super dealloc];
}

@end
