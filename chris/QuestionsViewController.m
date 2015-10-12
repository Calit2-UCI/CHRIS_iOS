//
//  QuestionsViewController.m
//  CHRIS
//
//  Created by Ryan Waggoner on 1/12/13.
//  Copyright (c) 2013 Ryan Waggoner. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "QuestionsViewController.h"
#import "ResultsViewController.h"
#import "UINavigationController+Fade.h"
#import "SurveyResult.h"
#import "AppDelegate.h"

typedef enum {
	QuestionSectionTypeGeneral,
	QuestionSectionTypeDiseaseIntro,
	QuestionSectionTypeDisease,
	QuestionSectionTypeOutro
} QuestionSectionType;

@interface QuestionsViewController ()

@property (nonatomic, strong) NSArray *questions;
@property (nonatomic, strong) NSArray *playerItems;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, readwrite) QuestionSectionType currentSectionType;
@property (nonatomic, readwrite) NSUInteger currentQuestion;
@property (nonatomic, readwrite) NSUInteger currentMovie;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *questionButtons;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

- (IBAction) answerAction:(UIButton *)sender;
- (IBAction) okAction:(UIButton *)sender;
- (IBAction) saveAction:(UIButton *)sender;
- (void) playItemAtIndex:(NSUInteger)index;
- (void) loadQuestionPlayerItems;
- (void) restartQuestion;
- (void) advanceToNextQuestion;
- (void) advanceToNextSectionType;

@end

@implementation QuestionsViewController

#pragma mark - view lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		NSString * path = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"];
		self.questions = [[NSArray alloc] initWithContentsOfFile:path];
		_currentMovie = 0;
		_currentQuestion = 0;
		_currentSectionType = QuestionSectionTypeGeneral;
		[self loadQuestionPlayerItems];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self playItemAtIndex:0];
}

- (void)playItemAtIndex:(NSUInteger)index {
	for (UIButton *btn in self.buttons) { btn.hidden = YES; } // hide all buttons
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	self.currentMovie = index;
	self.playerItem = self.playerItems[index];
	
	if (self.player) {
		[self.player replaceCurrentItemWithPlayerItem:self.playerItem];
	} else {
		self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
		[self.player setActionAtItemEnd:AVPlayerActionAtItemEndPause];
		self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
		self.playerLayer.frame = self.view.bounds;
		[self.view.layer addSublayer:self.playerLayer];
		for (UIButton *btn in self.buttons) {
			btn.hidden = YES;
			[self.view bringSubviewToFront:btn];
		}
	}
	
	[self.player play];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
}



- (void) itemDidFinishPlaying {
    
	if (self.currentSectionType == QuestionSectionTypeDiseaseIntro) {
		if (self.currentMovie == 0) {
			self.okButton.hidden = NO;
		} else {
			[self advanceToNextSectionType];
		}
	} else if (self.currentSectionType == QuestionSectionTypeOutro) {
		self.saveButton.hidden = NO;
	} else {
		if (self.currentMovie == 0) {
			// this was main question video
			for (UIButton *btn in self.questionButtons) { btn.hidden = NO; } // show all buttons
		} else if (self.currentMovie == 6) {
			// this was restart
			[self restartQuestion];
		} else {
			// this was a particular answer tap video
			[self advanceToNextQuestion];
		}
	}
}

- (IBAction)answerAction:(UIButton *)sender {
	if (sender.tag != 6) {
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
		NSInteger section = 0;
		if (self.currentSectionType == QuestionSectionTypeGeneral) {
			section = 0;
		} else if (self.currentSectionType == QuestionSectionTypeDisease) {
			section = [appDelegate.currentSurveyResult.condition integerValue];
		}
		[appDelegate.currentSurveyResult addAnswerWithIndex:sender.tag - 1 forQuestion:self.currentQuestion inSection:section];
	}
	[self playItemAtIndex:sender.tag];
}

- (IBAction)okAction:(UIButton *)sender {
	[self playItemAtIndex:1];
}

