//
//  Sqlite.h
//
//  Created by Matteo Bertozzi on 11/22/08.
//  Copyright 2008 Matteo Bertozzi. All rights reserved.
//  Modified by John Basile on 1/29/11.
//  Copyright (c) 2011 Numerics. All rights reserved.
//  Under BSD Lic.


#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Sqlite : NSObject {
	NSInteger busyRetryTimeout;
	NSString *filePath;
	sqlite3 *_db;
}

@property (readwrite) NSInteger busyRetryTimeout;
@property (readonly) NSString *filePath;

//+ (NSString *)createUuid;
+ (NSString *)version;

- (id)initWithFile:(NSString *)filePath;

- (BOOL)open:(NSString *)filePath;
- (void)close;

- (NSInteger)errorCode;
- (NSString *)errorMessage;

- (NSArray *)executeQuery:(NSString *)sql, ...;
- (NSArray *)executeQuery:(NSString *)sql arguments:(NSArray *)args;

- (BOOL)execute:(NSString *)sql, ...;
- (BOOL)execute:(NSString *)sql arguments:(NSArray *)args;

- (BOOL)commit;
- (BOOL)rollback;
- (BOOL)beginTransaction;
- (BOOL)beginDeferredTransaction;

@end

