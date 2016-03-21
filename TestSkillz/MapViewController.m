//
//  MapViewController.m
//  TestSkillz
//
//  Created by Alexandru Antonica on 3/17/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import "MapViewController.h"
#import "CustomPin.h"
#import "DetailsViewController.h"
#import "AFHTTPSessionManager.h"

static NSString *searchAddress = @"http://192.168.0.103:8090/search?";

@interface MapViewController(){
    NSMutableArray *pins;
    MKCircle *circle;
    Person *personStatic;
}

@end

@implementation MapViewController


-(void)viewWillAppear:(BOOL)animated{

    if (locationManager) {
        [locationManager startUpdatingLocation];
        self.mapView.centerCoordinate =[locationManager location].coordinate;
        
        CLLocationCoordinate2D noLocation = [locationManager location].coordinate;
        MKCoordinateRegion viewRegion     = MKCoordinateRegionMakeWithDistance(noLocation, 1700, 1700);
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:adjustedRegion animated:YES ];
        
        [self.mapView removeOverlay:circle];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *number = [defaults objectForKey:@"radius"];
        circle = [MKCircle circleWithCenterCoordinate:[locationManager location].coordinate radius:[number doubleValue]*1000];
        [self.mapView addOverlay:circle];
        [locationManager stopUpdatingLocation];

    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pins = [[NSMutableArray alloc] init];
    
    
    //search bar setups
    self.searchBar.delegate = self;
    
    //Location Manager setups
    locationManager                     = [self initializeManagerLocation];
    locationManager.delegate            = self;
    locationManager.distanceFilter      = kCLDistanceFilterNone;
    locationManager.desiredAccuracy     = kCLLocationAccuracyBest;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [self->locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    
    //Mapview setups
    self.mapView.delegate                       = self;
    self.mapView.showsUserLocation              = YES;
    CLLocationCoordinate2D noLocation           = self.mapView.centerCoordinate;
    MKCoordinateRegion viewRegion               = MKCoordinateRegionMakeWithDistance(noLocation, 1700, 1700);
    MKCoordinateRegion adjustedRegion           = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
     //Add an overlay
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [defaults objectForKey:@"radius"];
    NSLog(@"%@",number);
    circle = [MKCircle circleWithCenterCoordinate:[locationManager location].coordinate radius:[number doubleValue]*1000];
    [self.mapView addOverlay:circle];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [locationManager stopUpdatingLocation];
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------


#pragma mark MapView methods
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    MKCircleRenderer *circleRet = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    [circleRet setFillColor:[UIColor orangeColor]];
    [circleRet setStrokeColor:[UIColor blackColor]];
    [circleRet setLineWidth:0.60];
    [circleRet setAlpha:0.5f];
    
    
    return circleRet;
}

//------------------------------------------------------------------------------


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
 
    CustomPin *pin = (CustomPin*)view.annotation;
    personStatic = pin.person;

}

//------------------------------------------------------------------------------

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    [self.searchBar resignFirstResponder];
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    else
    {
     
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier];
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"CustomPinImg.pgn"];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        [rightButton addTarget:self action:@selector(writeSomething:) forControlEvents:UIControlEventTouchUpInside];
        
        annotationView.rightCalloutAccessoryView = rightButton;
        annotationView.draggable = YES;
        
        return annotationView;
    }
}

-(void)writeSomething:(id)sender{
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Choose an action"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];


    UIAlertAction *call = [UIAlertAction actionWithTitle:@"Call" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        NSString *phNo =personStatic.nrTelefon;
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
        

    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        
                                                    }];
    
    UIAlertAction *goProfil = [UIAlertAction actionWithTitle:@"Profil" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                        DetailsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsVC"];

                                                        viewController.personModal = personStatic;
                                                        
                                                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                        [defaults setObject:@"modal" forKey:@"profil"];
                                                        
                        
                                                        [self presentViewController:viewController animated:YES completion:nil];
                                                        
                                                    }];
                              
    [alert addAction:call];
    [alert addAction:goProfil];
    [alert addAction:cancel];


    [self presentViewController:alert animated:YES completion:nil];

}
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

#pragma mark-
#pragma mark LocationManager methods

-(CLLocationManager *) initializeManagerLocation{
    
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 50;
        
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }
    }
    
    return locationManager;
}

//------------------------------------------------------------------------------

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    [locationManager stopUpdatingLocation];
    
}

//------------------------------------------------------------------------------

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *location = [locations lastObject];
    
    self.mapView.centerCoordinate = location.coordinate;
    self.person.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    self.person.latitude  = [NSNumber numberWithDouble:location.coordinate.latitude];
    [locationManager stopUpdatingLocation];
    
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

#pragma mark -
#pragma mark SearchBar methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.searchBar resignFirstResponder];
  
    if (![self.searchBar.text isEqualToString:@""]) {
        
        NSString *skills = [[self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@";"] lowercaseString];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *distance;
        
        if (![[defaults objectForKey:@"logged"] isEqualToString:@"YES"]) {
            distance = [NSNumber numberWithDouble:2];
        }else{
            NSString *str = [defaults objectForKey:@"radius"];
            distance      =[NSNumber numberWithFloat:[str floatValue]];
        }
        
        
        UIActivityIndicatorView *activInd = [[UIActivityIndicatorView alloc] init];
        [self.view addSubview:activInd];
        
        CGSize size = self.view.frame.size;
        [activInd setCenter:CGPointMake(size.width/2, size.height/2)];
        
        [activInd startAnimating];
        
        

        NSString *url = [NSString stringWithFormat:@"%@tag=%@&latitude=%f&longitude=%f&distance=%f",searchAddress,skills,
                         [locationManager location].coordinate.latitude,
                         [locationManager location].coordinate.longitude,
                         [distance doubleValue]];
        

        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [activInd stopAnimating];
            [activInd setHidden:YES];
            
            //NSLog(@"response object : %@",responseObject);
            [self populateUsersArray:responseObject];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            //TODO: allert error occured
            NSLog(@"error:%@",error);
            [activInd stopAnimating];
            [activInd setHidden:YES];
            [self populateUsersArray:nil];
        }];
    }

}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    [self.searchBar setShowsCancelButton:YES animated:YES];
    return true;
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    [self.searchBar setText:@""];
    [self.mapView removeAnnotations:self.mapView.annotations];

}
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------


#pragma mark-
#pragma mark MyMethods


-(void)populateUsersArray:(NSArray*)array{
    
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [pins removeAllObjects];
    
    for (NSDictionary *dict in array) {
        
        Person *pers = [[Person alloc] initWithDictionary:dict];
        CustomPin *pin = [[CustomPin alloc] iniWithPerson:pers];
        [pins addObject:pers];
        [self.mapView addAnnotation:pin];
        
    }
    
    
    //TODO: Arata cati useri s'au gasit

}
- (IBAction)centerMyLocation:(id)sender {
    
    [locationManager startUpdatingLocation];
    self.mapView.centerCoordinate =[locationManager location].coordinate;
    
    CLLocationCoordinate2D noLocation = [locationManager location].coordinate;
    MKCoordinateRegion viewRegion     = MKCoordinateRegionMakeWithDistance(noLocation, 1700, 1700);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES ];

    [self.mapView removeOverlay:circle];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [defaults objectForKey:@"radius"];
    circle = [MKCircle circleWithCenterCoordinate:[locationManager location].coordinate radius:[number doubleValue]*1000];
    [self.mapView addOverlay:circle];
    [locationManager stopUpdatingLocation];
}

//------------------------------------------------------------------------------

@end
