//
//  AppDelegate.m
//  JunkFs
//
//  Created by leisuro on 2016/12/19.
//  Copyright © 2016年 leisuro. All rights reserved.
//

#import "AppDelegate.h"
#import "ZLCheckInfo.h"
#import "ZLCheckFileDataViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

//ok!
- (IBAction)OnBT_OpenSelectedDialog:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setMessage:@""];
    [panel setPrompt:@"OK"];
    [panel setCanChooseDirectories:YES];
    [panel setCanCreateDirectories:YES];
    [panel setCanChooseFiles:YES];
    NSString *path_all;
    NSInteger result = [panel runModal];
    if (result == NSFileHandlingPanelOKButton)
    {
        path_all = [[panel URL] path];
        [[ZLCheckInfo sharedInstance] setWorkSpacePath:path_all];
        
        ZLCheckFileDataViewController *vc = (ZLCheckFileDataViewController *)[[[NSApplication sharedApplication] keyWindow] contentViewController];
        if ([vc isKindOfClass:[ZLCheckFileDataViewController class]])
        {
            [vc loadData];
        }
    }
}

- (IBAction)quit:(id)sender {
    exit(0);
}

@end
