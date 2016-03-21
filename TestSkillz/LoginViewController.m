//
//  LoginViewController.m
//  TestSkillz
//
//  Created by Alexandru Antonica on 3/18/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import "LoginViewController.h"
#import "JJMaterialTextField.h"
#import <QuartzCore/QuartzCore.h>
#import "AFHTTPSessionManager.h"
#import "SignUpViewController.h"
#import "ViewController.h"
#import "NSString+MD5.h"

static NSString *ipAddres = @"http://192.168.0.103:8090/";
static NSString *tagLoggedIn = @"NO";
static NSString *kCurrentUser = @"kCurrentUser";


@interface LoginViewController()<FBSDKLoginButtonDelegate,UITextFieldDelegate>{
    JJMaterialTextfield *usernameTF;
    JJMaterialTextfield *passwordTF;
    UIImageView *profileIV;
    UILabel *labelOr;
    UIButton *loginBT;
    UIButton *guestBT;
    UIButton *signupBT;
    FBSDKLoginButton *fbButton;
    Person *currentPerson;
    NSString *justRegistredUser;
}

@end

@implementation LoginViewController


-(void)viewWillAppear:(BOOL)animated{
    
    if (![justRegistredUser isEqualToString:@""]) {
        usernameTF.text = justRegistredUser;
    }
    
}

-(void)viewDidLoad{
    [self setUps];

}

