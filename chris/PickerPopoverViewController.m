//
//  PickerPopoverViewController.m
//  CHRIS
//
//  Created by Ryan Waggoner on 1/12/13.
//  Copyright (c) 2013 Ryan Waggoner. All rights reserved.
//

#import "PickerPopoverViewController.h"

@interface PickerPopoverViewController ()

@end

@implementation PickerPopoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contentSizeForViewInPopover = CGSizeMake(320, 216);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.pickerView reloadAllComponents];
    [self.pickerView selectRow:self.selectedIndex inComponent:0 animated:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [self.options count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [self.options objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.selectedIndex = row;
	[[self delegate] didSelectItemWithIndex:row];
}

@end
