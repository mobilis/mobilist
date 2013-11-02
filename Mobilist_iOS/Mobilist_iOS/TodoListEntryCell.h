//
//  TodoListEntryCell.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 16.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobiListEntry.h"

@protocol TodoListEntryCellDelegate <NSObject>

- (void)checkedSwitchStateChange:(UISwitch *)theSwitch forEntry:(MobiListEntry *)entry;

@end

@interface TodoListEntryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *checkedSwitch;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *syncIndicator;

@property (nonatomic) MobiListEntry* entry;
@property (nonatomic, weak) id <TodoListEntryCellDelegate> delegate;

+ (float)expectedHeight;

@end