//
//  PlaceAnnotation.m
//  MyTopPlaces5map
//
//  Created by Tatiana Kornilova on 8/8/12.
//
//

#import "PlaceAnnotation.h"
#import "FlickrFetcher.h"

@implementation PlaceAnnotation

@synthesize place=_place;
+ (PlaceAnnotation *)annotationForPlace:(NSDictionary *)place
{
    PlaceAnnotation *annotation = [[PlaceAnnotation alloc]init];
    annotation.place = place;
    return annotation;
}

-(NSString *)title
{
    NSString *placeFullName = [self.place objectForKey:FLICKR_PLACE_NAME];
    NSArray *placeArray = [placeFullName componentsSeparatedByString:@", "];
    NSString *placeCityName = [placeArray objectAtIndex:0];
    return placeCityName;
}

-(NSString *)subtitle
{
    NSString *placeFullName = [self.place objectForKey:FLICKR_PLACE_NAME];
    NSArray *placeArray = [placeFullName componentsSeparatedByString:@", "];
    NSString *placeRestName;
    if ([placeArray count]<=2) {
        placeRestName = [NSString stringWithFormat:@"%@",[placeArray objectAtIndex:1]];
    } else{
        placeRestName = [NSString stringWithFormat:@"%@, %@",[placeArray objectAtIndex:1],[placeArray objectAtIndex:2]];
    }
    return placeRestName;
}

-(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.place objectForKey:FLICKR_LATITUDE]doubleValue];
    coordinate.longitude = [[self.place objectForKey:FLICKR_LONGITUDE]doubleValue];
    return coordinate;
}


@end
