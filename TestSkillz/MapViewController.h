//
//  MapViewController.h
//  TestSkillz
//
//  Created by Alexandru Antonica on 3/17/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Person.h"

@interface MapViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,UISearchBarDelegate>{
    CLLocationManager *locationManager;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *myLocButton;
@property (weak, nonatomic) Person *person;
@end
