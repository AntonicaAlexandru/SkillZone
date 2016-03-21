//
//  CustomPin.m
//  TestSkillz
//
//  Created by Alexandru Antonica on 3/17/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import "CustomPin.h"

@implementation CustomPin

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description person:(Person*) person{    self = [super init];
    if (self != nil) {
        self.coordinate = location;
        self.title = placeName;
        self.subtitle = description;
        self.person = person;
    }
    return self;
}


-(id)iniWithPerson:(Person *)person{

    return [self
            initWithCoordinates:CLLocationCoordinate2DMake([person.latitude doubleValue], [person.longitude doubleValue])
            placeName:person.prenume
            description:person.nrTelefon
            person:person];
    
}

@end
