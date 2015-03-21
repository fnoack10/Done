//
//  List.h
//  Done
//
//  Created by Franco Noack on 3/21/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface List : NSObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSDate *creationDate;
@property (strong, nonatomic) NSNumber *done;
@property (strong, nonatomic) NSNumber *deleted;

@end
