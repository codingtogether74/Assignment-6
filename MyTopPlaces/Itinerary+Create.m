//
//  Itinerary+Create.m
//  VirtualVacation
//
//  Created by Tatiana Kornilova on 8/13/12.
//
//

#import "Itinerary+Create.h"

@implementation Itinerary (Create)
+ (Itinerary *)singleItineraryInManagedObjectContext:(NSManagedObjectContext *)context
{
    Itinerary *itinerary;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Itinerary"];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || ([matches count] > 1 || error)) {
        NSLog(@"Error in singleItineraryInManagedObjectContext: %@ %@", matches, error);
    } else if ([matches count] == 0) {
        itinerary = [NSEntityDescription insertNewObjectForEntityForName:@"Itinerary"
                                                  inManagedObjectContext:context];
    } else {
        itinerary = [matches lastObject];
    }
    //NSLog(@"itinerary %@", itinerary);
    return itinerary;
}

@end
