//
//  main.m
//  contaminated_jar_wp
//
//  Created by Scott Haines on 9/8/11.
//  Copyright 2011 Convo Communications. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 You have 5 jars of pills. Each pill weighs 10 gram, except for contaminated pills contained in one jar, where each pill weighs 9 gm. Given a scale, how could you tell which jar had the contaminated pills in just one measurement?
*/

/*
 Triangular Number:
 number of dots, equally spaced within a triangle
 
 triangle_number(n) = n(n+1)/2
*/

#define NORMAL_JAR 10
#define CONTAMINATED_JAR 9
#define MAX_JARS 5

int triangle_number(n)
{
    int triangleNumber = 0;
    
    triangleNumber = n*(n+1)/2;
    
    return triangleNumber;
}

int main (int argc, const char * argv[])
{

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    int i,weight = 0,target_weight = 0,difference=0;
    
    // setup jars, can be in any random order
    int jars[] = {NORMAL_JAR,CONTAMINATED_JAR,NORMAL_JAR,NORMAL_JAR,NORMAL_JAR};
    //int jars[] = {NORMAL_JAR,NORMAL_JAR,NORMAL_JAR,NORMAL_JAR,CONTAMINATED_JAR};
    //int jars[] = {NORMAL_JAR,NORMAL_JAR,CONTAMINATED_JAR,NORMAL_JAR,NORMAL_JAR};
    
    // take 1 pill from first jar, 2 from second, 3 from third, 4 from fourth, 5 from last
    for(i=0;i<MAX_JARS;++i)
    {
        weight += (i+1)*jars[i]; //weight for the row, compounded
        target_weight += (i+1)*10; // target weight
    }
    
    difference = target_weight - weight;
    NSLog(@"target(%i) : result(%i)",target_weight, weight);
    NSLog(@"difference(%i)",difference);
    
    NSLog(@"Contaminated JAR # (%i) : %i",difference,jars[difference-1]); // grab the number offset and subtract one since Arrays index begins at 0
    
    [pool drain];
    return 0;
}

