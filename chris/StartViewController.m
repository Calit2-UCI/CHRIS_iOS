//
//  StartViewController.m
//  CHRIS
//
//  Created by Ryan Waggoner on 1/12/13.
//  Copyright (c) 2013 Ryan Waggoner. All rights reserved.
//

#import "StartViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "PickerPopoverViewController.h"
#import "UINavigationController+Fade.h"
#import "WelcomeViewController.h"
#import "ResultsViewController.h"
#import "AppDelegate.h"

#define AGE_POPOVER_TAG 1001
#define CONDITION_POPOVER_TAG 1002

@interface StartViewController ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) AVPlayerItem *playerItem;

- (void) checkValidation;

@end

@implementation StartViewController

#pragma mark - view lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self checkValidation];
	
	NSMutableArray *options = [NSMutableArray array];
	for (int i = 3; i <= 17; i++) {
		[options addObject:[NSString stringWithFormat:@"%d", i]];
	}
	self.ageOptions = options;
	self.conditionOptions = @[@"General", @"Asthma", @"Diabetes", @"Heart Disease", @"Irritable Bowel Disease", @"Juvenile Rhumatoid Arthritis"];
	
	self.formContainerView.layer.cornerRadius = 9.0;
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.playerLayer removeFromSuperlayer];
	
	NSURL *movieUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"intro-animation-main" ofType:@"mov"]];
	self.asset = [AVAsset assetWithURL:movieUrl];
	self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset];
	self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
	self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
	self.playerLayer.frame = self.view.bounds;
	[self.view.layer addSublayer:self.playerLayer];
	
	[self.player setActionAtItemEnd:AVPlayerActionAtItemEndPause];
	[self.player play];
	[self.view bringSubviewToFront:self.formContainerView];
	self.formContainerView.hidden = YES;
	
	// Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	NSLog(@"memory warning start vc");
}

- (void) itemDidFinishPlaying {
    // Will be called when AVPlayer finishes playing playerItem
	self.formContainerView.hidden = NO;
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"intro-bg.png"]];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

- (IBAction)genderChangedAction:(UISegmentedControl *)sender {
	[self checkValidation];
}

- (IBAction)ageOrConditionAction:(UIButton *)sender {
	
	NSArray *options;
	NSUInteger selected;
	NSUInteger tag;
	if (sender == self.conditionButton) {
		options = self.conditionOptions;
		selected = self.selectedCondition;
		tag = CONDITION_POPOVER_TAG;
	} else {
		options = self.ageOptions;
		selected = self.selectedAge;
		tag = AGE_POPOVER_TAG;
	}
	
	PickerPopoverViewController *pickerViewController = [[PickerPopoverViewController alloc] initWithNibName:@"PickerPopoverViewController" bundle:nil];
	pickerViewController.options = options;
	pickerViewController.selectedIndex = selected;
	pickerViewController.delegate = self;
	pickerViewController.view.tag = tag;
	self.pickerPopoverController = [[UIPopoverController alloc] initWithContentViewController:pickerViewController];
	[self.pickerPopoverController presentPopoverFromRect:[self.formContainerView convertRect:sender.frame toView:self.view] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
	[self didSelectItemWithIndex:selected]; // set button right now
	
	[self checkValidation];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[self checkValidation];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self.nameField resignFirstResponder];
	return YES;
}

- (IBAction)startAction:(UIButton *)sender {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate startNewSurvey];
	SurveyResult *result = appDelegate.currentSurveyResult;
	result.name = self.nameField.text;
	result.gender = (self.genderSegmentedControl.selectedSegmentIndex == 0) ? @"Male" : @"Female";
	result.age = [NSNumber numberWithInt:self.selectedAge + 3];
	result.condition = [NSNumber numberWithInt:self.selectedCondition];
	//ResultsViewController *welcomeVC = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil];
	WelcomeViewController *welcomeVC = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
	[self.navigationController pushFadeViewController:welcomeVC];
}

- (void) didSelectItemWithIndex:(NSUInteger)index {
	if (self.pickerPopoverController.contentViewController.view.tag == AGE_POPOVER_TAG) {
		self.selectedAge = index;
		[self.ageButton setTitle:[self.ageOptions objectAtIndex:index] forState:UIControlStateNormal];
	} else if (self.pickerPopoverController.contentViewController.view.tag == CONDITION_POPOVER_TAG) {
		self.selectedCondition = index;
		[self.conditionButton setTitle:[self.conditionOptions objectAtIndex:index] forState:UIControlStateNormal];
	}
}

- (void) checkValidation {
	if ([self.nameField.text length] > 0
		&& self.genderSegmentedControl.selectedSegmentIndex != UISegmentedControlNoSegment
		&& ![[self.ageButton titleForState:UIControlStateNormal] isEqualToString:@"-"]
		&& ![[self.conditionButton titleForState:UIControlStateNormal] isEqualToString:@"-"]
		) {
		self.startButton.enabled = YES;
	} else {
		self.startButton.enabled = NO;
	}
}

@end
