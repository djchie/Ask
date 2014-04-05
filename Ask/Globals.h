//
//  Globals.h
//  Ask
//
//  Created by Dinh Ho on 4/4/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Globals : NSObject

+(Globals *)sharedGlobals;

@property(nonatomic, strong)NSMutableArray *friendsArray;
@end
