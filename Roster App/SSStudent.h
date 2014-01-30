//
//  SSStudent.h
//  Roster App
//
//  Created by Stevenson on 1/13/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSStudent : NSObject <NSCoding>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *imagePath;
@property (nonatomic) NSString *twitter;
@property (nonatomic) NSString *gitHub;
@property (nonatomic) NSArray *RGB;
@property (nonatomic) NSString* isInstructor;

@property (nonatomic) UIImage *theImage;

-(instancetype) initWithName: (NSString*) name
                    andImage: (NSString*) image
                  andTwitter: (NSString*) twitter
                   andGitHub: (NSString*) github
                isInstructor: (NSString*) yesNO;

@end
