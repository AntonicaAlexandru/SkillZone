//
//  SignUp.h
//  TestSkillz
//
//  Created by Alexandru Antonica on 3/19/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"


@protocol SignUpViewControllerDelegate <NSObject>

@optional
- (void) SignUpViewControllerDidReceivePerson:(Person*)person;

@end

@interface SignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *bcgIV;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *parola;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *phone;


// We choose a name here that expresses what object is doing the delegating
@property (nonatomic, weak) id<SignUpViewControllerDelegate> delegate;

@end
