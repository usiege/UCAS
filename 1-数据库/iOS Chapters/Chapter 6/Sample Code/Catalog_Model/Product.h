//
//  Product.h
//  Catalog_Model
//
//  Created by Patrick Alessi on 10/23/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) id productID;
@property (nonatomic, retain) NSNumber * quantityOnHand;
@property (nonatomic, retain) NSSet *countries;
@property (nonatomic, retain) NSManagedObject *manufacturer;
@end

@interface Product (CoreDataGeneratedAccessors)

- (void)addCountriesObject:(NSManagedObject *)value;
- (void)removeCountriesObject:(NSManagedObject *)value;
- (void)addCountries:(NSSet *)values;
- (void)removeCountries:(NSSet *)values;

@end
