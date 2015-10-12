//
//  StartViewController.h
//  CHRIS
//
//  Created by Ryan Waggoner on 1/12/13.
//  Copyright (c) 2013 Ryan Waggoner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface WelcomeViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@property (nonatomic, weak) IBOutlet UIButton *okButton;
@property (nonatomic, readwrite) NSUInteger currentMovie;

- (IBAction)nextAction:(UIButton *)sender;

@end
