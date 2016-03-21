//
//  ViewController.m
//  TestSkillz
//
//  Created by Alexandru Antonica on 3/17/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import "ViewController.h"
#import "MyProfileViewController.h"
#import "MapViewController.h"
#import "SettingsViewController.h"
#import "AFHTTPSessionManager.h"

static NSString *kCurrentUser = @"kCurrentUser";


@interface ViewController (){
    NSUserDefaults *defaults;
}

@property (strong, nonatomic) NSMutableArray *allViewControllers;
@property (strong, nonatomic) MapViewController *mapVC;
@property (strong, nonatomic) MyProfileViewController *detailsVC;
@property (strong, nonatomic) SettingsViewController *settingsVC;

@property (strong, nonatomic) UIViewController *currentVC;


@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *backgroundImage            = [UIImage imageNamed:@"background.png"];
    UIImageView *backgroundImageView    =[[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image           = backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    if (!defaults) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    
    if (self.person) {
        
        if (defaults)
            defaults = [NSUserDefaults standardUserDefaults];
        
        id saved = [defaults objectForKey:kCurrentUser];
        
        if(saved){
            NSArray *customObjectArray = [NSKeyedUnarchiver unarchiveObjectWithData: saved];
            self.person = [[Person alloc] initWithPerson:customObjectArray[0]];
            NSLog(@"MAIN :%@",self.person);
        }
        
    }

    
    if (![[defaults objectForKey:@"logged"] isEqualToString:@"YES"]) {
        
        [defaults setObject:@"1" forKey:@"radius"];
        [self.segmentControll setEnabled:NO forSegmentAtIndex:0];
        [self.segmentControll setEnabled:NO forSegmentAtIndex:2];
        
        self.mapVC            = [self.storyboard instantiateViewControllerWithIdentifier:@"mapVC"];
        self.allViewControllers = [[NSMutableArray alloc] init];
        [self.allViewControllers addObject:self.mapVC];
        [self setCurrentViewController:self.mapVC];

    }else{
        [defaults setObject:@"5" forKey:@"radius"];
        [self.segmentControll addTarget:self action:@selector(switchViews:) forControlEvents:UIControlEventValueChanged];
        
        
        self.detailsVC        = [self.storyboard instantiateViewControllerWithIdentifier:@"myProfileVC"];
        self.mapVC            = [self.storyboard instantiateViewControllerWithIdentifier:@"mapVC"];
        self.settingsVC       = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsVC"];


        self.allViewControllers = [[NSMutableArray alloc] init];
        [self.allViewControllers addObject:self.detailsVC];
        [self.allViewControllers addObject:self.mapVC];
        [self.allViewControllers addObject:self.settingsVC];
        
        [self setCurrentViewController:self.mapVC];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addAnotherViewControllerWithIndex:(NSInteger)index
{
    UIViewController *viewC = [self.allViewControllers objectAtIndex:(int)index];
    
    [self.currentVC willMoveToParentViewController:nil];
    [self.currentVC.view removeFromSuperview];
    [self.currentVC removeFromParentViewController];
    
    [self.view addSubview:viewC.view];
    viewC.view.bounds = self.containerView.bounds;
    [viewC didMoveToParentViewController:self];
    [self setupConstraintsForChildView:viewC.view];
    [self.view layoutIfNeeded];
    
    self.currentVC = viewC;
}

- (void)setCurrentViewController:(UIViewController *)newViewController
{
    if (self.currentVC == newViewController) { // already set
        return;
    }
    
    [self.currentVC willMoveToParentViewController:nil];
    [self.currentVC.view removeFromSuperview];
    [self.currentVC removeFromParentViewController];
    
    [self addChildViewController:newViewController];
    [self.view addSubview:newViewController.view];
    //    newViewController.view.bounds = self.containerView.bounds;
    [newViewController didMoveToParentViewController:self];
    
    [self setupConstraintsForChildView:newViewController.view];
    [self.view layoutIfNeeded];
    
    self.currentVC = newViewController;
}


- (void)setupConstraintsForChildView:(UIView *)childView
{
    childView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *bindings = NSDictionaryOfVariableBindings(childView, _segmentControll);
    
    NSArray *HConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[childView]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:bindings];
    
    NSArray *VConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_segmentControll]-1-[childView]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:bindings];
    
    [self.view addConstraints:HConstraints];
    [self.view addConstraints:VConstraints];
}
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

#pragma mark -
#pragma mark MyMethods

-(void)switchViews:(UISegmentedControl *)sender{
    
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    
    [self addAnotherViewControllerWithIndex:selectedSegment];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
