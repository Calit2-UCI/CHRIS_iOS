//
//  PickerPopoverViewController.h
//  CHRIS
//
//  Created by Ryan Waggoner on 1/12/13.
//  Copyright (c) 2013 Ryan Waggoner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerPopoverDelegate <NSObject>
- (void)didSelectItemWithIndex:(NSUInteger)index;
@end

@interface PickerPopoverViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, readwrite) NSUInteger selectedIndex;
@property (nonatomic, assign) id<PickerPopoverDelegate> delegate;
@end
