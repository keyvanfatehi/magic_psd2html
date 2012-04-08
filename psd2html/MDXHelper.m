//
//  MDXHelper.m
//  psd2html
//
//  Created by Keyvan Fatehi on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MDXHelper.h"

#define COMMAND_LEN 64
#define DATA_SIZE 512

@implementation MDXHelper

+ (BOOL) isProcessRunning:(NSString *)processName {
    BOOL running = NO;
    
    NSString *query = [NSString stringWithFormat:@"ps ax | grep %@ | grep -v grep | wc -l", processName];

    FILE *pf;
    char command[COMMAND_LEN];
    char data[DATA_SIZE];
        
    // Execute a process query
    sprintf(command, [query cStringUsingEncoding:NSASCIIStringEncoding]); 
    
    // Setup our pipe for reading and execute our command.
    pf = popen(command,"r"); 
    
    if(!pf){
        fprintf(stderr, "Could not open pipe for output.\n");
        return NO;
    }
    
    // Grab data from process execution
    fgets(data, DATA_SIZE , pf);
    
    int val = [[NSString stringWithUTF8String:data] integerValue];
    if (val == 0)
        NSLog(@"%@ is NOT running (%d)", processName, val);
    else {
        NSLog(@"%@ IS running (%d)", processName, val);
        running = YES;
    }
    
    if (pclose(pf) != 0)
        fprintf(stderr," Error: Failed to close command stream \n");
    
    return running;
}

@end
