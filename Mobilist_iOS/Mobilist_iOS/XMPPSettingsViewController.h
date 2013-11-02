//
//  XMPPSettingsViewController.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 16.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "MobiAppDelegate.h"

@interface XMPPSettingsViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, copy) void (^dismissBlock)(void);

@end
