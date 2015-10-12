//
//  AppDelegate.h
//  CHRIS
//
//  Created by Ryan Waggoner on 12/14/12.
//  Copyright (c) 2012 Ryan Waggoner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyResult.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SurveyResult *currentSurveyResult;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void) startNewSurvey;
- (void) saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
