//
//  DetailsViewController.m
//  TestSkillz
//
//  Created by Alexandru Antonica on 3/17/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import "DetailsViewController.h"

static NSString *kCurrentUser = @"kCurrentUser";

@implementation DetailsViewController



- (IBAction)dismissThisViewController:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)viewDidLoad{
    
    [super viewDidLoad];

    [self updateViewsWithPerson:self.personModal];
    
}


- (IBAction)callAction:(id)sender {
    
    NSString *phNo =self.personModal.nrTelefon;
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    } else
    {
        UIAlertController* calert = [UIAlertController alertControllerWithTitle:@"Error" message:@"We could not make the call." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }];
        
        
        [calert addAction:ok];
        [self presentViewController:calert animated:YES completion:nil];
    }

    
    
}

-(void)updateViewsWithPerson:(Person*)person{
    
    self.numeLabel.text = self.personModal.nume;
    self.prenumeLabel.text = self.personModal.prenume;
    self.telefonLabel.text = self.personModal.nrTelefon;
    self.ratinsLabel.text = [self.personModal.rating stringValue];
    self.tags.text = self.personModal.tagsString;
    
    
}
- (IBAction)exitModal:(id)sender {
    [self dismissThisViewController:self];
}
@end
