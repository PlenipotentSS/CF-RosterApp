//
//  SSDetailViewController.h
//  Roster App
//
//  Created by Stevenson on 1/13/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSDetailViewController : UIViewController
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *instructor;
@property (weak, nonatomic) IBOutlet UIImageView *portraitView;

@end
