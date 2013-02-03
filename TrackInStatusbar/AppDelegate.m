//
//  AppDelegate.m
//  TrackInStatusbar
//
//  Created by Ivan Kuzmin on 2/3/13.
//  Copyright (c) 2013 Ivan Kuzmin. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

-(void)awakeFromNib{
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [_statusItem setMenu:statusMenu];
    [_statusItem setHighlightMode:YES];
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(allDistributedNotifications:)
                                                            name:nil
                                                          object:nil];
}



- (void) allDistributedNotifications:(NSNotification *)note {
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[NSFont systemFontOfSize:12.0] forKey:NSFontAttributeName];
    
    NSString *name = [note name];
    NSDictionary *userInfo = [note userInfo];
    
    if ( [name isEqualToString:@"com.apple.iTunes.playerInfo"] ) {
        
        _clipStatus = [NSString stringWithFormat:@"%@ – %@",
                            [userInfo objectForKey:@"Artist"], [userInfo objectForKey:@"Name"]];
        
        NSAttributedString *shownStatus = [[NSAttributedString alloc]
                                           initWithString:[NSString stringWithFormat:@"▶ %@: %@",
                                                           [userInfo objectForKey:@"Artist"], [userInfo objectForKey:@"Name"]]
                                           attributes:stringAttributes];
        
        [_statusItem setAttributedTitle: shownStatus];
        
        _title = [userInfo objectForKey:@"Name"];
        _artist = [userInfo objectForKey:@"Artist"];

    }
}



- (IBAction)CopyTitle:(id)sender {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard declareTypes:[NSArray arrayWithObject:NSPasteboardTypeString] owner:self];
    [pasteboard setString:_clipStatus forType:NSPasteboardTypeString];
}

- (IBAction)SearchWithLastFm:(id)sender {
    NSString* lastFm = @"http://www.last.fm/music/";
    NSString* launchUrl = [[NSString stringWithFormat:@"%@%@",
                            lastFm, _artist] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString: launchUrl]];
}

- (IBAction)SearchLirycsWithGoogle:(id)sender {
    NSString* google = @"http://google.com/search?q=";
    NSString* launchUrl = [[NSString stringWithFormat:@"%@%@ – %@+(lyrics)", google, _artist, _title] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString: launchUrl]];
}

- (IBAction)Quit:(id)sender {
    [NSApp terminate:nil];
}

@end

