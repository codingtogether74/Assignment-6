//
//  ItineraryTableViewController.h
//  VirtualVacation
//
//  Created by Tatiana Kornilova on 8/13/12.
//
//

#import <UIKit/UIKit.h>
#import "Itinerary.h"

@interface ItineraryTableViewController : UITableViewController
@property (nonatomic, strong) NSString *vacation;
@property (nonatomic, strong) Itinerary *itinerary;

@end
