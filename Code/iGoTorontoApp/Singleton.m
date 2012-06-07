//
//  WISingleton.m
//  LifeStylerClient
//
//  Created by Ryan Renna on 10-12-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton
/* Singleton Handling */
- (id)copyWithZone:(NSZone *)zone
{
	return self;
}
- (id)retain
{
	return self;
}
- (void)release
{
	// do nothing
}
- (id)autorelease
{
	return self;
}
- (NSUInteger)retainCount
{
	return NSUIntegerMax; // This is sooo not zero
}
@end
