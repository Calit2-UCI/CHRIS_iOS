//
//  StartViewController.m
//  CHRIS
//
//  Created by Ryan Waggoner on 1/12/13.
//  Copyright (c) 2013 Ryan Waggoner. All rights reserved.
//

#import "WelcomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UINavigationController+Fade.h"
#import "QuestionsViewController.h"

@interface WelcomeViewController ()

@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic) BOOL firstVideoPlayed;

- (void) playNext;

@end

@implementation WelcomeViewController

#pragma mark - view lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
		self.assets = @[
			[AVPlayerItem playerItemWithAsset:[AVAsset assetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"CHILD_START" ofType:@"mov"]]]],
			[AVPlayerItem playerItemWithAsset:[AVAsset assetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"CHILD_START-SEL" ofType:@"mov"]]]]
		];
		
		self.currentMovie = 0;
		self.playerItem = self.assets[self.currentMovie];
		
		self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
		[self.player setActionAtItemEnd:AVPlayerActionAtItemEndPause];
		self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
	}
	return self;
}

- (void)playNext {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	self.currentMovie++;
	self.playerItem = self.assets[self.currentMovie];
	[self.player replaceCurrentItemWithPlayerItem:self.playerItem];
	self.nextButton.hidden = YES;
	self.okButton.hidden = YES;
	[self.player play];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.okButton.hidden = NO;
	self.nextButton.hidden = YES;
	self.playerLayer.frame = self.view.bounds;
	[self.view.layer addSublayer:self.playerLayer];
	[self.view bringSubviewToFront:self.nextButton];
	[self.view bringSubviewToFront:self.okButton];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	NSLog(@"memory warning welcome vc");
}

- (void) itemDidFinishPlaying {
    // Will be called when AVPlayer finishes playing playerItem
	if (self.currentMovie == self.assets.count - 1) {
		// last video is finished, exit
		QuestionsViewController *qVC = [[QuestionsViewController alloc] initWithNibName:@"QuestionsViewController" bundle:nil];
		[self.navigationController pushFadeViewController:qVC];
	} else {
		self.okButton.hidden = NO;
	}
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

- (void)nextAction:(UIButton *)sender {
	if (self.currentMovie == 0 && !self.firstVideoPlayed) {
		self.firstVideoPlayed = YES;
		self.okButton.hidden = YES;
		[self.player play];
	} else {
		[self playNext];
	}

}

@end
