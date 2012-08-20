//
//  VacationPhotosTableViewController.h
//  VirtualVacation
//
//  Created by Tatiana Kornilova on 8/13/12.
//
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Place.h"
#import "Tag.h"

@interface VacationPhotosTableViewController : CoreDataTableViewController


@property (nonatomic, strong) NSString *vacation;
@property (nonatomic, strong) Place *place;
@property (nonatomic, strong) Tag *tag;

@end
