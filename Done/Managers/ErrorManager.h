//
//  ErrorManager.h
//  Done
//
//  Created by Franco Noack on 3/21/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ErrorManager : NSObject

+ (void) showAlertWithDelegate:(id)delegate forError:(NSError *)error;

@end
