//
//  SurveyResult.h
//  CHRIS
//
//  Created by Ryan Waggoner on 1/12/13.
//  Copyright (c) 2013 Ryan Waggoner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SurveyResult : NSObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSNumber * condition;
@property (nonatomic, retain) NSMutableArray * answers;

- (void) addAnswerWithIndex:(NSInteger)answerIndex forQuestion:(NSInteger)questionIndex inSection:(NSInteger)sectionIndex;
- (NSString *)jsonString;
- (NSString *)jsonAnswerString;

@end
