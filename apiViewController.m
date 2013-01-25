//
//  apiViewController.m
//  WSsample
//
//  Created by Dina Li on 1/22/13.
//
//

#import "apiViewController.h"

@interface apiViewController ()

@end

@implementation apiViewController

@synthesize JSONlabel = _JSONlabel;         // title
@synthesize contentLabel = _contentLabel;   // description
@synthesize releaseDateLabel = _releaseDateLabel;
@synthesize chartImage = _chartImage;  // display the chart

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear{
    self.title = @"Website API";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"ERS JSON Web Service";
    
    dispatch_queue_t kBgQueue = dispatch_get_global_queue(
                                                          DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //NSURL *url = [NSURL URLWithString:
    //                     @"http://api.kivaws.org/v1/loans/search.json?status=fundraising"]; //2
    
    NSURL *url = [NSURL URLWithString:@"http://api.ers.usda.gov/REST/v1/charts/all"];
    
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        url];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
}

// Description:
// there is a top level array of dictionaries with the create date and release date
// each item in the array represents one Chart of Note (or whatever)
// below that, there is a Properties Array: index[1] contains the title, index[0] contains the image URL, index[8] contains the description
// need the title, url, release date, and description

- (void)fetchedData:(NSData *)responseData {
    NSError* error;
    
    NSArray* jsonArray = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];

    
//    for (key in json) WORKS IF ITS A DICTIONARY
//    {
//        value = [json objectForKey: key];
//           NSLog(@"json dictionary value = %@", value); // value is NULL
//           NSLog(@"json dictionary key = %@", key);
//        j++;
//        
//    }
    NSInteger j = 0;
    NSUInteger *i = 0;
    NSUInteger *records = [jsonArray count];
    NSString *item, *value, *title, *url, *releaseDate, *description = nil;
    
    NSDictionary* jsonDictionary = [jsonArray objectAtIndex:0];
    
//    key = @"Title";
//    url = @"Url";
//    releaseDate = @"ReleaseDate";
    
    // array of dictionaries within the big json array
        for (i = 0; i < records; i++)
        {
           // NSLog (@"Element %i = %@", i, [jsonArray objectAtIndex: i]); // print out ALL the Chart info
                        
            if ([[jsonArray objectAtIndex:i] isKindOfClass:[NSDictionary class]])
            {
                //for (NSDictionary *jsonDictionary in jsonArray)
                for (item in jsonDictionary)
                {
                    title = [jsonDictionary objectForKey: @"Title"];
                    url = [jsonDictionary objectForKey: @"Url"];
                    releaseDate = [jsonDictionary objectForKey: @"ReleaseDate"];
                    
//                    NSLog(@"json dictionary title = %@", title);
//                    NSLog(@"json dictionary url = %@", url);
//                    NSLog(@"json dictionary releasedate = %@", releaseDate);
//                    NSLog(@"json dictionary item = %@", item);
                }
            }
    
    /*
    
     TODO: get the Description out of the Properties Array
     
    NSArray* propertiesArray = [json objectForKey:@"Properties"];
    NSInteger index = 0;
    
    for(id element in propertiesArray) {
        NSLog(@"element at index %u is = %@", index, element);
        index++;
    }
    
    // a chart's properties are stored in the array
    NSDictionary* chart = [propertiesArray objectAtIndex:0];
    NSString *item = nil;  // contain the value associated with the key
    NSInteger *g = 0;
  //  NSDictionary *subElementDict = [[NSDictionary alloc] init];
    NSString *file = @"file";
    NSString *title = @"title";
    
    for (item in chart)
    {
        value = [chart objectForKey:file];  // path to the image
        
        if( [value isKindOfClass:[NSString class]])
        {
            NSLog(@"chart value = %@", value);
            NSLog(@"chart key = %@", item);
            g++;
        }
        
        value = [chart objectForKey:title];  // title
        
        if( [value isKindOfClass:[NSString class]])
        {
            NSLog(@"chart value = %@", value);
            NSLog(@"chart key = %@", item);
            g++;
        }

        
        else {      // dictionary of more info
            subElementDict = [loan objectForKey:@"source"];
            NSString *leafString = [subElementDict objectForKey:@"licenseType"];
            
            NSLog(@"leaf value = %@", leafString );
            NSLog(@"loan key = %@", item);
            g++;
        }
         */
    }
    
    // display leaf details on the page
    // todo: fix this date formatter, returns NIL -  // NSString to NSDate and return back into a string
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    
//    [format setDateFormat:@"MMM d, yyyy"];
//    NSDate *date = [format dateFromString:releaseDate];
//    
//    NSString *formattedDate_string = [format stringFromDate:date];
    
        
   // _contentLabel.text =  formattedDate_string;
    _contentLabel.text = releaseDate;
    _JSONlabel.text = title;
    
    // url - need the image or full URL for this to work
    //UIImage *myImage = [[UIImage alloc] initWithContentsOfFile: url];
    UIImage *myImage = [[UIImage alloc] initWithContentsOfFile:@"/Users/dinali/Documents/XCode Projects/API2/ChinaCornProduction.png"];
    _chartImage.image = myImage;
    
    //self.photoImageView.image = [UIImage imageNamed:@"img.png"];

    
   // jSONlabel.text = [subElementDict objectForKey:@"licenseType"];
    /*
    _contentLabel.numberOfLines = 8;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize textSize = [self.contentLabel.text sizeWithFont:self.contentLabel.font
                                         constrainedToSize:CGSizeMake(self.contentLabel.frame.size.width, MAXFLOAT)
                                             lineBreakMode:self.contentLabel.lineBreakMode];
    _contentLabel.frame = CGRectMake(5.0f, 5.0f, (textSize.width + 20), (textSize.height + 20));
    
    _JSONlabel.numberOfLines = 8;
    _JSONlabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize textSize2 = [self.contentLabel.text sizeWithFont:self.JSONlabel.font
                                          constrainedToSize:CGSizeMake(self.contentLabel.frame.size.width, MAXFLOAT)
                                              lineBreakMode:self.JSONlabel.lineBreakMode];
    _contentLabel.frame = CGRectMake(0.0f, 0.0f, textSize2.width, (textSize2.height + 20));
    */

    /* EXAMPLE: return a dictionary element from a dictionary element
     contentLabel.text = [NSString stringWithFormat:@"Latest loan: %@
     from %@ needs another $%.2f to pursue their entrepreneural dream",
     [loan objectForKey:@"name"],
     [(NSDictionary*)[loan objectForKey:@"location"]
     objectForKey:@"country"],
     outstandingAmount];
     */
}

- (void)viewDidUnload
{
    [self setContentLabel:nil];
    [self setJSONlabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
//}

@end
