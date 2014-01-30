//
//  SSDetailViewController.h
//  Roster App
//
//  Created by Stevenson on 1/13/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSStudent.h"
#import "UIImageView+UIImageView_FaceAwareFill.h"

@protocol SSDetailViewDelegate <NSObject>

-(void) sendStudentObject: (SSStudent*) student;
-(void) sendInstructorObject: (SSStudent*) instructor;

@end

@interface SSDetailViewController : UIViewController
@property (strong,nonatomic) SSStudent *student;
@property (unsafe_unretained) id<SSDetailViewDelegate> delegate;

@end
