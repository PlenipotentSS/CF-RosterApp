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
#import "SSDetailModelController.h"
#import "SSDetailScrollView.h"

@interface SSDetailViewController () <UIScrollViewDelegate, UIActionSheetDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *gitHubTextField;
@property (weak, nonatomic) IBOutlet UITextField *twitterTextField;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *rSlider;
@property (weak, nonatomic) IBOutlet UISlider *gSlider;
@property (weak, nonatomic) IBOutlet UISlider *bSlider;
@property (weak, nonatomic) IBOutlet SSDetailScrollView *scrollView;


@property (strong, nonatomic) UIButton *imageButton;
@property (strong, nonatomic) SSDetailModelController *detailModel;

@end

@implementation SSDetailViewController

static CGFloat scrollViewCurrentOffset;

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
    
    //create model controller instance
    self.detailModel = [[SSDetailModelController alloc] init];
    self.detailModel.imageView = self.imageView;
    
    //allow button to activate in uiimageview
    self.imageView.userInteractionEnabled = YES;
    
    //add button to uiimage view
    self.imageButton = [[UIButton alloc] initWithFrame:self.imageView.bounds];
    self.imageButton.bounds = self.imageView.bounds;
    self.imageButton.backgroundColor = [UIColor clearColor];
    [self.imageButton addTarget:self action:@selector(imagePickerSelectSheet) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:self.imageButton];
    
    //set delegate of uitextfields
    self.gitHubTextField.delegate = self;
    self.twitterTextField.delegate = self;

    //configurations for sliders
    [self setupSlider];
    
    //setup scrollview for detailview
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, (self.bSlider.frame.origin.y+self.bSlider.frame.size.height+20));
    self.scrollView.delegate = self;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    //listener for keyboard appeared
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardAppeared:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadStudentData];
    
    NSString *studentImagePath = [self.student image];
    if ([[NSFileManager defaultManager] fileExistsAtPath:studentImagePath isDirectory:NO]) {
        UIImage *studentImage = [UIImage imageWithContentsOfFile:studentImagePath];
        self.imageView.image = studentImage;
        [self.imageView faceAwareFill];
    } else {
        [self.imageButton setTitle:@"Add Photo" forState:UIControlStateNormal];
        [self.imageButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:25.0]];
    }
    
    self.imageView.layer.cornerRadius = self.imageView.bounds.size.height/2;
    self.imageView.layer.masksToBounds = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    if (self.student.isInstructor && ![[self.student isInstructor] isEqualToString:@""])
        [self.delegate sendInstructorObject:self.student];
    else
        [self.delegate sendStudentObject:self.student];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initial Load methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) setupSlider {
    [self.rSlider setThumbImage:[UIImage imageNamed:@"RSliderButton.png"] forState:UIControlStateNormal];
    [self.gSlider setThumbImage:[UIImage imageNamed:@"GSliderButton.png"] forState:UIControlStateNormal];
    [self.bSlider setThumbImage:[UIImage imageNamed:@"BSliderButton.png"] forState:UIControlStateNormal];
    [self.rSlider addTarget:self action:@selector(updateBackgroundColor) forControlEvents:UIControlEventValueChanged];
    [self.gSlider addTarget:self action:@selector(updateBackgroundColor) forControlEvents:UIControlEventValueChanged];
    [self.bSlider addTarget:self action:@selector(updateBackgroundColor) forControlEvents:UIControlEventValueChanged];
}


#pragma mark load student data to detail view outlets
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)loadStudentData {
    self.nameLabel.text = [self.student name];
    self.gitHubTextField.text = [self.student gitHub];
    self.twitterTextField.text = [self.student twitter];
    
    self.rSlider.value = [[[self.student RGB] objectAtIndex:0] floatValue];
    self.gSlider.value = [[[self.student RGB] objectAtIndex:1] floatValue];
    self.bSlider.value = [[[self.student RGB] objectAtIndex:2] floatValue];
    
    [self updateBackgroundColor];
}

#pragma mark UIResponder to touches
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.scrollView.dragging){
    } else {
        if ( self.gitHubTextField.isFirstResponder ) {
            [self.gitHubTextField resignFirstResponder];
        } else {
            [self.twitterTextField resignFirstResponder];
        }
    }
}

#pragma mark - UITextFieldDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, scrollViewCurrentOffset);
    }];
    [self.student setGitHub:self.gitHubTextField.text];
    [self.student setTwitter:self.twitterTextField.text];
    self.navigationItem.hidesBackButton = NO;
    self.imageView.userInteractionEnabled = YES;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark observers for keyboard
- (void) keyboardAppeared: (NSNotification *) notification {
    if ( !self.detailModel.isKeyboardVisible ) {
        self.detailModel.isKeyboardVisible = YES;
    }
    NSDictionary *info=[notification userInfo];
    CGSize keyboardSize=[[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:.3 animations:^{
        scrollViewCurrentOffset = self.scrollView.contentOffset.y;
        self.scrollView.contentOffset = CGPointMake(0, scrollViewCurrentOffset+(keyboardSize.height)/2);
    }];
    self.navigationItem.hidesBackButton = YES;
    self.imageView.userInteractionEnabled = NO;
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
                                     alpha:7];
    [self refreshTextViews:textColor];
}

-(void) refreshTextViews:(UIColor*) textColor {
    NSArray *allSubViews = [self.scrollView subviews];
    for (id thisView in allSubViews) {
        if ([thisView isKindOfClass:[UILabel class]]) {
            [(UILabel*)thisView setTextColor:textColor];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)imagePickerController:(UIImagePickerController*) picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *studentImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        [UIImageView animateWithDuration:1 animations:^{
            self.imageView.image = studentImage;
            [self.imageView faceAwareFill];
        }];
        self.student = [self.detailModel saveStudentImage: studentImage toStudent:self.student];
        [self.imageButton setTitle:@"" forState:UIControlStateNormal];
    }];
}


#pragma mark - UIActionSheetDelegate
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

#pragma mark UIImagePicker ActionSheet
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)imagePickerSelectSheet {
    if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *imagePicker;
        imagePicker = [[UIActionSheet alloc] initWithTitle:@"Get Image From"
                                                  delegate:self cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Library", nil];
        
        [imagePicker showInView:self.imageView];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade your Phone!" message:@"Time to upgrade your life with an iOS device WITH a camera!" delegate:self cancelButtonTitle:@"Buying One Now!" otherButtonTitles:nil];
        [alert show];
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
        [imagePicker showInView:self.imageView];
    }
}


@end
