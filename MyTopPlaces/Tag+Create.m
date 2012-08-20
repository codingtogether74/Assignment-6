//
//  Tag+Create.m
//  VirtualVacation
//
//  Created by Tatiana Kornilova on 8/14/12.
//
//

#import "FlickrFetcher.h"
#import "Tag+Create.h"

@implementation Tag (Create)
+ (NSSet *)tagsFromFlickrInfo:(NSDictionary *)flickrInfo
       inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *tagStrings = [[flickrInfo objectForKey:FLICKR_TAGS] componentsSeparatedByString:@" "];
    if (![tagStrings count]) return nil;
    
//---------- Build fetch request.-----------
    NSFetchRequest *request           = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.sortDescriptors           = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    NSRange range;
    NSArray *matches;
    NSError *error;
    Tag *tag;
    NSMutableSet *tags = [NSMutableSet setWithCapacity:[tagStrings count]];
    for (NSString *tagName in tagStrings) {
        tag = nil;
        if (!tagName || [tagName isEqualToString:@""]) continue;
//-------- Per assignment, reject tags with a colon ":"
        range = [tagName rangeOfString:@":"];
        if (range.location != NSNotFound) continue;
        
        error = nil;
//---------- Build fetch request.-----------
        request.predicate             = [NSPredicate predicateWithFormat:@"name = %@", [tagName capitalizedString]];
//---------- Execute fetch request.-----------
        matches                       = [context executeFetchRequest:request error:&error];
        if (!matches || ([matches count] > 1) || error) {
            NSLog(@"Error in tagsFromFlickrInfo: %@ %@", matches, error);
        } else if (![matches count]) {
//------------- Create new tag if one doesn't already exist, otherwise retrieve the tag already on-file.
            tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag"
                                                inManagedObjectContext:context];
            tag.name = [tagName capitalizedString];
            tag.count = [NSNumber numberWithInt:1];
        } else {
            tag = [matches lastObject];
            tag.count = [NSNumber numberWithInt:[tag.count intValue] + 1];
        }
//----------- Add the tag to the set.----------
        if (tag) [tags addObject:tag];
    }
    return tags;
}


@end
