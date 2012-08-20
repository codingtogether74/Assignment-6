//
//  Place.h
//  VirtualVacation
//
//  Created by Tatiana Kornilova on 8/15/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Itinerary, Photo;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSDate * firstVisited;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) Itinerary *itinerary;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
