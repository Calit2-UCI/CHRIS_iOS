//
//  SurveyResult.m
//  CHRIS
//
//  Created by Ryan Waggoner on 1/12/13.
//  Copyright (c) 2013 Ryan Waggoner. All rights reserved.
//

#import "SurveyResult.h"

@implementation SurveyResult

- (id)init {
	if (self = [super init]) {
		self.answers = [NSMutableArray array];
	}
	return self;
}

- (void) addAnswerWithIndex:(NSInteger)answerIndex forQuestion:(NSInteger)questionIndex inSection:(NSInteger)sectionIndex {
	NSDictionary *newAnswer = @{
		@"sectionIndex":[NSNumber numberWithInt:sectionIndex],
		@"questionIndex":[NSNumber numberWithInt:questionIndex],
		@"answerIndex":[NSNumber numberWithInt:answerIndex]
	};
	
	[self.answers addObject:newAnswer];
}

- (NSString *)jsonString {
	NSMutableDictionary *selfDictionary = [[self dictionaryWithValuesForKeys:@[@"name", @"gender", @"age"]] mutableCopy];

	NSArray *questions = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"]];
	
	selfDictionary[@"condition"] = questions[self.condition.integerValue][@"name"];
	selfDictionary[@"condition_code"] = questions[self.condition.integerValue][@"abbreviation"];
	
	NSInteger answersTotal = 0;
	for (NSDictionary *answer in self.answers) {
		answersTotal += ((NSNumber *)answer[@"answerIndex"]).integerValue;
	}
	
	selfDictionary[@"answers_total"] = [NSNumber numberWithInt:answersTotal];
	
	
	NSError *writeError = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:selfDictionary options:NSJSONWritingPrettyPrinted error:&writeError];
	NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	return jsonString;
}

- (NSString *)jsonAnswerString {
	
	NSArray *questions = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"]];
	NSArray *answers = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"answers" ofType:@"plist"]];
	
	NSMutableArray *jsonAnswers = [NSMutableArray array];
	for (NSDictionary *answer in self.answers) {
		
		NSInteger sectionIndex = ((NSNumber *)answer[@"sectionIndex"]).integerValue;
		NSInteger questionIndex = ((NSNumber *)answer[@"questionIndex"]).integerValue;
		NSInteger answerIndex = ((NSNumber *)answer[@"answerIndex"]).integerValue;
		
		NSDictionary *question = questions[sectionIndex][@"questions"][questionIndex];
		
		NSInteger answerSetIndex = ((NSNumber *)question[@"answer set"]).integerValue;
		
		NSDictionary *newAnswer = @{
		@"section_number":answer[@"sectionIndex"],
		@"question_number":answer[@"questionIndex"],
		@"question_text":question[@"name"],
		@"answer_number":answer[@"answerIndex"],
		@"answer_text":answers[answerSetIndex-1][answerIndex],
		@"condition_code": questions[self.condition.integerValue][@"abbreviation"]
		};
		
		[jsonAnswers addObject:newAnswer];
	}
	
	NSError *writeError = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonAnswers options:NSJSONWritingPrettyPrinted error:&writeError];
	NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	return jsonString;
}



@end
