//
//  DetailsViewController.h
//  TestSkillz
//
//  Created by Alexandru Antonica on 3/17/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
@interface DetailsViewController : UIViewController


@property (weak) Person *personModal;

@property (weak, nonatomic) IBOutlet UILabel *prenumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numeLabel;

@property (weak, nonatomic) IBOutlet UILabel *telefonLabel;

@property (weak, nonatomic) IBOutlet UILabel *ratinsLabel;

@property (weak, nonatomic) IBOutlet UILabel *tags;

@end
