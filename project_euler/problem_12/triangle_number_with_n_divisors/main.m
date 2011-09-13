//
//  main.m
//  triangle_number_with_n_divisors
//
//  Created by Scott Haines on 9/12/11.
//

#import <Foundation/Foundation.h>

/*
 Brute Force: Find first Triangular Number with 500 or more divisors
*/

/*
 Make Triangle Number
*/
unsigned long long calculate_triangle_number(int n)
{
    unsigned long long tNum = 0;
    tNum = n * (n+1) / 2;
    return tNum;
}

/*
 Get Divisors of Triangle Number
*/
int get_divisors_of(unsigned long long triangle_number)
{
    int result = 0;
    int divisors = 0;
    int j = 1;
    
    for(;j <= (int) sqrt(triangle_number);++j)
    {
        result = (int) triangle_number % j;
        if(result == 0)
            divisors++;
    }

    //NSLog(@"triangle_number: %llu has %i divisors",triangle_number,divisors);
    return (divisors*2);
}

/*
 (Future) - Try getting factors of a number, rather than doing all division in Brute Force time
*/
void get_factors_of(unsigned long long n)
{
    // factors of a number 2*3*4 = 36
}

/*
 Main Program Loop
 1. set target to 500 (we want 500 or more divisors for our Triangle Number
 2. loop until this criteria is met
*/

int main (int argc, const char * argv[])
{

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int result = 0; // store the resulting number of divisors
    unsigned long long tNum = 0; // store the triangle number that generated said divisors
    unsigned long long atNum;
    int div;
    int i = 1;
    
    /*
     run until we have a result
    */
    
    
    for(;i<=12500;++i)
    {
        atNum = calculate_triangle_number(i);
        div = get_divisors_of(atNum);
        if(div > result)
        {
            result = div;
            tNum = atNum;
        }
        i++;
    }
    
    /*
     Display the number of Divisors and the triangle number that generated this
    */
    
    NSLog(@"result: %i",result);
    NSLog(@"triangle_number: %llu",tNum);

    [pool drain];
    return 0;
}

