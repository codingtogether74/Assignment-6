//
//  VacationTableViewController.m
//  VirtualVacation
//
//  Created by Tatiana Kornilova on 8/15/12.
//
//

#import "VacationTableViewController.h"
#import "VacationHelper.h"

@interface VacationTableViewController ()

@end

@implementation VacationTableViewController

@synthesize vacation=_vacation;

- (void)setVacation:(NSString *)vacation
{
    if (vacation == _vacation) return;
    _vacation = vacation;
    self.title = vacation;
    [VacationHelper sharedVacation:vacation];
}

#pragma mark - View lifecycle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"Show Itinerary"]) {
        [segue.destinationViewController setVacation:self.vacation];
    }
    if ([segue.identifier isEqualToString:@"Show Tags"]) {
        [segue.destinationViewController setVacation:self.vacation];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

#pragma mark - Table view delegate

@end
