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
    
    if (![[student image] isEqualToString:@""]) {
        NSString *studentImagePath = [student image];
        UIImage *studentImage = [UIImage imageWithContentsOfFile:studentImagePath];
        self.imageView.image = studentImage;
        
        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.height, self.imageView.frame.size.height);
        
        self.imageView.layer.cornerRadius = self.imageView.layer.bounds.size.height/2;
        self.imageView.layer.masksToBounds = YES;
    } else {
        self.imageView.image = nil;
    }
    UIView *topPaddingView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.x, self.bounds.size.width, 5)];
    topPaddingView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *bottomPaddingView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.frame.size.height-5, self.bounds.size.width, 5)];
    bottomPaddingView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self insertSubview:topPaddingView belowSubview:self.imageView];
    [self insertSubview:bottomPaddingView belowSubview:self.imageView];
    
    self.backgroundColor = [UIColor colorWithRed:([[[student RGB] objectAtIndex:0] floatValue])
                                           green:([[[student RGB] objectAtIndex:1] floatValue])
                                            blue:([[[student RGB] objectAtIndex:2] floatValue])
                                           alpha:1];
    
    self.textLabel.text = [student name];
    self.detailTextLabel.text = [student gitHub];
    UIColor *textColor = [UIColor colorWithRed:(1-[[[student RGB] objectAtIndex:0] floatValue])
                                         green:(1-[[[student RGB] objectAtIndex:1] floatValue])
                                          blue:(1-[[[student RGB] objectAtIndex:2] floatValue])
                                         alpha:1];
    self.textLabel.textColor = textColor;
    self.detailTextLabel.textColor = textColor;
}

@end
