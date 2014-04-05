//
//  Globals.m
//  Ask
//
//  Created by Dinh Ho on 4/4/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import "Globals.h"

@implementation Globals
@synthesize friendsArray;


+(Globals *)sharedGlobals
{
    static Globals *g = nil;
    if (!g)
    {
        g = [[Globals alloc] init];
        g.friendsArray = [[NSMutableArray alloc] init];
    }
    return g;
}

@end
