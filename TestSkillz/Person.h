//
//  Person.h
//  TestSkillz
//
//  Created by Alexandru Antonica on 3/17/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject<NSCoding>

@property (strong) NSString *nume;
@property (strong) NSString *prenume;
@property (strong) NSString *nrTelefon;
@property (strong) NSString *tagsString;
@property  BOOL disponibil;
@property (strong) NSNumber *rating;
@property (strong) NSString *username;
@property  NSInteger idNumber;
@property  (strong) NSNumber *longitude;
@property  (strong) NSNumber *latitude;

-(id)initWithDictionary:(NSDictionary*)dictionary;
-(id)initWithPerson:(Person*)person;
@end
