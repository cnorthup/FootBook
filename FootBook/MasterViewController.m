//
//  MasterViewController.m
//  FootBook
//
//  Created by Charles Northup on 4/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Profile.h"

@interface MasterViewController ()
{
    BOOL firstStartUp;
    BOOL lookAtFriends;
}
@property NSArray* profilesArray;
@end

@implementation MasterViewController


- (void)viewDidLoad{
    
    [super viewDidLoad];
    lookAtFriends = YES;
    self.navigationItem.title = @"Friends";
    self.fetchedResultsController.delegate = self;
    firstStartUp = ![[NSUserDefaults standardUserDefaults] boolForKey:@"hasRunOnce"];
    if (firstStartUp) {
        [self firstRun];
    }
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Profile"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"mobileMakers"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"friended == %@", [NSNumber numberWithBool:lookAtFriends]];
    [request setPredicate:predicate];
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
    //[self filter:lookAtFriends];
}

- (void) filter:(BOOL)parameterName {
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Profile"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"mobileMakers"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"friended == %@", [NSNumber numberWithBool:lookAtFriends]];
    [request setPredicate:predicate];
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}
- (IBAction)addFriends:(id)sender {
    lookAtFriends =! lookAtFriends;
    if (!lookAtFriends) {
        self.title = @"Profiles";
    }
    else{
        self.title = @"Friends";
    }
    [self filter:lookAtFriends];
}

- (void) firstRun{
    
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:YES forKey:@"hasRunOnce"];
    [userDefault synchronize];
    
    NSURL* url = [NSURL URLWithString:@"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/4/friends.json"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.profilesArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        //NSLog(@"%@", self.profilesArray);
        for (NSString*profileName in self.profilesArray) {
            Profile* profile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:self.managedObjectContext];
            profile.name = profileName;
            profile.friended = @(0);
            profile.numberOfFeet = @(arc4random()%100);
            profile.numberOfToes = @(arc4random()%200);
            [self.managedObjectContext save:nil];
        }
    }];
}


#pragma mark - Table View

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    
//    //return [[self.fetchedResultsController sections] count];
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self.fetchedResultsController.sections objectAtIndex:section] numberOfObjects];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Profile* profile = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = profile.name;
    cell.detailTextLabel.text = profile.friended.description;
    
    return cell;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    
    [self.tableView beginUpdates];
}
//tells us about changes in number of sections
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    
}
//tells us about changes in number of items
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath{
    
    if (type == NSFetchedResultsChangeInsert) {
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if(type == NSFetchedResultsChangeUpdate){
        [self.tableView reloadRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    [self.tableView endUpdates];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    DetailViewController* vc = segue.destinationViewController;
    NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
    Profile* selectedProfile = [self.fetchedResultsController objectAtIndexPath:indexPath];
    vc.detailItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    vc.title = [[self.fetchedResultsController objectAtIndexPath:indexPath] name];
    vc.friended = [selectedProfile.friended boolValue];
}

-(IBAction)commitChanges:(UIStoryboardSegue*)sender{
    
    DetailViewController* vc = sender.sourceViewController;
    Profile*profile = vc.detailItem;
    profile.friended = [NSNumber numberWithBool:vc.friendSwitch.on];
    [self.managedObjectContext save:nil];
    lookAtFriends = YES;
    self.title = @"Friends";
    [self filter:lookAtFriends];
}










@end
