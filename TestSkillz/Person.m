//
//  Person.m
//  TestSkillz
//
//  Created by Alexandru Antonica on 3/17/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import "Person.h"

static NSString *kUsername = @"kUsername";
static NSString *kName = @"kName";
static NSString *kPrenume = @"kPrenume";
static NSString *kIdUser = @"kIdUser";
static NSString *kNrTelefon = @"kNrTelefon";
static NSString *kLongitudine = @"kLongitudine";
static NSString *kLatitudine = @"kLatitudine";
static NSString *kRating = @"kRating";
static NSString *kTags = @"kTags";
static NSString *kDisponibilitate = @"kDisponibilitate";

@implementation Person

-(id)initWithDictionary:(NSDictionary*)dictionary{
    self = [super init];
    
    if (self) {
        
        
        //after allocation you could set variables:
        self.username  = dictionary[@"userName"];
        self.nume      = dictionary[@"lastName"];
        self.prenume   = dictionary[@"firstName"];
        self.nrTelefon = dictionary[@"phoneNumber"];
        self.idNumber  = [dictionary[@"id"] integerValue];
        self.longitude = dictionary[@"longitude"];
        self.latitude  = dictionary[@"latitude"];
        self.rating    = dictionary[@"rating"];
        self.tagsString = dictionary[@"tags"];
        self.disponibil = (BOOL)dictionary[@"disponibility"];
        
    }
    
    return self;
}

-(id)initWithPerson:(Person*)person{
    
    self = [super init];
    
    if (self) {
        
        
        //after allocation you could set variables:
        self.username  = person.username;
        self.nume      = person.nume;
        self.prenume   = person.prenume;
        self.nrTelefon = person.nrTelefon;
        self.idNumber  = person.idNumber;
        self.longitude = person.longitude;
        self.latitude  = person.latitude;
        self.rating    = person.rating;
        self.tagsString = person.tagsString;
        self.disponibil = person.disponibil;
        
    }
    
    return self;
    
    
}
#pragma mark - NSCoding methods

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.username forKey:kUsername];
    [aCoder encodeObject:self.nume forKey:kName];
    [aCoder encodeObject:self.prenume forKey:kPrenume];
    [aCoder encodeInteger:self.idNumber forKey:kIdUser];
    [aCoder encodeObject:self.nrTelefon forKey:kNrTelefon];
    [aCoder encodeObject:self.longitude forKey:kLongitudine];
    [aCoder encodeObject:self.latitude forKey:kLatitudine];
    [aCoder encodeObject:self.rating forKey:kRating];
    [aCoder encodeObject:self.tagsString forKey:kTags];
    [aCoder encodeBool:self.disponibil forKey:kDisponibilitate];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if(self){
        self.username = [aDecoder decodeObjectForKey:kUsername];
        self.nume = [aDecoder decodeObjectForKey:kName];
        self.prenume = [aDecoder decodeObjectForKey:kPrenume];
        self.idNumber = [aDecoder decodeIntegerForKey:kIdUser];
        self.nrTelefon = [aDecoder decodeObjectForKey:kNrTelefon];
        self.longitude = [aDecoder decodeObjectForKey:kLongitudine];
        self.latitude = [aDecoder decodeObjectForKey:kLatitudine];
        self.rating = [aDecoder decodeObjectForKey:kRating];
        self.tagsString = [aDecoder decodeObjectForKey:kTags];
        self.disponibil = [aDecoder decodeBoolForKey:kDisponibilitate];
        
    }
    
    return self;
}

@end
