//
//  SSStudent.m
//  Roster App
//
//  Created by Stevenson on 1/13/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSStudent.h"

@interface SSStudent()

@end

@implementation SSStudent

-(instancetype) initWithName: (NSString*) name
                    andImage: (NSString*) image
                  andTwitter: (NSString*) twitter
                   andGitHub: github
                isInstructor: (NSString*) yesNo{
    self = [super self];
    if (self) {
        _name = name;
        _image = image;
        _twitter = twitter;
        _gitHub = github;
        _RGB = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:1],[NSNumber numberWithFloat:1],[NSNumber numberWithFloat:1], nil];
        _isInstructor = yesNo;
    }
    return self;
}

#pragma mark NSCoding
-(id)initWithCoder:(NSCoder *)aDecoder  {
    _name = [aDecoder decodeObjectForKey:@"name"];
    _image =[aDecoder decodeObjectForKey:@"image"];
    _gitHub = [aDecoder decodeObjectForKey:@"github"];
    _twitter = [aDecoder decodeObjectForKey:@"twitter"];
    _RGB = [aDecoder decodeObjectForKey:@"RGB"];
    _isInstructor = [aDecoder decodeObjectForKey:@"isInstructor"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.gitHub forKey:@"github"];
    [aCoder encodeObject:self.twitter forKey:@"twitter"];
    [aCoder encodeObject:self.RGB forKey:@"RGB"];
    [aCoder encodeObject:self.isInstructor forKey:@"isInstructor"];
}

@end
