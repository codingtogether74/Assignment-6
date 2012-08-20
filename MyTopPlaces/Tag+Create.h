//
//  Tag+Create.h
//  VirtualVacation
//
//  Created by Tatiana Kornilova on 8/14/12.
//
//

#import "Tag.h"

@interface Tag (Create)
+ (NSSet *)tagsFromFlickrInfo:(NSDictionary *)flickrInfo
       inManagedObjectContext:(NSManagedObjectContext *)context;

@end
