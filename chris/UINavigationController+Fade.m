//
//  UINavigationController+Fade.m
//  CHRIS
//
//  Created by Ryan Waggoner on 1/12/13.
//  Copyright (c) 2013 Ryan Waggoner. All rights reserved.
//

#import "UINavigationController+Fade.h"
#import <QuartzCore/QuartzCore.h>

@implementation UINavigationController (Fade)

- (CATransition*) fadeTransition {
	CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
	return transition;
}

- (void)pushFadeViewController:(UIViewController *)viewController {
	[self.view.layer addAnimation:[self fadeTransition] forKey:nil];
	[self pushViewController:viewController animated:NO];
}

- (void)fadePopViewController {
	[self.view.layer addAnimation:[self fadeTransition] forKey:nil];
	[self popViewControllerAnimated:NO];
}

- (void)fadePopToViewController:(UIViewController *)viewController {
	[self.view.layer addAnimation:[self fadeTransition] forKey:nil];
	[self popToViewController:viewController animated:NO];
}

- (void)fadePopToRootViewController {
	[self.view.layer addAnimation:[self fadeTransition] forKey:nil];
	[self popToRootViewControllerAnimated:NO];
	
}

@end
