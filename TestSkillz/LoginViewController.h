//
//  LoginViewController.h
//  TestSkillz
//
//  Created by Alexandru Antonica on 3/18/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SignUpViewController.h"

@interface LoginViewController : UIViewController<SignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *logoIV;


@end
