//
//  RESTfulEngine.h
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "RESTfulOperation.h"
#import "SurveyResult.h"

typedef void (^VoidBlock)(void);
typedef void (^ObjectBlock)(id returnObject);
typedef void (^StringBlock)(NSString* aString);
typedef void (^ErrorBlock)(NSError* engineError);
typedef void (^MessageErrorBlock)(NSError* engineError, NSArray* messages);

@interface RESTfulEngine : MKNetworkEngine

- (MKNetworkOperation *)operationWithPath:(NSString *)path
								   params:(NSDictionary *)body
							   httpMethod:(NSString *)method
							authenticated:(BOOL)authenticated;

// POST SURVEY

-(RESTfulOperation *) postSurveyResult:(SurveyResult *)surveyResult
					onSucceeded:(ObjectBlock) succeededBlock
						onError:(ErrorBlock) errorBlock;

@end
