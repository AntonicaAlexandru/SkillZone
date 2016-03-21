//
//  CustomPin.h
//  TestSkillz
//
//  Created by Alexandru Antonica on 3/17/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Person.h"
@interface CustomPin : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) Person *person;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description person:(Person*) person;

-(id)iniWithPerson:(Person*)person;
@end
