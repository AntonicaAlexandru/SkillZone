//
//  MyProfileViewController.h
//  TestSkillz
//
//  Created by Alexandru Antonica on 3/20/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"

@interface MyProfileViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *myPic;
@property (weak, nonatomic) IBOutlet UITextField *numeTF;
@property (weak, nonatomic) IBOutlet UITextField *prenumeTF;
@property (weak, nonatomic) IBOutlet UITextField *telefonTF;
@property (weak, nonatomic) IBOutlet UITextField *parolaTF;
@property (weak, nonatomic) IBOutlet UITextView *tags;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property   (strong) Person *person;
@end
