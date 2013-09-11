//
//  main.m
//  Reverse_Words_in_Sentance
//
//  Created by Scott Haines on 9/7/11.
//  Copyright 2011 Convo Communications. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <string.h>

/*
 Given an array of characters which form a sentence of words, give an efficient algorithm to reverse the order of the words (not characters) in it.
*/

void swap(char* str, int i, int j){
    char t = str[i];
    str[i] = str[j];
    str[j] = t;
    NSLog(@"swap: %s",str);
}

void reverse_string(char* str, int length){
    for(int i=0; i<length/2; i++){
        swap(str, i, length-i-1);
    }
    NSLog(@"reverse_string: %s",str);
}
void reverse_words(char* str){
    int l = (int) strlen(str);
    //Reverse string
    reverse_string(str,(int) strlen(str));
    int p=0;
    //Find word boundaries and reverse word by word
    for(int i=0; i<l; i++){
        if(str[i] == ' '){
            reverse_string(&str[p], i-p);
            p=i+1;
        }
    }
    //Finally reverse the last word.
    reverse_string(&str[p], l-p);
    
    NSLog(@"%s",str);
}

int main (int argc, const char * argv[])
{

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    char original[] = "This is really cool. Yippie";
    
    reverse_words(original);

    [pool drain];
    return 0;
}

