//
//  SSRosterTableViewCell.h
//  Roster App
//
//  Created by Stevenson on 1/16/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSStudent.h"
#import "UIImageView+UIImageView_FaceAwareFill.h"

@interface SSRosterTableViewCell : UITableViewCell

@property (nonatomic) UIView *thisContentView;
@property (nonatomic) UIImageView *thisImageView;
@property (nonatomic) UILabel *contentTitle;
@property (nonatomic) UILabel *contentDetail;

@property (nonatomic) SSStudent* student;

@end
