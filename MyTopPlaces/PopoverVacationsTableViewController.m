//
//  PopoverVacationsTableViewController.m
//  VirtualVacation
//
//  Created by Tatiana Kornilova on 8/16/12.
//
//

#import "PopoverVacationsTableViewController.h"

@interface PopoverVacationsTableViewController ()

@end

@implementation PopoverVacationsTableViewController
@synthesize vacations=_vacations;
@synthesize delegate=_delegate;
@synthesize unvisit=_unvisit;

// added after lecture to be sure table gets reloaded if Model changes
// you should always do this (i.e. reload table when Model changes)
// the Model getting out of synch with the contents of the table is bad

- (void)setVacations:(NSArray *)vacations
{
    _vacations = vacations;
    [self.tableView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.vacations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Visit Vacations Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.textLabel.text = [self.vacations objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *vacation =[self.vacations objectAtIndex:indexPath.row];
    [self.delegate PopoverVacationsTableViewController:self choseVacation:vacation];
}

@end
