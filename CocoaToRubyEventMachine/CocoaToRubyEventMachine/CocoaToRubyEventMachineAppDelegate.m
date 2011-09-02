//
//  CocoaToRubyEventMachineAppDelegate.m
//  CocoaToRubyEventMachine
//
//  Created by Scott Haines on 7/28/11.
//  Copyright 2011 Convo Communications. All rights reserved.
//

#import "CocoaToRubyEventMachineAppDelegate.h"
#define HOST @"127.0.0.1"
#define PORT 7000

@implementation CocoaToRubyEventMachineAppDelegate

@synthesize window;
@synthesize connector;
@synthesize send;
@synthesize send_message;
@synthesize received_message;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    connector = [[Connector alloc] init];
    [connector setApplicationPointer:self];
    [connector connectToHost:HOST onPort:PORT];
}

-(IBAction) connector_send_message:(id) sender
{
    // check the send_message NSTextField data
    // if data
    // send to eventmachine
    NSLog(@"Try sending this string to the server: %@", [send_message stringValue]);
    [connector sendMessage:[send_message stringValue]];
    [send_message setStringValue:@""];
}

-(void) receive_data:(NSString *)message
{
    NSLog(@"got a message: %@", message);
}

-(void) message_from_connector:(NSString *) message
{
    NSLog(@"message: %@", message);
    [received_message setStringValue:message];
}


@end
