//
//  Place+Create.m
//  VirtualVacation
//
//  Created by Tatiana Kornilova on 8/13/12.
//
//

#import "Place+Create.h"
#import "FlickrFetcher.h"
#import "Itinerary+Create.h"

@implementation Place (Create)

+ (Place *)placeFromFlickrInfo:(NSDictionary *)flickrInfo
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Place *place;
    NSString *name = [flickrInfo objectForKey:FLICKR_PHOTO_PLACE_NAME];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    request.sortDescriptors = [NSArray arrayWithObject:
                               [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                             ascending:YES]];
    NSError *error=nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@"Error in placeFromPhoto: %@ %@", matches, error);
    } else if (![matches count]) {
        place = [NSEntityDescription insertNewObjectForEntityForName:@"Place"
                                              inManagedObjectContext:context];
        place.name = name;
        place.firstVisited = [NSDate date];
        place.itinerary = [Itinerary singleItineraryInManagedObjectContext:context];
    } else {
        place = [matches lastObject];
        if (!place.itinerary)
            place.itinerary = [Itinerary singleItineraryInManagedObjectContext:context];
    }
    return place;
}

@end
