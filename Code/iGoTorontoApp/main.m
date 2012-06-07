//
//  main.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-07-11.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <CoreLocation/CLLocation.h>

int main(int argc, char *argv[]) 
{	
	//Solves the missing "distanceFromLocation: method in iOS 3.1.3
	Method getDistanceFrom = class_getInstanceMethod([CLLocation class], @selector(getDistanceFrom:));
	class_addMethod([CLLocation class], @selector(distanceFromLocation:), method_getImplementation(getDistanceFrom), method_getTypeEncoding(getDistanceFrom));
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}

