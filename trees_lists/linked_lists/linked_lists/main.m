//
//  main.m
//  linked_lists
//
//  Created by Scott Haines on 9/10/11.
//  Copyright 2011 Convo Communications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject {
@private
    Node *previous;
    Node *next;
    NSString *name;
}
@property (assign) NSString *name;
@property (retain) Node *previous;
@property (retain) Node *next;

-(void) insertNode:(Node *) n;
-(void) describeNode;
@end

@implementation Node
@synthesize name;
@synthesize next;
@synthesize previous;

-(void) insertNode:(Node *)n
{
    NSLog(@"Insert %@ to right of %@",n.name,name);
    
    if(next != NULL)
    {
        Node *tmp = next;
        tmp.previous = n;
        next = n;
        return;
    }
    else
    {
        next = n;
    }
    
}

-(void) describeNode
{
    NSLog(@"I am %@", self.name);
    if(previous != NULL)
    {
        NSLog(@"My left neighbor is %@", previous.name);
    }
    
    if(next != NULL)
    {
        NSLog(@"My right neighbor is %@", next.name);
    }
    
    if(next == NULL && previous == NULL)
    {
        NSLog(@"I have no neighbors");
    }
}

@end

int main (int argc, const char * argv[])
{

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    Node *a = [[Node alloc] init];
    Node *b = [[Node alloc] init];
    Node *c = [[Node alloc] init];
    Node *d = [[Node alloc] init];
    
    a.previous = NULL;
    a.name = @"aNode";
    a.next = b;
    
    b.name = @"bNode";
    b.previous = a;
    b.next = d;
    
    c.name = @"cNode";
    
    d.name = @"dNode";
    d.previous = b;
    d.next = NULL;
    
    [a describeNode];
    [b describeNode];
    [c describeNode];
    [d describeNode];
    
    [b insertNode:c];
    
    [a describeNode];
    [b describeNode];
    [c describeNode];
    [d describeNode];
    

    [pool drain];
    return 0;
}

