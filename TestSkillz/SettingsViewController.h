//
//  SettingsViewController.h
//  TestSkillz
//
//  Created by Alexandru Antonica on 3/18/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISwitch *discoverable;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (strong) Person *person;
@end
