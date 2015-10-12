//
//  RESTfulEngine.m
//

#import "RESTfulEngine.h"
#import "AppDelegate.h"

#define BASE_URL @"chris.hpr.uci.edu"
#define API_PATH @""

@implementation RESTfulEngine

- (id)init {
	if (self = [super initWithHostName:BASE_URL apiPath:API_PATH customHeaderFields:nil]) {

	}
	return self;
}

- (MKNetworkOperation *)operationWithPath:(NSString *)path
								   params:(NSDictionary *)body
							   httpMethod:(NSString *)method
							authenticated:(BOOL)authenticated
{
	MKNetworkOperation *operation = [super operationWithPath:path params:body httpMethod:method ssl:YES];
	operation.postDataEncoding = MKNKPostDataEncodingTypeURL;
	if (authenticated) {
		//[operation setUsername:[Settings username] password:[Settings password] basicAuth:YES];
	}
	return operation;
}

// POST SURVEY RESULT

-(RESTfulOperation *) postSurveyResult:(SurveyResult *)surveyResult
						   onSucceeded:(ObjectBlock)succeededBlock
							   onError:(ErrorBlock)errorBlock
{
	NSDictionary *params = @{@"Survey":surveyResult.jsonString, @"Answer":surveyResult.jsonAnswerString};
	
	RESTfulOperation *op = (RESTfulOperation*) [self operationWithPath:@"surveys/add" params:params httpMethod:@"POST" authenticated:NO];
	[op	addCompletionHandler:^(MKNetworkOperation* completedOperation){
		succeededBlock(completedOperation.responseString);
	} errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
		NSLog(@"Error from posting order: %@", error);
		errorBlock(error);
	}];
	[self enqueueOperation:op];
	return op;
}

@end