-(void) setUps{
    
    
    UIImage *backgroundImage = [UIImage imageNamed:@"background.png"];
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    
    //Username TF
    usernameTF =[[JJMaterialTextfield alloc] initWithFrame:CGRectMake(40, 120, self.view.frame.size.width-80, 34)];
    usernameTF.textColor=[UIColor whiteColor];
    usernameTF.enableMaterialPlaceHolder = YES;
    usernameTF.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    usernameTF.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    usernameTF.tintColor=[UIColor colorWithRed:1 green:0 blue:0 alpha:0];
    usernameTF.placeholder=@"Username";
    usernameTF.translatesAutoresizingMaskIntoConstraints = NO;
    [usernameTF  setSpellCheckingType:UITextSpellCheckingTypeNo];
    usernameTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    usernameTF.autocorrectionType = UITextAutocorrectionTypeNo;
    usernameTF.placeholderAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:13],
                                         NSForegroundColorAttributeName : [[UIColor whiteColor] colorWithAlphaComponent:.8]};
    usernameTF.delegate = self;
    
    
    
    //PasswordTF
    passwordTF =[[JJMaterialTextfield alloc] initWithFrame:CGRectMake(40, 120, self.view.frame.size.width-80, 34)];
    passwordTF.translatesAutoresizingMaskIntoConstraints = NO;
    passwordTF.textColor=[UIColor whiteColor];
    passwordTF.enableMaterialPlaceHolder = YES;
    passwordTF.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    passwordTF.lineColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    passwordTF.tintColor=[UIColor colorWithRed:1 green:0 blue:0 alpha:0];
    passwordTF.placeholder=@"Password";
    passwordTF.secureTextEntry = YES;
    passwordTF.placeholderAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:13],
                                         NSForegroundColorAttributeName : [[UIColor whiteColor] colorWithAlphaComponent:.8]};
    passwordTF.delegate = self;
    
    
    //login button
    loginBT = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-80, 34)];
    loginBT.layer.cornerRadius = 10; // this value vary as per your desire
    loginBT.clipsToBounds = YES;
    loginBT.backgroundColor = [UIColor colorWithRed:99/255.0 green:197/255.0 blue:51/255.0 alpha:1];
    loginBT.translatesAutoresizingMaskIntoConstraints = NO;
    [loginBT setTitle:@"Log In" forState:UIControlStateNormal];
    loginBT.tintColor = [UIColor blackColor];
    loginBT.titleLabel.font = [UIFont systemFontOfSize:15];
    [loginBT addTarget:self action:@selector(loginInAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //sign up
    signupBT = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width-80)/2, 34)];
    signupBT.layer.cornerRadius = 10; // this value vary as per your desire
    signupBT.clipsToBounds = YES;
    signupBT.backgroundColor = [UIColor colorWithRed:95/255.0 green:28/255.0 blue:217/255.0 alpha:0.5];
    signupBT.translatesAutoresizingMaskIntoConstraints = NO;
    [signupBT setTitle:@"Sign Up" forState:UIControlStateNormal];
    signupBT.titleLabel.font = [UIFont systemFontOfSize:15];
    [signupBT addTarget:self action:@selector(signUpAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //guest
    guestBT = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width-80)/2, 34)];
    guestBT.layer.cornerRadius = 10; // this value vary as per your desire
    guestBT.clipsToBounds = YES;
    guestBT.backgroundColor = [UIColor colorWithRed:95/255.0 green:28/255.0 blue:217/255.0 alpha:0.5];
    guestBT.translatesAutoresizingMaskIntoConstraints = NO;
    [guestBT setTitle:@"Guest" forState:UIControlStateNormal];
    guestBT.titleLabel.font = [UIFont systemFontOfSize:15];
    [guestBT addTarget:self action:@selector(guestAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //label
    labelOr = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    labelOr.text = @"or..";
    labelOr.font = [UIFont fontWithName:@"TrebuchetMS-Italic" size:18];
    labelOr.translatesAutoresizingMaskIntoConstraints = NO;
    [labelOr setTextColor:[UIColor whiteColor]];
    
    //facebook button
    fbButton = [[FBSDKLoginButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-80, 34)];
    fbButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    [self.view addSubview:fbButton];
    [self.view addSubview:usernameTF];
    [self.view addSubview:passwordTF];
    [self.view addSubview:signupBT];
    [self.view addSubview:loginBT];
    [self.view addSubview:guestBT];
    [self.view addSubview:labelOr];
    
    
    NSDictionary *viewsDictionary = @{@"user":usernameTF, @"pass":passwordTF, @"logo":self.logoIV, @"guest":guestBT, @"login":loginBT, @"signup":signupBT, @"or":labelOr,@"fb":fbButton};
    
    //Constraints

    //username tf constraints
    
    NSArray *constraint_POS_V_userTF = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[logo]-20-[user]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
   

    NSArray *constraint_POS_V_passTF = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[user]-20-[pass]"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:viewsDictionary];
    
    NSArray *constraint_POS_V_loginBtn = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[pass]-20-[login]"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:viewsDictionary];
    NSArray *constraint_POS_V_guestBtn = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[login]-10-[guest]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:viewsDictionary];
    NSArray *constraint_POS_V_signBtn = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[login]-10-[signup]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:viewsDictionary];
    
    NSArray *constraint_POS_V_labelOr = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[guest]-20-[or]"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:viewsDictionary];
    
    NSArray *constraint_POS_V_fbBtn = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[or]-20-[fb]"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:viewsDictionary];
    
    
    NSString *dinamicWidthUserTf = [NSString stringWithFormat:@"H:[usernameTF(==%lf)]",(self.view.frame.size.width-80)];
    NSString *dinamicWidthPassTf = [NSString stringWithFormat:@"H:[passwordTF(==%lf)]",(self.view.frame.size.width-80)];
    NSString *dinamicWidthLoginBtn = [NSString stringWithFormat:@"H:[loginBT(==%lf)]",(self.view.frame.size.width-80)];
    NSString *dinamicWidthGuestBtn = [NSString stringWithFormat:@"H:[guestBT(==%lf)]",(self.view.frame.size.width-80)/2-5];
    NSString *dinamicWidthSignUpBtn = [NSString stringWithFormat:@"H:[signupBT(==%lf)]",(self.view.frame.size.width-80)/2-5];
    
    [usernameTF addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:dinamicWidthUserTf
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(usernameTF)]];
    [passwordTF addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:dinamicWidthPassTf
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(passwordTF)]];
    
    [loginBT addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:dinamicWidthLoginBtn
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(loginBT)]];
    
    [guestBT addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:dinamicWidthGuestBtn
                                                                    options:0
                                                                    metrics:nil
                                                                      views:NSDictionaryOfVariableBindings(guestBT)]];
    
    [signupBT addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:dinamicWidthSignUpBtn
                                                                    options:0
                                                                    metrics:nil
                                                                      views:NSDictionaryOfVariableBindings(signupBT)]];
    
    NSLayoutConstraint *xCenterConstraint1 = [NSLayoutConstraint constraintWithItem:usernameTF attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *xCenterConstraint2 = [NSLayoutConstraint constraintWithItem:passwordTF attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *xCenterConstraint3 = [NSLayoutConstraint constraintWithItem:loginBT attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *xCenterConstraint4 = [NSLayoutConstraint constraintWithItem:labelOr attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *xCenterConstraint5 = [NSLayoutConstraint constraintWithItem:fbButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    [self.view addConstraint:[NSLayoutConstraint
                                       constraintWithItem:guestBT
                                       attribute:NSLayoutAttributeLeft
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:loginBT
                                       attribute:NSLayoutAttributeLeft
                                       multiplier:1.0
                                       constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:signupBT
                              attribute:NSLayoutAttributeRight
                              relatedBy:NSLayoutRelationEqual
                              toItem:loginBT
                              attribute:NSLayoutAttributeRight
                              multiplier:1.0
                              constant:0.0]];
    
    [self.view  addConstraint:xCenterConstraint1];
    [self.view  addConstraint:xCenterConstraint2];
    [self.view  addConstraint:xCenterConstraint3];
    [self.view  addConstraint:xCenterConstraint4];
    [self.view  addConstraint:xCenterConstraint5];

    [self.view addConstraints:constraint_POS_V_passTF];
    [self.view addConstraints:constraint_POS_V_userTF];
    [self.view addConstraints:constraint_POS_V_loginBtn];
    [self.view addConstraints:constraint_POS_V_signBtn];
    [self.view addConstraints:constraint_POS_V_guestBtn];
    [self.view addConstraints:constraint_POS_V_labelOr];
    [self.view addConstraints:constraint_POS_V_fbBtn];

    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];

}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
  
    [usernameTF resignFirstResponder];
    [passwordTF resignFirstResponder];
}


- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error{
   
    
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    NSLog(@"Log out from app");
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark -
#pragma mark TextFeild Delegate



#pragma mark -
#pragma mark ButtonsActions

-(void)loginInAction:(UIButton*)login{
    
    NSString *username  = usernameTF.text;
    NSString *pass      = passwordTF.text;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *url = [NSString stringWithFormat:@"%@login?username=%@&password=%@",ipAddres,username,[[pass MD5String] lowercaseString]];
    
    [self.view setUserInteractionEnabled:NO];
    
    UIActivityIndicatorView *activInd = [[UIActivityIndicatorView alloc] init];
    [self.view addSubview:activInd];
    
    CGSize size = self.view.frame.size;
    [activInd setCenter:CGPointMake(size.width/2, size.height/2)];
    
    [activInd startAnimating];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Success");
        NSLog(@"%@",responseObject);
        [self.view setUserInteractionEnabled:YES];
        [activInd stopAnimating];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"YES" forKey:@"logged"];

        currentPerson = [[Person alloc] initWithDictionary:responseObject];
        
        //Rmemember user details
        NSArray *array = @[currentPerson];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:array] forKey: kCurrentUser];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        //Continue the flow
         ViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
        mainVC.person = currentPerson;
        [self presentViewController:mainVC animated:YES completion:nil];
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        
        
        //Present Allert
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error at login" message:@"Username or password incorrect!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        [self.view setUserInteractionEnabled:YES];
        [activInd stopAnimating];

    }];

}


-(void)signUpAction:(UIButton*)signup{
    
    //present modal signup
    SignUpViewController *signUpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"signUpVC"];
    signUpVC.delegate = self;
    [self presentViewController:signUpVC animated:YES completion:nil];
}



-(void)guestAction:(UIButton*)guest{
    
    ViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"NO" forKey:@"logged"];
    
    [self presentViewController:mainVC animated:YES completion:nil];
}


#pragma mark -
#pragma mark SignUp delegate methods
-(void)SignUpViewControllerDidReceivePerson:(Person *)person{
    
    justRegistredUser = [NSString stringWithString:person.username];
}
@end
