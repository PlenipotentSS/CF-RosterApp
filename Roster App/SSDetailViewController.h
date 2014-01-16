//
//  SSDetailViewController.h
//  Roster App
//
//  Created by Stevenson on 1/13/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSStudent.h"

@protocol SSDetailViewDelegate <NSObject>

-(void) sendStudentObject: (SSStudent*) student;

@end

@interface SSDetailViewController : UIViewController
@property (strong,nonatomic) SSStudent *student;
@property (unsafe_unretained) id<SSDetailViewDelegate> delegate;

@end
