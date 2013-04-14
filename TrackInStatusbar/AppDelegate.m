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
    
    [statusMenu setDelegate:self];
    
    [_statusItem setHighlightMode:YES];


    NSBundle *bundle = [NSBundle mainBundle];
    statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"ico" ofType:@"png"]];
    statusHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"ico-alt" ofType:@"png"]];

    [_statusItem setImage: statusImage];
    [_statusItem setAlternateImage: statusHighlightImage];
    
    
    iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];

    NSLog(@"%@", [[iTunes currentTrack] name]); // Here must be initial song declaration
    
    
    
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(allDistributedNotifications:)
                                                            name:nil
                                                          object:nil];
}






- (void) menuWillOpen:(NSMenu *) aMenu {
    NSDictionary *artistStringAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            [NSFont systemFontOfSize:12.0], NSFontAttributeName,
                                            [NSColor whiteColor], NSForegroundColorAttributeName,
                                            nil];
    
    NSDictionary *titleStringAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                                           [NSFont boldSystemFontOfSize:12.0], NSFontAttributeName,
                                           [NSColor whiteColor], NSForegroundColorAttributeName,
                                           nil];
    
    NSMutableAttributedString *shownStatus = [[NSMutableAttributedString alloc]
                                              initWithString:[NSString stringWithFormat:@"%@ ",
                                                              _artist]
                                              attributes: artistStringAttributes];
    
    NSAttributedString *boldTitle = [[NSAttributedString alloc]
                                     initWithString:[NSString stringWithFormat:@"%@",
                                                     _title]
                                     attributes: titleStringAttributes];
    
    [shownStatus insertAttributedString: boldTitle atIndex: [shownStatus length]];
    
    [_statusItem setAttributedTitle: shownStatus];

}


- (void) menuDidClose:(NSMenu *) aMenu {
    NSShadow * shadow = [NSShadow new];
    [shadow setShadowColor: [NSColor colorWithSRGBRed: 1 green:1 blue:1 alpha:0.4]];
    [shadow setShadowBlurRadius: 0.0f];
    [shadow setShadowOffset: NSMakeSize(0, -1)];
    [shadow set];
    
    NSDictionary *preArtistStringAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                                               [NSFont systemFontOfSize:12.0], NSFontAttributeName,
                                               //[NSColor grayColor], NSForegroundColorAttributeName,
                                               shadow, NSShadowAttributeName,
                                               nil];
    
    NSDictionary *preTitleStringAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              [NSFont boldSystemFontOfSize:12.0], NSFontAttributeName,
                                              //[NSColor grayColor], NSForegroundColorAttributeName,
                                              shadow, NSShadowAttributeName,
                                              nil];
    
    NSMutableAttributedString *preShownStatus = [[NSMutableAttributedString alloc]
                                                 initWithString:[NSString stringWithFormat:@"%@ ",
                                                                 _artist]
                                                 attributes: preArtistStringAttributes];
    
    NSAttributedString *preBoldTitle = [[NSAttributedString alloc]
                                        initWithString:[NSString stringWithFormat:@"%@",
                                                        _title]
                                        attributes: preTitleStringAttributes];
    
    [preShownStatus insertAttributedString: preBoldTitle atIndex: [preShownStatus length]];
    
    [_statusItem setAttributedTitle: preShownStatus];
}




- (void) allDistributedNotifications:(NSNotification *)note {
    
    NSShadow * shadow = [NSShadow new];
    [shadow setShadowColor: [NSColor colorWithSRGBRed: 1 green:1 blue:1 alpha:0.4]];
    [shadow setShadowBlurRadius: 0.0f];
    [shadow setShadowOffset: NSMakeSize(0, -1)];
    [shadow set];
    
    NSDictionary *artistStringAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [NSFont systemFontOfSize:12.0], NSFontAttributeName,
                                //[NSColor grayColor], NSForegroundColorAttributeName,
                                shadow, NSShadowAttributeName,
                                nil];
    
    NSDictionary *titleStringAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            [NSFont boldSystemFontOfSize:12.0], NSFontAttributeName,
                                            //[NSColor grayColor], NSForegroundColorAttributeName,
                                            shadow, NSShadowAttributeName,
                                            nil];
    
    NSString *name = [note name];
    NSDictionary *userInfo = [note userInfo];
    
    if ( [name isEqualToString:@"com.apple.iTunes.playerInfo"] ) {
        
        _clipStatus = [NSString stringWithFormat:@"%@ – %@",
                            [userInfo objectForKey:@"Artist"], [userInfo objectForKey:@"Name"]];
                
        NSMutableAttributedString *shownStatus = [[NSMutableAttributedString alloc]
                                           initWithString:[NSString stringWithFormat:@"%@ ",
                                                           [userInfo objectForKey:@"Artist"]]
                                           attributes: artistStringAttributes];
        
        NSAttributedString *boldTitle = [[NSAttributedString alloc]
                                           initWithString:[NSString stringWithFormat:@"%@",
                                                           [userInfo objectForKey:@"Name"]]
                                           attributes: titleStringAttributes];
        
        [shownStatus insertAttributedString: boldTitle atIndex: [shownStatus length]];

        
        
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

