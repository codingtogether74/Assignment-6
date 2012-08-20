//
//  Place+Create.h
//  VirtualVacation
//
//  Created by Tatiana Kornilova on 8/13/12.
//
//

#import "Place.h"

@interface Place (Create)

+ (Place *)placeFromFlickrInfo:(NSDictionary *)flickrInfo
        inManagedObjectContext:(NSManagedObjectContext *)context;

@end
