//
//  SettingsViewController.m
//  TestSkillz
//
//  Created by Alexandru Antonica on 3/18/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginViewController.h"
#import "AFHTTPSessionManager.h"


static NSString *ipPut = @"http://192.168.0.103:8090/";
static NSString *kCurrentUser = @"kCurrentUser";


@interface SettingsViewController(){
    NSUserDefaults *defaults;
}

@end



@implementation SettingsViewController

-(void)viewWillAppear:(BOOL)animated{
    
}


-(void)viewDidLoad{
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    [self.slider setMaximumValue:10];
    
    NSString *radiusStr = [defaults objectForKey:@"radius"];
    if (radiusStr && [radiusStr length] > 0) {
        [self.slider setValue:[radiusStr floatValue] animated:YES];
        
    }else{
        [self.slider setValue:2 animated:YES];

    }
    
    [self.distance setText:[NSString stringWithFormat:@"%.2f km",[self.slider value]]];
    if ([[defaults objectForKey:@"discover"] isEqualToString:@"true"]) {
        [self.discoverable setOn:YES];
    }else{
        [self.discoverable setOn:NO];
    }
    
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.discoverable addTarget:self action:@selector(changedDiscoverability:) forControlEvents:UIControlEventValueChanged];
    
    if (!self.person) {
        if (defaults)
            defaults = [NSUserDefaults standardUserDefaults];
        
        id saved = [defaults objectForKey:kCurrentUser];
        
        if(saved){
            NSArray *customObjectArray = [NSKeyedUnarchiver unarchiveObjectWithData: saved];
            self.person = [[Person alloc] initWithPerson:customObjectArray[0]];
        }
        
    }
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    
    
    NSString *string = [NSString stringWithFormat:@"%.2f",self.slider.value];
    self.distance.text = [NSString stringWithFormat:@"%.2f km",self.slider.value];
    [defaults setObject:string forKey:@"radius"];
    
}

-(IBAction)changedDiscoverability:(UISwitch*)sender{
    
    NSString *reqString;
    BOOL on = false;
    if ([sender isOn]){
        
        on = TRUE;
        reqString =[NSString stringWithFormat:@"%@/user/%d?disponible=true&latitude=%f&longitude=%f",
        ipPut,
        (int)self.person.idNumber,
        [self.person.latitude doubleValue],
        [self.person.longitude doubleValue]];
        [defaults setObject:@"true" forKey:@"discover"];
        NSLog(@"ON");
        NSLog(@"%@",self.person);
    }else{
        reqString =[NSString stringWithFormat:@"%@/user/%d?disponible=false&latitude=0&longitude=0",
                    ipPut,
                    (int)self.person.idNumber];
        NSLog(@"OFF");
        [defaults setObject:@"false" forKey:@"discover"];
    }

    
    NSString *url = reqString;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager PUT:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Updated");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //TODO: allert error occured
        NSLog(@"error:%@",error);
    }];

}

- (IBAction)signOutAction:(UIButton *)sender {
    
    [defaults setObject:@"NO" forKey:@"logged"];
    
}



@end
