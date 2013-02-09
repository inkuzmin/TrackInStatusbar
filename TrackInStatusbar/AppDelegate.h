//
//  AppDelegate.h
//  TrackInStatusbar
//
//  Created by Ivan Kuzmin on 2/3/13.
//  Copyright (c) 2013 Ivan Kuzmin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject  <NSMenuDelegate> {
    IBOutlet NSMenu *statusMenu;
    NSImage *statusHighlightImage;
    NSImage *statusImage;
}

@property NSStatusItem * statusItem;
@property NSString * title;
@property NSString * artist;

@property NSString * clipStatus;

- (IBAction)CopyTitle:(id)sender;
- (IBAction)SearchWithLastFm:(id)sender;
- (IBAction)SearchLirycsWithGoogle:(id)sender;
- (IBAction)Quit:(id)sender;


@end
