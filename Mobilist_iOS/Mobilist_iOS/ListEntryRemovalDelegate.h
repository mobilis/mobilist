//
//  ListEntryRemovalDelegate.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 28.05.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobiList.h"
#import "MobiListEntry.h"

@interface ListEntryRemovalDelegate : NSObject <UIAlertViewDelegate>
{
	MobiList* theList;
	NSInteger index;
}

- (id)initWithList:(MobiList* )aList removeIndex:(NSInteger)anIndex;

@end
