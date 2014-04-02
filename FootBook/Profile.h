//
//  Profile.h
//  FootBook
//
//  Created by Charles Northup on 4/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Profile : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * friended;
@property (nonatomic, retain) NSNumber * numberOfFeet;
@property (nonatomic, retain) NSNumber * shoeSize;
@property (nonatomic, retain) NSNumber * numberOfToes;

@end
