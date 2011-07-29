#import "Connector.h"

@implementation Connector

@synthesize isRunning;

-(id) init
{
    if (!(self = [super init]))
        return nil;
    socket = [[AsyncSocket alloc] initWithDelegate:self];
    [self setIsRunning:NO];
    return self;
}

-(void) setApplicationPointer:(CocoaToRubyEventMachineAppDelegate *)application
{
    NSLog(@"APPLICATION POINTER: %@",application);
    app = application;
}

-(void) connectToHost:(NSString *) hostName onPort:(int) port
{
    NSLog(@"Fired method connectToHost");
    if (![self isRunning])
    {
        if(port < 0 || port > 65535)
            port = 0;
        NSError *error = nil;
        NSLog(@"ran this far. passed port test");
        if(![socket connectToHost:hostName onPort:port withTimeout:-1 error:&error])
        {
            NSLog(@"Error connecting to server: %@", error);
            return;
        }
        NSLog(@"connected");
        [self setIsRunning:YES];
    }
    else
    {
        NSLog(@"Connection established");
    }
}

-(void) sendMessage:(NSString *)message
{
    NSLog(@"send the following message: %@", message);
    NSString *messageFormat = [[NSString alloc] initWithFormat:@"%@\r\n",message];
	NSData *messageData = [messageFormat dataUsingEncoding:NSUTF8StringEncoding];
    // GC messageFormat
    [messageFormat release];
    
	[socket writeData:messageData withTimeout:-1 tag:LOCAL_MSG];
    /*
     if with timeout, this disconnects from the server. set as -1 to trump that
     */
	[socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:0];
}

-(void) disconnect
{
    [socket disconnect];
}

-(void) dealloc
{
    NSLog(@"deallocation");
    [super dealloc];
    [socket disconnect];
    [socket dealloc];
}

#pragma mark AsyncSocket Delegate 

/*
 When data is read on the socket eqiv: EventMachine (receive_data)
 */
-(void) onSocket:(AsyncSocket *) sock didReadData:(NSData *) data withTag:(long) tag
{
    NSLog(@"message on socket");
    NSData *truncatedData = [data subdataWithRange:NSMakeRange(0,[data length] -1)];
    NSString *message = [[[NSString alloc] initWithData:truncatedData encoding:NSASCIIStringEncoding] autorelease];
    if(message)
    {
        NSLog(@"%@", message);
        [app message_from_connector:message];
    }
    else
    {
        NSLog(@"Error converting received data into UTF-8 String");
    }
    [sock readDataToData:[AsyncSocket LFData] withTimeout: -1 tag:0];
}

/*
 Callback once the socket connection is finished establishing connection
 like EventMachine post_init
 */
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"socket didConnectToHost: %@ %i",host,port);
    NSString *message = [[[NSString alloc] initWithFormat:@"socket is now connected on %@:%i", host, port] autorelease];
    [app message_from_connector:message];
}

/*
 Some data is made available on the socket
 */
- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"data got partial read on socket");
}

/*
 Wrote to socket (tags:LOCAL_MSG, ECHO_MSG, WARNING_MSG)
 */
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"socket did write data on the socket");
}

/*
 Socket is disconnected
 */
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"socket is disconnected");
    [app message_from_connector:@"socket disconnected"];
}

@end

