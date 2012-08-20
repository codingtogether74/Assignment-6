//
//  VacationsTableViewController.m
//  VirtualVacation
//
//  Created by Tatiana Kornilova on 8/13/12.
//
//

#import "VacationsTableViewController.h"
#import "VacationHelper.h"
#import "AddVacationViewController.h"
#import "VacationPhotosTableViewController.h"

@interface VacationsTableViewController () <AddVacationViewControllerDelegate>

@property (nonatomic, strong) UIPopoverController *popoverController; 
@end

@implementation VacationsTableViewController
@synthesize vacations = _vacations;
@synthesize popoverController;


#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [VacationHelper createTestDatabase];
    self.vacations = [VacationHelper getVacations];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - AddVacation delegate

- (void)addVacationViewController:(AddVacationViewController *)sender
                    addedVacation:(NSString *)vacation
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
    self.vacations = [VacationHelper getVacations];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.vacations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Vacations Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text= [self.vacations objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"Show Vacation"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSString *vacation=[self.vacations objectAtIndex:indexPath.row];
        [segue.destinationViewController setVacation:vacation];
    }
    if ([segue.identifier isEqualToString:@"Add Vacation"]) {
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *) segue;
            [self.popoverController dismissPopoverAnimated:YES];
            self.popoverController = popoverSegue.popoverController;
        }
        [segue.destinationViewController setDelegate:self];
    }
}


@end