- (IBAction) saveAction:(UIButton *)sender {
	ResultsViewController *resultsVC = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil];
	[self.navigationController pushFadeViewController:resultsVC];
	
}

- (void) loadQuestionPlayerItems {
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSDictionary *diseaseQuestionsDict = self.questions[[appDelegate.currentSurveyResult.condition integerValue]];
	
	NSMutableArray *filenames = [NSMutableArray array];
	if (self.currentSectionType == QuestionSectionTypeOutro) {
		[filenames addObject:@"CHILD_END"];
	} else if (self.currentSectionType == QuestionSectionTypeGeneral) {
		for (int i = 0; i <= 6; i++) {
			if (i == 0) {
				[filenames addObject:[NSString stringWithFormat:@"%d-MAIN", self.currentQuestion + 1]];
			} else {
				[filenames addObject:[NSString stringWithFormat:@"%d-SEL_%d", self.currentQuestion + 1, i]];
			}
		}
	} else if (self.currentSectionType == QuestionSectionTypeDiseaseIntro) {
		[filenames addObject:[NSString stringWithFormat:@"disease_intro-%@-main", diseaseQuestionsDict[@"abbreviation"]]];
		[filenames addObject:[NSString stringWithFormat:@"disease_intro-%@-SEL", diseaseQuestionsDict[@"abbreviation"]]];
	} else {
		for (int i = 0; i <= 6; i++) {
			if (i == 0) {
				[filenames addObject:[NSString stringWithFormat:@"%d-%@-MAIN", self.currentQuestion + 1, diseaseQuestionsDict[@"abbreviation"]]];
			} else {
				[filenames addObject:[NSString stringWithFormat:@"%d-%@-SEL-%d", self.currentQuestion + 1, diseaseQuestionsDict[@"abbreviation"], i]];
			}
		}
	}
	self.playerItems = nil; // free up some memory here
	NSMutableArray *items = [NSMutableArray array];
	for (NSString *filename in filenames) {
		NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"mov"];
		[items addObject:[AVPlayerItem playerItemWithAsset:[AVAsset assetWithURL:[NSURL fileURLWithPath:path]]]];
	}
	self.playerItems = items;
}

- (void) restartQuestion {
	AVPlayerItem *main = self.playerItems[0];
	[main seekToTime:kCMTimeZero];
	[self playItemAtIndex:0];
}

- (void) advanceToNextQuestion {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSDictionary *diseaseQuestionsDict;
	if (self.currentSectionType == QuestionSectionTypeGeneral) {
		diseaseQuestionsDict = self.questions[0];
	} else if (self.currentSectionType == QuestionSectionTypeDisease) {
		diseaseQuestionsDict = self.questions[[appDelegate.currentSurveyResult.condition integerValue]];
	}
	
	// TEMP for testing!
	//if ((self.currentQuestion + 1) < 3) {
	if ((self.currentQuestion + 1) < [(NSArray *)diseaseQuestionsDict[@"questions"] count]) {
		self.currentQuestion++;
		self.currentMovie = 0;
		[self loadQuestionPlayerItems];
		[self playItemAtIndex:self.currentMovie];
	} else {
		[self advanceToNextSectionType];
	}
}

- (void) advanceToNextSectionType {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	if (self.currentSectionType == QuestionSectionTypeDisease
		|| (self.currentSectionType == QuestionSectionTypeGeneral
			&& [appDelegate.currentSurveyResult.condition integerValue] == 0)
		) {
		self.currentSectionType = QuestionSectionTypeOutro;
		self.currentQuestion = 0;
		self.currentMovie = 0;
		[self loadQuestionPlayerItems];
		[self playItemAtIndex:self.currentMovie];
	} else {
		self.currentSectionType++;
		self.currentQuestion = 0;
		self.currentMovie = 0;
		[self loadQuestionPlayerItems];
		[self playItemAtIndex:self.currentMovie];
	}
}

- (void)viewDidUnload {
	[self setButtons:nil];
	[self setOkButton:nil];
	[self setQuestionButtons:nil];
	[super viewDidUnload];
}

@end
