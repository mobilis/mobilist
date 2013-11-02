//
//  TodoListEntryCell.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 16.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "TodoListEntryCell.h"

@interface TodoListEntryCell ()

- (IBAction)doneSwitchChanged:(id)sender;

@end

@implementation TodoListEntryCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)doneSwitchChanged:(id)sender {
    [self.delegate checkedSwitchStateChange:self.checkedSwitch forEntry:self.entry];
    [self.syncIndicator startAnimating];
}

+ (float)expectedHeight
{
    return 55.0;
}

@end
