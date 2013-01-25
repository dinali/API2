//
//  ERSViewController.m
//  WSsample
//
//  Created by Dina Li on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
#define kBgQueue dispatch_get_global_queue(
    DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#define kLatestKivaLoansURL [NSURL URLWithString: 
@"http://api.kivaws.org/v1/loans/search.json?status=fundraising"] //2
*/

#import "ERSViewController.h"

@interface ERSViewController ()

@end

@implementation ERSViewController
@synthesize contentLabel;
@synthesize jSONlabel;

-(void)viewDidAppear{
    self.title = @"FCC JSON Web Service";
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"FCC JSON Web Service";

    dispatch_queue_t kBgQueue = dispatch_get_global_queue(
                                   DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); 
    
//NSURL *kLatestKivaLoansURL = [NSURL URLWithString: 
//                     @"http://api.kivaws.org/v1/loans/search.json?status=fundraising"]; //2
    
    NSURL *kLatestKivaLoansURL = [NSURL URLWithString:@"http://data.fcc.gov/api/accessibilityclearinghouse/apps?disabilityID=7&page=1&rowPerPage=20&format=json"];

    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: 
                        kLatestKivaLoansURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) 
                               withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData //1
                          options:kNilOptions 
                          error:&error];
    
    NSString *key = nil;
    NSString *value = nil;
    NSInteger j = 0;
    
    for (key in json) 
    {
        value = [json objectForKey:key];
    //    NSLog(@"json dictionary value = %@", value);
    //    NSLog(@"json dictionary key = %@", key);
        j++;
       // NSLog(@"j count = %d", j);
    }
    // this works for top level elements
    NSString *itemString =  [json objectForKey:@"status"];
    NSLog(@"itemString = %@", itemString);
    
    //this is one specific array of dictionaries
    NSArray* latestLoans = [json objectForKey:@"App"];
    NSInteger index = 0;
    
    for(id element in latestLoans) {
        NSLog(@"element at index %u is = %@", index, element);
        index++;
    }
    
    NSDictionary* loan = [latestLoans objectAtIndex:0];
    NSString *item = nil;
    NSInteger *g = 0;
    NSDictionary *subElementDict = [[NSDictionary alloc] init];
    // value maybe a NSString or a NSDictionary!
    for (item in loan) 
    {
        value = [loan objectForKey:item];
        
        if( [value isKindOfClass:[NSString class]])
        {
            NSLog(@"loan value = %@", value);
            NSLog(@"loan key = %@", item);
            g++;        
        }
       else {      // dictionary of more info
           subElementDict = [loan objectForKey:@"source"];
           NSString *leafString = [subElementDict objectForKey:@"licenseType"];
           
        NSLog(@"leaf value = %@", leafString );
        NSLog(@"loan key = %@", item);
        g++;    
       }
    }
    
    // display leaf details on the page
    /*
    contentLabel.text =  [loan objectForKey:@"description"];
    jSONlabel.text = [subElementDict objectForKey:@"licenseType"];
    
    self.contentLabel.numberOfLines = 8;
    self.contentLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    CGSize textSize = [self.contentLabel.text sizeWithFont:self.contentLabel.font 
                                              constrainedToSize:CGSizeMake(self.contentLabel.frame.size.width, MAXFLOAT)
                                                  lineBreakMode:self.contentLabel.lineBreakMode];
    self.contentLabel.frame = CGRectMake(5.0f, 5.0f, (textSize.width + 20), (textSize.height + 20));
    
    self.jSONlabel.numberOfLines = 8;
    self.jSONlabel.lineBreakMode = UILineBreakModeWordWrap;
    
    CGSize textSize2 = [self.contentLabel.text sizeWithFont:self.jSONlabel.font 
                                         constrainedToSize:CGSizeMake(self.contentLabel.frame.size.width, MAXFLOAT)
                                             lineBreakMode:self.jSONlabel.lineBreakMode];
    self.contentLabel.frame = CGRectMake(0.0f, 0.0f, textSize2.width, (textSize2.height + 20));
    
    //EXAMPLE: return a dictionary element from a dictionary element
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

@end
