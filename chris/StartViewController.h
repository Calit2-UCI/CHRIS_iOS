//
//  StartViewController.h
//  CHRIS
//
//  Created by Ryan Waggoner on 1/12/13.
//  Copyright (c) 2013 Ryan Waggoner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerPopoverViewController.h"
#import "BaseViewController.h"

@interface StartViewController : BaseViewController <UITextFieldDelegate, PickerPopoverDelegate>

@property (weak, nonatomic) IBOutlet UIView *formContainerView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *ageButton;
@property (weak, nonatomic) IBOutlet UIButton *conditionButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) UIPopoverController *pickerPopoverController;
@property (nonatomic, readwrite) NSInteger selectedAge;
@property (nonatomic, readwrite) NSInteger selectedCondition;
@property (nonatomic, strong) NSArray *ageOptions;
@property (nonatomic, strong) NSArray *conditionOptions;

- (IBAction)genderChangedAction:(UISegmentedControl *)sender;
- (IBAction)ageOrConditionAction:(UIButton *)sender;
- (IBAction)startAction:(UIButton *)sender;

@end
