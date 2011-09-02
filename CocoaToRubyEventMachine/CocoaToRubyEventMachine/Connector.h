#import <Cocoa/Cocoa.h>
#import "AsyncSocket.h"
#import "CocoaToRubyEventMachineAppDelegate.h"

#define LOCAL_MSG    0
#define ECHO_MSG     1
#define WARNING_MSG  2

#define READ_TIMEOUT 15.0
#define READ_TIMEOUT_EXTENSION 10.0

@class CocoaToRubyEventMachineAppDelegate;

@interface Connector : NSObject {
@private
    CocoaToRubyEventMachineAppDelegate *app; //pointer to main application
    AsyncSocket *socket;
    BOOL isRunning;
}

@property (readwrite, assign) BOOL isRunning;

-(void) setApplicationPointer:(CocoaToRubyEventMachineAppDelegate *) app;
-(void) connectToHost:(NSString *) hostName onPort:(int) port;
-(void) sendMessage:(NSString *) message;
-(void) disconnect;

@end