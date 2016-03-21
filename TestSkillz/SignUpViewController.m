//
//  SignUp.m
//  TestSkillz
//
//  Created by Alexandru Antonica on 3/19/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import "SignUpViewController.h"
#import "AFHTTPSessionManager.h"
#import "NSString+MD5.h"

static NSString *ipSignup = @"http://192.168.0.103:8090/signup?";

@implementation SignUpViewController


-(void)viewDidLoad{
    
    [self.bcgIV setImage:[UIImage imageNamed:@"background"]];
    
    //Dismissing keypad
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    
}




-(IBAction)dismissAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(IBAction)done:(id)sender {
    
    
    if ([self.phone.text isEqualToString:@""] || [self.parola.text isEqualToString:@""] || [self.username.text isEqualToString:@""] || [self.lastName.text isEqualToString:@""] ||
        [self.firstName.text isEqualToString:@""] ) {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please complete all the fields!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        [self.view setUserInteractionEnabled:YES];
        return;
    }
    
    
    
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *url = [NSString stringWithFormat:@"%@firstName=%@&lastName=%@&phone=%@&password=%@&username=%@",ipSignup,self.firstName.text,       self.lastName.text,
                     self.phone.text,
                     [[self.parola.text MD5String] lowercaseString],
                     self.username.text];
    
    [self.view setUserInteractionEnabled:NO];
    
    UIActivityIndicatorView *activInd = [[UIActivityIndicatorView alloc] init];
    [self.view addSubview:activInd];
    
    CGSize size = self.view.frame.size;
    [activInd setCenter:CGPointMake(size.width/2, size.height/2)];
    
    [activInd startAnimating];
    
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Success");
        
        
        Person *person = [[Person alloc] initWithDictionary:responseObject];
        if([self.delegate respondsToSelector:@selector(SignUpViewControllerDidReceivePerson:)])
        {
            [self.delegate SignUpViewControllerDidReceivePerson:person];
        }

        [activInd stopAnimating];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Your request could nod be completed!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        [self.view setUserInteractionEnabled:YES];
        [activInd stopAnimating];

    }];


}


- (IBAction)dimissModal:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
