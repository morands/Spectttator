//
//  RootViewController.m
//  SpectttatorTest-iOS
//
//  Created by David Keegan on 6/29/11.
//  Copyright 2011 David Keegan.
//

#import "RootViewController.h"
#import "Spectttator.h"

@implementation RootViewController

@synthesize list = _list;
@synthesize shots = _shots;
@synthesize imageRetrievedCache = _imageRetrievedCache;
@synthesize imageCache = _imageCache;

@synthesize listButton = _listButton;
@synthesize refreshButton = _refreshButton;

- (void)refreshWithList:(NSString *)aList{
    if(aList != nil){
        self.list = aList;
    }
    self.title = [self.list capitalizedString];
    
    [self.listButton setEnabled:NO]; 
    [self.refreshButton setEnabled:NO];   
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [SPRequest shotsForList:self.list 
            withPagination:[SPPagination perPage:SPMaxPerPage]
            runOnMainThread:YES 
                  withBlock:^(NSArray *theShots, SPPagination *thsPagination){
                      self.shots = theShots;
                      self.imageCache = nil;
                      self.imageRetrievedCache = nil;
                      self.imageRetrievedCache = [[NSMutableSet alloc] initWithCapacity:[theShots count]];
                      self.imageCache = [[NSMutableDictionary alloc] initWithCapacity:[theShots count]];
                      
                      [self.listButton setEnabled:YES]; 
                      [self.refreshButton setEnabled:YES];             
                      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                      
                      [self.tableView reloadData];
    }];
}

- (void)refresh{
    [self refreshWithList:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex == 0){
        [self refreshWithList:SPPopularList];
    }else if(buttonIndex == 1){
        [self refreshWithList:SPEveryoneList];
    }else if(buttonIndex == 2){
        [self refreshWithList:SPDebutsList];
    }
    
    
}

- (void)changeList{
	UIActionSheet *listSheet = [[UIActionSheet alloc] initWithTitle:@"Lists" 
                                                            delegate:self 
                                                   cancelButtonTitle:@"Dismiss"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:[SPPopularList capitalizedString], 
                                                                     [SPEveryoneList capitalizedString], 
                                                                     [SPDebutsList  capitalizedString], 
                                                                      nil];
    [listSheet setActionSheetStyle:UIBarStyleDefault];
	[listSheet showInView:self.view];
	[listSheet release];    
}

- (void)viewDidLoad{
    [self refreshWithList:SPPopularList];
    
    
    
    self.listButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks 
                                                                                   target:self 
                                                                                   action:@selector(changeList)];          
    self.navigationItem.leftBarButtonItem = self.listButton;
    
    // setting latest refresh date (nil)
    [self.refreshHeaderView setLastRefreshDate:nil];

    
    [super viewDidLoad];
}

- (void)reloadTableViewDataSource{

	[super performSelector:@selector(dataSourceDidFinishLoadingNewData) withObject:nil afterDelay:0.0];
    
}
- (void)dataSourceDidFinishLoadingNewData{
	// resetting latest refresh date
    [self refreshWithList:nil];
    [refreshHeaderView setCurrentDate];	
	[super dataSourceDidFinishLoadingNewData];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [self refresh];
    [super viewDidAppear:animated];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return[self.shots count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShotCell";
    
    ShotCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    SPShot *aShot = [self.shots objectAtIndex:indexPath.row];
    
    NSNumber *identifier = [NSNumber numberWithLong:aShot.identifier];
    [cell loadShot:aShot withImage:[self.imageCache objectForKey:identifier]];
    
    // A little image cache so we only retrieve the image once,
    // and we update the row the first time it's loaded.
    if(![self.imageRetrievedCache member:identifier]){
        [self.imageRetrievedCache addObject:identifier];
        [aShot imageTeaserRunOnMainThread:YES withBlock:^(UIImage *image){
            [self.imageCache setObject:image forKey:identifier];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] 
                             withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    
    // Configure the cell.
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Open the shot in safari
    SPShot *aShot = [self.shots objectAtIndex:indexPath.row];
    
    //To open shots into Safari instead of in-app uncomment the following line (161) and delete the block from row 166 to 168 (ViewController ... animated:YES])
    //[[UIApplication sharedApplication] openURL:aShot.url];
    NSURL *address = aShot.url;
    NSString *urlString = [address absoluteString];
    

    ViewController *controller = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    controller.indirizzo = urlString;  
    [self.navigationController pushViewController:controller animated:YES];
     
    
}

- (void)dealloc{
    [_shots release];
    [_imageRetrievedCache release];
    [_imageCache release];
    
    [_refreshButton release];
    [_listButton release];
    
    [super dealloc];
}

@end
