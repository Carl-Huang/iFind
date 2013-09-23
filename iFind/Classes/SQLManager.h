//
//  SQLManager.h
//  Fmdb_manipulate
//
//  Created by vedon on 23/9/13.
//  Copyright (c) 2013 com.vedon. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;
@interface SQLManager : NSObject
@property (retain ,nonatomic)FMDatabase *db;
@end
