//
//  SSDetailViewController.m
//  Roster App
//
//  Created by Stevenson on 1/13/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSDetailViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>

@interface SSDetailViewController () <UIAlertViewDelegate, UIActionSheetDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *gitHubTextField;
@property (weak, nonatomic) IBOutlet UITextField *twitterTextField;
@property (strong, nonatomic) IBOutlet UIImageView *placeHolder;
@property (strong, nonatomic) UIButton *imageButton;
@property (nonatomic) BOOL isKeyboardVisible;
@property (weak, nonatomic) IBOutlet UISlider *rSlider;
@property (weak, nonatomic) IBOutlet UISlider *gSlider;
@property (weak, nonatomic) IBOutlet UISlider *bSlider;
@property (strong, nonatomic) NSArray *RGB;

@end

@implementation SSDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.placeHolder.userInteractionEnabled = YES;
    
    self.imageButton = [[UIButton alloc] initWithFrame:self.placeHolder.bounds];
    self.imageButton.bounds = self.placeHolder.bounds;
    self.imageButton.backgroundColor = [UIColor clearColor];
    [self.imageButton addTarget:self action:@selector(imagePickerSelectSheet) forControlEvents:UIControlEventTouchUpInside];
    
    [self.placeHolder addSubview:self.imageButton];
    
    self.gitHubTextField.delegate = self;
    self.twitterTextField.delegate = self;

    self.rSlider.maximumValue = 1;
    self.gSlider.maximumValue = 1;
    self.bSlider.maximumValue = 1;
    
    [self.rSlider addTarget:self action:@selector(updateBackgroundColor) forControlEvents:UIControlEventValueChanged];
    [self.gSlider addTarget:self action:@selector(updateBackgroundColor) forControlEvents:UIControlEventValueChanged];
    [self.bSlider addTarget:self action:@selector(updateBackgroundColor) forControlEvents:UIControlEventValueChanged];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardAppeared:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDisappeared:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) viewDidLayoutSubviews {
    self.placeHolder.backgroundColor = [UIColor blueColor];
    CGPoint center = self.placeHolder.center;
    self.placeHolder.bounds = CGRectMake(self.placeHolder.bounds.origin.x, self.placeHolder.bounds.origin.y, self.placeHolder.bounds.size.height, self.placeHolder.bounds.size.height);
    self.placeHolder.center = center;
    self.placeHolder.layer.cornerRadius = self.placeHolder.bounds.size.height/2;
    self.placeHolder.layer.masksToBounds = YES;
    self.placeHolder.contentMode = UIViewContentModeScaleAspectFit;
    self.imageButton.center = CGPointMake(self.placeHolder.bounds.size.width/2, self.placeHolder.bounds.size.height/2);

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadStudentData];
    
    NSString *studentImagePath = [self.student image];
    if ([[NSFileManager defaultManager] fileExistsAtPath:studentImagePath isDirectory:NO]) {
        UIImage *studentImage = [UIImage imageWithContentsOfFile:studentImagePath];
        self.placeHolder.image = studentImage;
    } else {
        [self.imageButton setTitle:@"Add Photo" forState:UIControlStateNormal];
    }

}

-(void)viewWillDisappear:(BOOL)animated {
    [self.delegate sendStudentObject:self.student];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)loadStudentData {
    self.nameLabel.text = [self.student name];
    self.gitHubTextField.text = [self.student gitHub];
    self.twitterTextField.text = [self.student twitter];
    
    self.rSlider.value = [[[self.student RGB] objectAtIndex:0] floatValue];
    self.gSlider.value = [[[self.student RGB] objectAtIndex:1] floatValue];
    self.bSlider.value = [[[self.student RGB] objectAtIndex:2] floatValue];
    
    [self updateBackgroundColor];
}

