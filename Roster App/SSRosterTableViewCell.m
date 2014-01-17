//
//  SSRosterTableViewself.m
//  Roster App
//
//  Created by Stevenson on 1/16/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSRosterTableViewCell.h"

@implementation SSRosterTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setStudent:(SSStudent *)student {
    _student = student;
    
    self.backgroundColor = [UIColor clearColor];
    if (!self.thisContentView) {
        self.thisContentView = [[UIView alloc] initWithFrame:CGRectMake(0.f,10,320.f,self.frame.size.height-20)];
        self.thisImageView = [[UIImageView alloc] initWithFrame: CGRectMake(10.f,5.f, 60.f, 60.f)];
        self.contentTitle = [[UILabel alloc] initWithFrame:CGRectMake(78.f, 14.f, 200.f, 21.f)];
        self.contentDetail = [[UILabel alloc] initWithFrame:CGRectMake(78.f, 29.f, 200.f, 21.f)];
        [self.thisContentView addSubview:self.contentTitle];
        [self.thisContentView addSubview:self.contentDetail];
        [self.contentView addSubview:self.thisContentView];
        [self.contentView addSubview:self.thisImageView];
    }
    self.contentTitle.text = [student name];
    [self.contentTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:20]];
    self.contentDetail.text = [student gitHub];
    [self.contentDetail setFont:[UIFont fontWithName:@"HelveticaNeue-ThinItalic" size:11]];
    
    if (![[student image] isEqualToString:@""]) {
        NSString *studentImagePath = [student image];
        UIImage *studentImage = [UIImage imageWithContentsOfFile:studentImagePath];
        self.thisImageView.image = studentImage;
        self.thisImageView.layer.cornerRadius = self.thisImageView.layer.bounds.size.height/2;
        self.thisImageView.layer.masksToBounds = YES;
    } else {
        self.thisImageView.image = nil;
    }
    self.thisContentView.backgroundColor = [UIColor colorWithRed:([[[student RGB] objectAtIndex:0] floatValue])
                                           green:([[[student RGB] objectAtIndex:1] floatValue])
                                            blue:([[[student RGB] objectAtIndex:2] floatValue])
                                           alpha:1];
    
    UIColor *textColor = [UIColor colorWithRed:(1-[[[student RGB] objectAtIndex:0] floatValue])
                                         green:(1-[[[student RGB] objectAtIndex:1] floatValue])
                                          blue:(1-[[[student RGB] objectAtIndex:2] floatValue])
                                         alpha:1];
    self.contentTitle.textColor = textColor;
    self.contentDetail.textColor = textColor;
    
}

@end
