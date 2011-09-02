//
//  CocoaToRubyEventMachineAppDelegate.h
//  CocoaToRubyEventMachine
//
//  Created by Scott Haines on 7/28/11.
//  Copyright 2011 Convo Communications. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Connector.h"

@class Connector;

@interface CocoaToRubyEventMachineAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    NSButton *send;
    NSTextField *send_message;
    NSTextField *received_message;
    Connector *connector;
}
@property (assign) Connector *connector;
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSButton *send;
@property (assign) IBOutlet NSTextField *send_message;
@property (assign) IBOutlet NSTextField *received_message;

-(IBAction) connector_send_message:(id) sender;

-(void) receive_data:(NSString *) message;

/*
 Testing communication from Connector class to App Delegate
 */
-(void) message_from_connector:(NSString *) message;

@end
