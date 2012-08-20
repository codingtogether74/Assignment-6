//
//  Itinerary+Create.h
//  VirtualVacation
//
//  Created by Tatiana Kornilova on 8/13/12.
//
//

#import "Itinerary.h"

@interface Itinerary (Create)
+ (Itinerary *)singleItineraryInManagedObjectContext:(NSManagedObjectContext *)context;
@end
