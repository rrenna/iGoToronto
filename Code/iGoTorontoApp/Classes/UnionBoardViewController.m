//
//  FirstViewController.m
//  iGoToronto
//
//  Created by Ryan Renna on 10-07-11.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "UnionBoardViewController.h"

@implementation UnionBoardViewController
@synthesize table;
@synthesize viewBoardButton;
@synthesize popupController;
@synthesize serverResponse;
@synthesize cellBackgroundColour;
@synthesize cellForegroundColour;

- (void)viewDidLoad 
{
	[super viewDidLoad];
    
    cellBackgroundColour = [UIColor grayColor];
    cellForegroundColour = [UIColor whiteColor];
    
    [self processResponse];
}

- (void)dealloc 
{
	if(precacheCompleteInvocation)
	{
		[precacheCompleteInvocation release];
	}
    [cellBackgroundColour release];
    [cellForegroundColour release];
	[popupController release];
	[table release];
	[viewBoardButton release];
	[serverResponse release];
	[trainInfoFirstLineArray release];
	[trainInfoSecondLineArray release];
	[trainInfoDetailHyperlinkArray release];
    [super dealloc];
}
/* Custom Methods */
-(void)precacheDataAndReplyWithInvocation:(NSInvocation*)invocation
{
	precacheCompleteInvocation = [invocation retain];
	ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"http://gotransit.com/publicroot/mobile/"]];
	[request setDelegate:self];
	[request startAsynchronous];
	[request release];
}
-(void)processResponse
{
	[trainInfoFirstLineArray release];
	[trainInfoSecondLineArray release];
	[trainInfoDetailHyperlinkArray release];
	
	
   	trainInfoFirstLineArray = [[NSMutableArray alloc] init];
	trainInfoSecondLineArray = [[NSMutableArray alloc] init];
	trainInfoDetailHyperlinkArray = [[NSMutableArray alloc] init];
	
	if(serverResponse)
	{
		HTMLParser *parser = [[HTMLParser alloc] initWithString:serverResponse error:nil];
		HTMLNode * bodyNode = [parser body];
		NSArray * tableRows = [bodyNode findChildTags:@"tr"];
		
		int rowCounter = 0;
		NSDateFormatter *twentyFourHourDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[twentyFourHourDateFormatter setDateFormat:@"HH:mm"];
		[twentyFourHourDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
		NSDateFormatter *twelveHourDateFormatter = [[Constants sharedConstants] twelveHourDateFormatter];

		for(HTMLNode *row in tableRows)
		{
			rowCounter++;
			if(rowCounter > 1)
			{
				NSMutableString* trainData = [[NSMutableString alloc]initWithString:@""];
				int counter = 0;
				NSArray * tableCells = [row findChildTags:@"td"];
				
				for(HTMLNode *cell in tableCells)
				{
					counter++;
					switch (counter) {
						case 1:
						{
							//Train time
							id contents = [cell contents];
							if(contents)
							{
								NSDate *myDate = [twentyFourHourDateFormatter dateFromString:contents];
								[trainData appendString: [twelveHourDateFormatter stringFromDate:myDate]];
							}
						}
							break;
						case 2:
						{
							//Train name
							HTMLNode *aTrainname = [cell firstChild];
							//Add href to array
							NSString *ahrefString = [[NSString alloc] initWithFormat:@"%@%@",@"http://gotransit.com",[aTrainname getAttributeNamed:@"href"]];
							[trainInfoDetailHyperlinkArray addObject:ahrefString];
							[ahrefString release];
							
							id contents = [cell contents];
							if(!contents)
							{
								contents = [aTrainname contents];
								[trainData appendString: @" - "];
								[trainData appendString: contents];
							}
						}
							break;
						case 3:
						{
							//Train status
							id contents = [cell contents];
							if(contents)
							{
								contents = [contents stringByReplacingOccurrencesOfString:@"-" withString:@""];
								[trainData appendString: @" "];
								[trainData appendString: contents];
							}
						}
							
							break;
						case 4:
						{
							//Train status
							NSString *contents = @"";
							contents = [cell contents];
							[trainInfoSecondLineArray addObject:contents];
						}
							break;
						default:
							break;
					}
					
				}
				[trainInfoFirstLineArray addObject:trainData];
				[trainData release];
			}
			
		}
		
		[parser release];
	}
    
    [table reloadData];
}
/* IBActions */
-(IBAction)refresh:(id)sender
{
    [self precacheDataAndReplyWithInvocation:nil];
    [self processResponse];
}
/* ASIHTTPRequest Delegate methods */
- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSString* response = [request responseString];
	response = [response stringByReplacingOccurrencesOfString:@"&nbsp" withString:@" "];
	response = [response stringByReplacingOccurrencesOfString:@";" withString:@""];
	response = [response stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
	response = [response stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
	response = [response stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
	response = [response stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
	response = [response stringByReplacingOccurrencesOfString:@"<font face=\"Verdana\" size=\"1\">" withString:@""];
	response = [response stringByReplacingOccurrencesOfString:@"<font face=\"Verdana\" size=\"2\">" withString:@""];
	response = [response stringByReplacingOccurrencesOfString:@"</font>" withString:@""];
	self.serverResponse = response;
	
	@try 
	{
		[precacheCompleteInvocation invoke];
	}
	@catch (NSException * e) 
	{
		ALog(@"precacheDataAndReplyWithInvocation: - Failed to respond to NSInvocation");
	}
	@finally 
	{
	}
	
	[precacheCompleteInvocation release];
	precacheCompleteInvocation = nil;
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
	[precacheCompleteInvocation release];
	precacheCompleteInvocation = nil;
}
/* UITableView Delegate & DataSource methods */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [trainInfoFirstLineArray count];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	NSString* trainName = [trainInfoFirstLineArray objectAtIndex:indexPath.row];
	NSString *CellIdentifier = [[NSString alloc] initWithFormat:@"%i~%i~%@",indexPath.section,indexPath.row,trainName];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        // Configure the cell...
        cell.detailTextLabel.text = [trainInfoSecondLineArray objectAtIndex:indexPath.row];
        //Custom Accessory 
        UIImage* forwardButtonUnclickedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ForwardButton" ofType:@"png"]];
        UIImage* forwardButtonClickedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ForwardButton_Clicked" ofType:@"png"]];
        
        UIImageView* customAccessoryView = [[UIImageView alloc] initWithImage:forwardButtonUnclickedImage highlightedImage:forwardButtonClickedImage];
        cell.accessoryView = customAccessoryView;
        [customAccessoryView release];
        
        cell.textLabel.text = trainName;
		cell.textLabel.adjustsFontSizeToFitWidth = YES;
		cell.textLabel.minimumFontSize = 10.0;
        [cell setBackgroundColor:cellBackgroundColour];
        [cell.textLabel setTextColor:cellForegroundColour];
        [cell.textLabel setFont:[Constants sharedConstants].cellTextFont];
    }
	
	[CellIdentifier release];
	
	return cell;
}
-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath :(NSIndexPath *)indexPath 
{
	[self tableView:tableView didSelectRowAtIndexPath: indexPath];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	[popupController release];
	UnionBoardDetailController* detailViewController = [[UnionBoardDetailController alloc] init];
	
	int index = indexPath.row;
	NSString* url =   [trainInfoDetailHyperlinkArray objectAtIndex:index];
	detailViewController.url = url;
    
    self.popupController = [[InfoPopupViewController alloc] initWithViewController:detailViewController andTitle:[trainInfoFirstLineArray objectAtIndex:indexPath.row]];
	[popupController slideIn];
	[detailViewController release];
}
@end
