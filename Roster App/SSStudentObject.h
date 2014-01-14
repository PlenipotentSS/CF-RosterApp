//
//  SSStudentObject.h
//  Roster App
//
//  Created by Stevenson on 1/13/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSStudentObject : NSObject <NSCoding>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *image;
@property (nonatomic) NSString *twitter;
@property (nonatomic) NSString *gitHub;

-(instancetype) initWithName: (NSString*) name
                    andImage: (NSString*) image
                  andTwitter: (NSString*) twitter
                   andGitHub: github;

@end
