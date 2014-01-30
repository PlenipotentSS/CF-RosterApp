//
//  SSDetailModelController.h
//  Roster App
//
//  Created by Stevenson on 1/16/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSStudent.h"

@interface SSDetailModelController : NSObject

@property (nonatomic) BOOL isKeyboardVisible;
@property (nonatomic) UIImageView *imageView;

-(SSStudent*) saveStudentImage: (UIImage*) studentImage toStudent:(SSStudent*) student;
@end
