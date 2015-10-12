//
//  RESTfulOperation.m
//  iHotelApp
//
//  Created by Mugunth on 28/05/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//

#import "RESTfulOperation.h"

@implementation RESTfulOperation

- (void) operationSucceeded
{  
	// even when request completes without a HTTP Status code, it might be a benign error

	NSLog(@"Operation succeeded with response: %@", [self responseString]);
	
	NSMutableDictionary *errorDict = [[self responseJSON] objectForKey:@"error"];

	if(errorDict) {
		self.restError = [[RESTError alloc] initWithDomain:kBusinessErrorDomain
													  code:[[errorDict objectForKey:@"code"] intValue]
												  userInfo:errorDict];
		[super operationFailedWithError:self.restError];
	} else {
		[super operationSucceeded];
	}	
}

- (void) operationFailedWithError:(NSError *)theError
{
	// TODO: if the operation failed because the API key was invalid,
	// broadcast a notification here so the login controller can be shown
	
	NSLog(@"Operation failed with error: %@", theError);
	
	NSMutableDictionary *errorDict = [[self responseJSON] objectForKey:@"error"];
	
	if(errorDict == nil) {
		self.restError = [[RESTError alloc] initWithDomain:kRequestErrorDomain
													  code:[theError code]
												  userInfo:[theError userInfo]];
	} else {
		self.restError = [[RESTError alloc] initWithDomain:kBusinessErrorDomain
													  code:[[errorDict objectForKey:@"code"] intValue]
												  userInfo:errorDict];
	}

	[super operationFailedWithError:theError];
}

@end
