//
//  TodoListEntryCell.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 16.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobiListEntry.h"

@interface TodoListEntryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *checkedSwitch;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *syncIndicator;

- (IBAction)doneSwitchChanged:(id)sender;

@property (nonatomic) MobiListEntry* entry;

+ (float)expectedHeight;

@end