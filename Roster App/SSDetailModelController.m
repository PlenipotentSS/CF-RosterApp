//
//  SSDetailModelController.m
//  Roster App
//
//  Created by Stevenson on 1/16/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSDetailModelController.h"

@implementation SSDetailModelController

-(instancetype) init {
    self = [super init];
    if (self) {
        self.isKeyboardVisible = NO;
    }
    return self;
}

#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSURL *)documentDir {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(SSStudent*) saveStudentImage: (UIImage*) studentImage toStudent:(SSStudent*) student {
    //save path to student list
    NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[student name]];
    NSURL *studentImageURL = [[self documentDir] URLByAppendingPathComponent:imageFileName];
    [student setImage:[studentImageURL path]];
    
    //save image
    NSData *studentImageData = UIImagePNGRepresentation(studentImage);
    [studentImageData writeToFile:[studentImageURL path] atomically:YES];
    return student;
}



@end