#pragma mark - UISlider Action Handler Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)updateBackgroundColor {
    self.view.backgroundColor = [UIColor colorWithRed:(self.rSlider.value)
                                                green:(self.gSlider.value)
                                                 blue:(self.bSlider.value)
                                                alpha:1];
    [self.student setRGB:[[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:self.rSlider.value],[NSNumber numberWithFloat:self.gSlider.value],[NSNumber numberWithFloat:self.bSlider.value], nil]];
    UIColor *textColor = [UIColor colorWithRed:(1-self.rSlider.value)
                                     green:(1-self.gSlider.value)
                                      blue:(1-self.bSlider.value)
                                     alpha:1];
    [self refreshTextViews:textColor];
}

-(void) refreshTextViews:(UIColor*) textColor {
    NSArray *allSubViews = [self.view subviews];
    for (id thisView in allSubViews) {
        if ([thisView isKindOfClass:[UILabel class]]) {
            [(UILabel*)thisView setTextColor:textColor];
        }
    }
}

#pragma mark UIAlertViewDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:@"Upgrade your Phone!"] &&
        [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Buying One Now!"]) {
        UIActionSheet *imagePicker;
        imagePicker = [[UIActionSheet alloc] initWithTitle:@"Until then, Get Image From"
                                                  delegate:self cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:nil otherButtonTitles:@"Photo Library", nil];
        [imagePicker showInView:self.placeHolder];
    }
}

#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSURL *)documentDir {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}




#pragma mark UIImagePickerControllerDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)imagePickerController:(UIImagePickerController*) picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *studentImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        self.placeHolder.image = studentImage;
        [self saveStudentImage:studentImage];
        [self.imageButton setTitle:@"" forState:UIControlStateNormal];
    }];
}

-(void) saveStudentImage: (UIImage*) studentImage {
    //save path to student list
    NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[self.student name]];
    NSURL *studentImageURL = [[self documentDir] URLByAppendingPathComponent:imageFileName];
    [self.student setImage:[studentImageURL path]];
    
    //save image
    NSData *studentImageData = UIImagePNGRepresentation(studentImage);
    [studentImageData writeToFile:[studentImageURL path] atomically:YES];
}

#pragma mark - UIImagePicker ActionSheet
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)imagePickerSelectSheet {
    if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *imagePicker;
        imagePicker = [[UIActionSheet alloc] initWithTitle:@"Get Image From"
                                                  delegate:self cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Library", nil];
        
        [imagePicker showInView:self.placeHolder];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade your Phone!" message:@"Time to upgrade your life with an iOS device WITH a camera!" delegate:self cancelButtonTitle:@"Buying One Now!" otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark UIActionSheetDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    UIImagePickerController *myPick = [[UIImagePickerController alloc] init];
    myPick.delegate = self;
    myPick.allowsEditing = YES;
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Camera"]) {
        myPick.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Photo Library"]) {
        myPick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        return;
    }
    [self presentViewController:myPick animated:YES completion:^{
        if (myPick.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
            if (status != ALAuthorizationStatusNotDetermined && status != ALAuthorizationStatusAuthorized) {
                [myPick dismissViewControllerAnimated:YES completion:^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo Access Denied" message:@"Please Provide Access in your Settings. In Settings, enable Roster App in Privacy->Photos" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                }];
            }
        }
    }];
}

#pragma mark UITextFieldDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) keyboardAppeared: (NSNotification *) notification {
    if ( !self.isKeyboardVisible ) {
        self.isKeyboardVisible = YES;
    }
    NSDictionary *info=[notification userInfo];
    CGSize keyboardSize=[[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:.3 animations:^{
        [self.view setFrame:CGRectMake(0,-(keyboardSize.height/2),320,self.view.frame.size.height)];
    }];
    self.navigationItem.hidesBackButton = YES;
}

-(void) keyboardDisappeared: (NSNotification *) notification {
    [UIView animateWithDuration:.3 animations:^{
        [self.view setFrame:CGRectMake(0,0,320,self.view.frame.size.height)];
    }];
    [self.student setGitHub:self.gitHubTextField.text];
    [self.student setTwitter:self.twitterTextField.text];
    self.navigationItem.hidesBackButton = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ( self.gitHubTextField.isFirstResponder ) {
        [self.gitHubTextField resignFirstResponder];
    } else {
        [self.twitterTextField resignFirstResponder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
