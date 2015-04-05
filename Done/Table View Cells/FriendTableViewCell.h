//
//  FriendTableViewCell.h
//  Done
//
//  Created by Franco Noack on 4/5/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendTableViewCell : UITableViewCell

// Views

@property (weak, nonatomic) IBOutlet UIView *iconView;

// Labels

@property (weak, nonatomic) IBOutlet UILabel *iconLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
