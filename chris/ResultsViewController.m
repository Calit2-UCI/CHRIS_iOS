//
//  ResultsViewController.m
//  CHRIS
//
//  Created by Ryan Waggoner on 1/12/13.
//  Copyright (c) 2013 Ryan Waggoner. All rights reserved.
//

#import "ResultsViewController.h"
#import "RESTfulEngine.h"
#import "SurveyResult.h"
#import "AppDelegate.h"
#import "UINavigationController+Fade.h"
#import "MBProgressHUD.h"

@interface ResultsViewController ()

@property (nonatomic, strong) RESTfulEngine *apiEngine;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

- (IBAction)doneAction:(id)sender;
- (IBAction)printAction:(id)sender;
- (IBAction)emailAction:(id)sender;

@end

@implementation ResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.apiEngine = [[RESTfulEngine alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// kick up loading
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	//self.urlString = @"https://chris.hpr.uci.edu/surveys/view/1/123";
	//[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];

	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.apiEngine postSurveyResult:appDelegate.currentSurveyResult onSucceeded:^(id responseObject){
		// remove loading
		NSLog(@"success response: %@", responseObject);
		self.urlString = responseObject;
		[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:responseObject]]];
	} onError:^(NSError *error) {
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		// ask for retry
		NSLog(@"error response: %@", error);
	}];
}

- (IBAction)doneAction:(id)sender {
	[self.navigationController fadePopToRootViewController];
}

- (IBAction)printAction:(id)sender {
	UIPrintInfo *pi = [UIPrintInfo printInfo];
	pi.outputType = UIPrintInfoOutputGeneral;
	pi.jobName = self.webView.request.URL.absoluteString;
	pi.orientation = UIPrintInfoOrientationPortrait;
	pi.duplex = UIPrintInfoDuplexLongEdge;
	
	UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
	pic.printInfo = pi;
	pic.showsPageRange = YES;
	pic.printFormatter = self.webView.viewPrintFormatter;
	[pic presentAnimated:YES completionHandler:^(UIPrintInteractionController *pic2, BOOL completed, NSError *error) {
		// indicate done or error
		NSLog(@"pic: %@", pic2);
		NSLog(@"completed: %@", (completed) ? @"YES" : @"NO");
		NSLog(@"error: %@", error);
	}];
}

- (IBAction)emailAction:(id)sender {
	MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
	[composer setMailComposeDelegate:self];
	if ([MFMailComposeViewController canSendMail]) {
		
		NSString *messageBody = [NSString stringWithFormat:@"Here are the results of the survey: \n%@", self.urlString];
		
		[composer setToRecipients:[NSArray arrayWithObjects:@"", nil]];
		[composer setSubject:@"CHRI Survey Result"];
		[composer setMessageBody:messageBody isHTML:NO];
		//[composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
		[self presentViewController:composer animated:YES completion:nil];
	}
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
@end
