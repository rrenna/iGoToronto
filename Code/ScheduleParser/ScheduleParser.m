//
//  ScheduleParser.m
//  ScheduleParser
//
//  Created by Ryan Renna on 10-07-14.
//  Copyright __MyCompanyName__ 2010 . All rights reserved.
//

#import <objc/objc-auto.h>
#import "NetworkRequest.h"
#import "HTMLParser.h"
#import "TBXML.h"
//Model
#import "HelperModelClasses.h"
#import "CDLine.h"
#import "CDRoute.h"
#import "CDStation.h"
#import "CDSubwayStation.h"
#import "CDStop.h"
#import "CDFactoid.h"
#import "CDDirection.h"
#import "CDRoadway.h"
#import "CDCamera.h"
#import "CDDayType.h"

NSManagedObjectModel *managedObjectModel();
NSManagedObjectContext *managedObjectContext();

//Change to switch between current and upcoming schedules
static BOOL isNew = YES;
static NSString* fridayString = @"Friday";
static NSString* mondayToFridayString = @"Mon to Fri";
static NSString* mondayToThursdayString = @"Mon to Thur";
static NSString* saturdayString = @"Saturday";
static NSString* sundayString = @"Sunday";
static NSString* holidayString = @"Holiday";

static void initializeLakeshoreWestData(NSMutableDictionary* mLineDictionary)
{
	//Lines
	ModelLine* lakeshoreWest = [ModelLine new];
	lakeshoreWest.r = 238;
	lakeshoreWest.g = 123;
	lakeshoreWest.b = 48;
    lakeshoreWest.name = @"Lakeshore West";
	[lakeshoreWest.directions addObject:@"West"];
	[lakeshoreWest.directions addObject:@"East"];
	//Store Lines in Line Dictionary
	[mLineDictionary setObject:lakeshoreWest forKey:lakeshoreWest.name];
	//Set day types
	[lakeshoreWest.dayTypes addObject:mondayToFridayString];
	[lakeshoreWest.dayTypes addObject:saturdayString];
	[lakeshoreWest.dayTypes addObject:sundayString];
	//[lakeshoreWest.dayTypes addObject:holidayString];
    
	//Lakeshore West - Westward
    ModelRouteTypePage* lakeshoreWestWestwardMondayToFriday = [ModelRouteTypePage new];
    lakeshoreWestWestwardMondayToFriday.direction = @"West";
    lakeshoreWestWestwardMondayToFriday.pages = 5;
    lakeshoreWestWestwardMondayToFriday.dayType = mondayToFridayString;
    lakeshoreWestWestwardMondayToFriday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=01&direction=1&day=1&page=%i";
	ModelRouteTypePage* lakeshoreWestWestwardSaturday = [ModelRouteTypePage new];
    lakeshoreWestWestwardSaturday.direction = @"West";
    lakeshoreWestWestwardSaturday.pages = 2;
    lakeshoreWestWestwardSaturday.dayType = saturdayString;
    lakeshoreWestWestwardSaturday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=01&direction=1&day=6&page=%i";
    ModelRouteTypePage* lakeshoreWestWestwardSunday = [ModelRouteTypePage new];
    lakeshoreWestWestwardSunday.direction = @"West";
    lakeshoreWestWestwardSunday.pages = 3;
    lakeshoreWestWestwardSunday.dayType = sundayString;
    lakeshoreWestWestwardSunday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=01&direction=1&day=7&page=%i";
	/*
    ModelRouteTypePage* lakeshoreWestWestwardHoliday = [ModelRouteTypePage new];
    lakeshoreWestWestwardHoliday.direction = @"West";
    lakeshoreWestWestwardHoliday.pages = 3;
    lakeshoreWestWestwardHoliday.dayType = holidayString;
    lakeshoreWestWestwardHoliday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=01&direction=1&day=9&page=%i";
    */
    
    //Express Bus Routes
    ModelRouteTypePage* hamiltonQEWBusWestwardMondayToFriday = [ModelRouteTypePage new];
    hamiltonQEWBusWestwardMondayToFriday.direction = @"West";
    hamiltonQEWBusWestwardMondayToFriday.dayType = mondayToFridayString;
    hamiltonQEWBusWestwardMondayToFriday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=16&direction=1&day=1&page=%i";
    ModelRouteTypePage* hamiltonQEWBusWestwardSaturday = [ModelRouteTypePage new];
    hamiltonQEWBusWestwardSaturday.direction = @"West";
    hamiltonQEWBusWestwardSaturday.dayType = saturdayString;
    hamiltonQEWBusWestwardSaturday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=16&direction=1&day=6&page=%i";
    ModelRouteTypePage* hamiltonQEWBusWestwardSunday = [ModelRouteTypePage new];
    hamiltonQEWBusWestwardSunday.direction = @"West";
    hamiltonQEWBusWestwardSunday.dayType = sundayString;
    hamiltonQEWBusWestwardSunday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=16&direction=1&day=7&page=%i";
    
    /*
    ModelRouteTypePage* hamiltonQEWBusWestwardHoliday = [ModelRouteTypePage new];
    hamiltonQEWBusWestwardHoliday.direction = @"West";
    hamiltonQEWBusWestwardHoliday.dayType = holidayString;
    hamiltonQEWBusWestwardHoliday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=16&direction=1&day=9&page=%i";
    */
     
	[lakeshoreWest.routeTypePages addObject:lakeshoreWestWestwardMondayToFriday];
	[lakeshoreWest.routeTypePages addObject:lakeshoreWestWestwardSaturday];
	[lakeshoreWest.routeTypePages addObject:lakeshoreWestWestwardSunday];
	//[lakeshoreWest.routeTypePages addObject:lakeshoreWestWestwardHoliday];
    
    [lakeshoreWest.routeTypePages addObject:hamiltonQEWBusWestwardMondayToFriday];
	[lakeshoreWest.routeTypePages addObject:hamiltonQEWBusWestwardSaturday];
	[lakeshoreWest.routeTypePages addObject:hamiltonQEWBusWestwardSunday];
	//[lakeshoreWest.routeTypePages addObject:hamiltonQEWBusWestwardHoliday];
	
    //Lakeshore West - Eastward
    ModelRouteTypePage* lakeshoreWestEastwardMondayToFriday = [ModelRouteTypePage new];
    lakeshoreWestEastwardMondayToFriday.direction = @"East";
    lakeshoreWestEastwardMondayToFriday.dayType = mondayToFridayString;
    lakeshoreWestEastwardMondayToFriday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=01&direction=0&day=1&page=%i";
	ModelRouteTypePage* lakeshoreWestEastwardSaturday = [ModelRouteTypePage new];
    lakeshoreWestEastwardSaturday.direction = @"East";
    lakeshoreWestEastwardSaturday.dayType = saturdayString;
    lakeshoreWestEastwardSaturday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=01&direction=0&day=6&page=%i";
    ModelRouteTypePage* lakeshoreWestEastwardSunday = [ModelRouteTypePage new];
    lakeshoreWestEastwardSunday.direction = @"East";
    lakeshoreWestEastwardSunday.dayType = sundayString;
    lakeshoreWestEastwardSunday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=01&direction=0&day=7&page=%i";
	/*
    ModelRouteTypePage* lakeshoreWestEastwardHoliday = [ModelRouteTypePage new];
    lakeshoreWestEastwardHoliday.direction = @"East";
    lakeshoreWestEastwardHoliday.dayType = holidayString;
    lakeshoreWestEastwardHoliday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=01&direction=0&day=9&page=%i";
	*/
    
    //Express Bus Routes
	ModelRouteTypePage* hamiltonQEWBusEasternMondayToFriday = [ModelRouteTypePage new];
    hamiltonQEWBusEasternMondayToFriday.direction = @"East";
    hamiltonQEWBusEasternMondayToFriday.dayType = mondayToFridayString;
    hamiltonQEWBusEasternMondayToFriday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=16&direction=0&day=1&page=%i";
	ModelRouteTypePage* hamiltonQEWBusEasternSaturday = [ModelRouteTypePage new];
    hamiltonQEWBusEasternSaturday.direction = @"East";
    hamiltonQEWBusEasternSaturday.dayType = saturdayString;
    hamiltonQEWBusEasternSaturday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=16&direction=0&day=6&page=%i";
	ModelRouteTypePage* hamiltonQEWBusEasternSunday = [ModelRouteTypePage new];
    hamiltonQEWBusEasternSunday.direction = @"East";
    hamiltonQEWBusEasternSunday.dayType = sundayString;
    hamiltonQEWBusEasternSunday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=16&direction=0&day=7&page=%i";
	
    /*
     ModelRouteTypePage* hamiltonQEWBusEasternHoliday = [ModelRouteTypePage new];
    hamiltonQEWBusEasternHoliday.direction = @"East";
    hamiltonQEWBusEasternHoliday.dayType = holidayString;
    hamiltonQEWBusEasternHoliday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=16&direction=0&day=9&page=%i";
    */
		
    [lakeshoreWest.routeTypePages addObject:lakeshoreWestEastwardMondayToFriday];
    [lakeshoreWest.routeTypePages addObject:lakeshoreWestEastwardSaturday];
	[lakeshoreWest.routeTypePages addObject:lakeshoreWestEastwardSunday];
	//[lakeshoreWest.routeTypePages addObject:lakeshoreWestEastwardHoliday];
	
    [lakeshoreWest.routeTypePages addObject:hamiltonQEWBusEasternMondayToFriday];
	[lakeshoreWest.routeTypePages addObject:hamiltonQEWBusEasternSaturday];
	[lakeshoreWest.routeTypePages addObject:hamiltonQEWBusEasternSunday];
	//[lakeshoreWest.routeTypePages addObject:hamiltonQEWBusEasternHoliday];
	
	//Stations
	ModelStation* station;
    //Lakeshore West
    station = [ModelStation new];
    station.name = @"Exhibition GO Station";
    station.isDescriptor = NO;
	[station.factoids addObject:@"The station is located at Exhibition Place, to the West of the downtown Toronto core. This station is mostly used during the Canadian National Exhibition."];
    [station.factoids addObject:@"Exhibition GO Station's GO Transit code is \"EXGO\"."];
	station.latitude = 43.6359;
	station.longitude = -79.4192;
	station.address = @"Manitoba Dr., Toronto, ON";
	[lakeshoreWest.stations addObject:station];
    [station release];
    
    station = [ModelStation new];
    station.name = @"Mimico GO Station";
    station.isDescriptor = NO;
    [lakeshoreWest.stations addObject:station];
	[station.factoids addObject:@"Mimico GO Station's GO Transit code is \"MMGO\"."];
    station.address = @"315 Royal York Rd., Toronto, ON";
	station.latitude = 43.6164;
	station.longitude = -79.4972;
	[station release];
    
    station = [ModelStation new];
    station.name = @"Long Branch GO Station";
    station.isDescriptor = NO;
	[station.factoids addObject:@"Long Branch GO Station's GO Transit code is \"LBGO\"."];
    station.address = @"20 Brow Dr., Toronto, ON";
	station.latitude = 43.5919;
	station.longitude = -79.5456;
	[lakeshoreWest.stations addObject:station];
    [station release];
    
    station = [ModelStation new];
    station.name = @"Port Credit GO Station";
    station.isDescriptor = NO;
	[station.factoids addObject:@"Port Credit GO Station has over 900 parking spaces."];
	[station.factoids addObject:@"Port Credit GO Station is located in the former Town of Port Credit, which was amalgamated into Mississauga in 1974."];
	[station.factoids addObject:@"Port Credit GO Station's GO Transit code is \"PCGO\"."];
    station.address = @"30 Queen St. E., Mississauga, ON";
	station.latitude = 43.5556;
	station.longitude = -79.5875;
	[lakeshoreWest.stations addObject:station];
    [station release];
    
    station = [ModelStation new];
    station.name = @"Clarkson GO Station";
    station.isDescriptor = NO;
	[station.factoids addObject:@"Clarkson GO Station has over 2,500 parking spaces."];
	[station.factoids addObject:@"Clarkson GO Station's GO Transit code is \"CLGO\"."];
    station.address = @"1110 Southdown Rd., Mississauga, ON";
	station.latitude = 43.5129;
	station.longitude = -79.634;
	[lakeshoreWest.stations addObject:station];
    [station release];
    
    station = [ModelStation new];
    station.name = @"Oakville GO Station";
    station.isDescriptor = NO;
	[station.factoids addObject:@"Oakville GO Station served, until October 2007, as the western terminus for weekend service."];
	[station.factoids addObject:@"Oakville GO Station has over 2,700 parking spaces."];
	[station.factoids addObject:@"Oakville GO Station was first opened on May 23rd, 1967."];
	[station.factoids addObject:@"Oakville GO Station's GO Transit code is \"OKGO\"."];
    station.address = @"214 Cross Ave., Oakville, ON L6J 2W6";
	station.latitude = 43.4546;
	station.longitude = -79.6828;
	[lakeshoreWest.stations addObject:station];
    [station release];
    
    station = [ModelStation new];
    station.name = @"Bronte GO Station";
    station.isDescriptor = NO;
    [lakeshoreWest.stations addObject:station];
	[station.factoids addObject:@"Bronte GO Station's GO Transit code is \"BTGO\"."];
    station.address = @"2104 Wyecroft Rd., Oakville, ON L6L 5V6";
	station.latitude = 43.4171;
	station.longitude = -79.7219;
	[station release];
    
    station = [ModelStation new];
    station.name = @"Appleby GO Station";
    station.isDescriptor = NO;
	station.address = @"5111 Fairview Street, Burlington, ON L7L 4W8";
	station.latitude = 43.3791;
	station.longitude = -79.7612;
	[station.factoids addObject:@"Appleby GO Station's GO Transit code is \"APGO\"."];
    [lakeshoreWest.stations addObject:station];
    [station release];
    
    station = [ModelStation new];
    station.name = @"Burlington GO Station";
    station.isDescriptor = NO;
	[station.factoids addObject:@"There are extensive parking facilities on both the north and south of the station. A large multi-level parking structure opened in 2008, significantly expanding the parking capacity of the station."];
    [station.factoids addObject:@"Burlington GO Station first opened January 9th, 1992."];
	[station.factoids addObject:@"Burlington GO Station's GO Transit code is \"BUGO\"."];
	station.address = @"2101 Fairview St., Burlington, ON";
	station.latitude = 43.3413;
	station.longitude = -79.8091;
	[lakeshoreWest.stations addObject:station];
    [station release];
    
    station = [ModelStation new];
    station.name = @"Aldershot GO Station";
    station.isDescriptor = NO;
	[station.factoids addObject:@"Aldershot GO Station is the western terminus on the Lakeshore West line train service in off-peak hours."];
    [station.factoids addObject:@"Aldershot GO Station is a train and bus station in used by VIA Rail and GO Transit, located at Highway 403 and Waterdown Road in the Aldershot community of Burlington."];
	[station.factoids addObject:@"Aldershot GO Station's GO Transit code is \"ALGO\"."];
	station.address = @"1199 Waterdown Road, Burlington, ON L7T 4A8";
	station.latitude = 43.3129;
	station.longitude = -79.8552;
	[lakeshoreWest.stations addObject:station];
    [station release];
    
	station = [ModelStation new];
    station.name = @"Hamilton-King and Dundurn";
    station.isDescriptor = YES;
	station.address = @"King St. W. & Dundurn St.";
	station.latitude = 43.2622;
	station.longitude = -79.8879;
    [lakeshoreWest.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Hamilton-Main and Longwood";
    station.isDescriptor = YES;
	station.address = @"Main St. W. & Longwood Rd.";
	station.latitude = 43.2591;
	station.longitude = -79.9025;
    [lakeshoreWest.stations addObject:station];
    [station release];
    
    station = [ModelStation new];
    station.name = @"Hamilton GO Centre";
    station.isDescriptor = NO;
	[station.factoids addObject:@"The \"Centre\" in the facility's name refers to how, unlike other GO stations, it doubles as a regional bus terminal for private intercity coach carriers including Greyhound and Coach Canada."];
    [station.factoids addObject:@"Hamilton GO Centre is the only example of Art Deco railway station architecture in Canada."];
    [station.factoids addObject:@"Hamilton GO Centre opened in 1933 as the head office and the Hamilton station of the Toronto, Hamilton and Buffalo Railway."];
	[station.factoids addObject:@"Hamilton GO Centre was rebuilt 63 years after it was first opened, in 1996."];
	[station.factoids addObject:@"Hamilton GO Centre's GO Transit code is \"HMGO\"."];
	station.address = @"36 Hunter St. E., Hamilton, ON L8N 3W8";
	station.latitude = 43.253;
	station.longitude = -79.8691;
	[lakeshoreWest.stations addObject:station];
    [station release];
    
    station = [ModelStation new];
    station.name = @"McMaster U Bus Term.";
    station.isDescriptor = YES;
	station.address = @"On McMaster University campus";
	station.latitude = 43.2618;
	station.longitude = 79.9229;
    [lakeshoreWest.stations addObject:station];
    [station release];
}
static void initializeMiltonData(NSMutableDictionary* mLineDictionary)
{
	ModelLine* milton = [ModelLine new];
	[milton.directions addObject:@"East"];
	[milton.directions addObject:@"West"];
	milton.name = @"Milton";
	milton.r = 240;
	milton.g = 240;
	milton.b = 97;
	
	[mLineDictionary setObject:milton forKey:milton.name];
	//Set daytypes
	[milton.dayTypes addObject:mondayToFridayString];
	[milton.dayTypes addObject:saturdayString];
	[milton.dayTypes addObject:sundayString];
	//[milton.dayTypes addObject:holidayString];
    
	//Milton - SouthEast
	ModelRouteTypePage* miltonEastMondayToFriday = [ModelRouteTypePage new];
    miltonEastMondayToFriday.direction = @"East";
    miltonEastMondayToFriday.pages = 7;
    miltonEastMondayToFriday.dayType = mondayToFridayString;
	miltonEastMondayToFriday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=21&direction=0&day=1&page=%i";
	
	ModelRouteTypePage* miltonEastSaturday = [ModelRouteTypePage new];
    miltonEastSaturday.direction = @"East";
    miltonEastSaturday.pages = 5;
    miltonEastSaturday.dayType = saturdayString;
    miltonEastSaturday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=21&direction=0&day=6&page=%i";
	
	ModelRouteTypePage* miltonEastSunday = [ModelRouteTypePage new];
    miltonEastSunday.direction = @"East";
    miltonEastSunday.pages = 3;
    miltonEastSunday.dayType = sundayString;
    miltonEastSunday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=21&direction=0&day=7&page=%i";
	
    /*
	ModelRouteTypePage* miltonEastHoliday = [ModelRouteTypePage new];
    miltonEastHoliday.direction = @"East";
    miltonEastHoliday.pages = 3;
    miltonEastHoliday.dayType = holidayString;
    miltonEastHoliday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=21&direction=0&day=9&page=%i";
     */
	
	[milton.routeTypePages addObject:miltonEastMondayToFriday];
	[milton.routeTypePages addObject:miltonEastSaturday];
	[milton.routeTypePages addObject:miltonEastSunday];
	//[milton.routeTypePages addObject:miltonEastHoliday];
	
	//Milton - SouthEast
	ModelRouteTypePage* miltonWestMondayToFriday = [ModelRouteTypePage new];
    miltonWestMondayToFriday.direction = @"West";
    miltonWestMondayToFriday.pages = 8;
    miltonWestMondayToFriday.dayType = mondayToFridayString;
    miltonWestMondayToFriday.tableHeaderRowsToOffset = 1;
    miltonWestMondayToFriday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=21&direction=1&day=1&page=%i";
	
	ModelRouteTypePage* miltonWestSaturday = [ModelRouteTypePage new];
    miltonWestSaturday.direction = @"West";
    miltonWestSaturday.pages = 5;
    miltonWestSaturday.dayType = saturdayString;
    miltonWestSaturday.tableHeaderRowsToOffset = 1;
    miltonWestSaturday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=21&direction=1&day=6&page=%i";
	
	ModelRouteTypePage* miltonWestSunday = [ModelRouteTypePage new];
    miltonWestSunday.direction = @"West";
    miltonWestSunday.pages = 3;
    miltonWestSunday.dayType = sundayString;
    miltonWestSunday.tableHeaderRowsToOffset = 1;
    miltonWestSunday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=21&direction=1&day=7&page=%i";
	
    /*
	ModelRouteTypePage* miltonWestHoliday = [ModelRouteTypePage new];
    miltonWestHoliday.direction = @"West";
    miltonWestHoliday.pages = 3;
    miltonWestHoliday.dayType = holidayString;
    miltonWestHoliday.tableHeaderRowsToOffset = 1;
    miltonWestHoliday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=21&direction=1&day=9&page=%i";
     */
	
	[milton.routeTypePages addObject:miltonWestMondayToFriday];
	[milton.routeTypePages addObject:miltonWestSaturday];
	[milton.routeTypePages addObject:miltonWestSunday];
	//[milton.routeTypePages addObject:miltonWestHoliday];
	
	//Stations
	ModelStation* station;
	//Milton
	station = [ModelStation new];
    station.name = @"Milton-Main and Martin";
    station.isDescriptor = YES;
	station.address = @"Main St. & Martin St.";
	station.latitude = 43.5134;
	station.longitude = -79.8829;
    [milton.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Milton GO Station";
    station.isDescriptor = NO;
	[station.factoids addObject:@"Milton GO Station's GO Transit code is \"MNGO\"."];
	[station.factoids addObject:@"Milton GO Station is the western terminus of GO Transit's Milton line."];
	[station.factoids addObject:@"Milton GO Station's bus loop may be used by future connecting buses to Cambridge, Kitchener, and Waterloo."];
    [station.factoids addObject:@"This facility replaced one located 8 miles west at Guelph Junction in Campbellville which could not be expanded beyond its five 10 car tracks."];
	[station.factoids addObject:@"Milton GO Station was opened in October 27th, 1981."];
	[station.factoids addObject:@"Milton GO Station has over 1050 parking spaces."];
	station.address = @"780 Main St. E., Milton ON";
	station.latitude = 43.5234;
	station.longitude = -79.867;
	[milton.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Lisgar GO Station";
    station.isDescriptor = NO;
	[station.factoids addObject:@"Lisgar GO Station was opened for service on September 4, 2007."];
    [station.factoids addObject:@"Lisgar GO Station was named after John Young, 1st Baron Lisgar, second Governor General of Canada from 1869-1872."];
	[station.factoids addObject:@"A turbine was constructed at the station to supply energy for the facility. Taking advantage of the heavy prevailing winds from the west, it is the first on-site wind generator for a North American transit system."];
	[station.factoids addObject:@"Lisgar GO Station's GO Transit code is \"LGGO\"."];
	station.address = @"3250 Argentia Road, Mississauga, Ontario, L5N 8E1";
	station.latitude = 43.5906;
	station.longitude = -79.7883;
	[milton.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Mdwvale-Derry and Winston";
    station.isDescriptor = YES;
	station.address = @"Derry Rd. & Winston Churchill Blvd.";
	station.latitude = 43.5882;
	station.longitude = -79.771;
	[milton.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Meadowvale Town Centre";
    station.isDescriptor = YES;
	station.address = @"Aquitaine Ave. & Glen Erin Dr.";
	station.latitude = 43.5825;
	station.longitude = -79.759;
    [milton.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Meadowvale GO Station";
	[station.factoids addObject:@"Meadowvale GO Station's GO Transit code is \"MDGO\"."];
	[station.factoids addObject:@"Meadowvale GO Station was opened for service on October 27th, 1981."];
    [station.factoids addObject:@"Meadowvale GO Station has over 1,600 parking spaces."];
	station.isDescriptor = NO;
    station.address = @"6845 Millcreek Dr., Mississauga, ON";
	station.latitude = 43.5978;
	station.longitude = -79.7542;
	[milton.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Streetsville GO Station";
	[station.factoids addObject:@"Streetsville GO Station's GO Transit code is \"STGO\"."];
	[station.factoids addObject:@"Streetsville GO Station's was opened for service on October 27th, 1981."];
	[station.factoids addObject:@"Streetsville GO Station has over 1300 parking spaces."];
	station.isDescriptor = NO;
	station.address = @"45 Thomas Street, Mississauga, ON";
	station.latitude = 43.5761;
	station.longitude = -79.7087;
    [milton.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Erindale GO Station";
	[station.factoids addObject:@"In order to increase capacity, GO has extended the platforms to accommodate trains with twelve carriages rather than the current ten."];
	[station.factoids addObject:@"Erindale GO Station has over 750 parking spaces."];
	[station.factoids addObject:@"Erindale GO Station's was opened for service on October 27th, 1981."];
	[station.factoids addObject:@"Erindale GO Station's GO Transit code is \"ERGO\"."];
    station.isDescriptor = NO;
    station.address = @"1320 Rathburn Rd. W., Mississauga, ON";
	station.latitude = 43.569;
	station.longitude = -79.6689;
	[milton.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Square One GO Terminal";
    station.isDescriptor = YES;
	station.address = @"Station Gate Road, Mississauga, ON";
	station.latitude = 43.5947;
	station.longitude = -79.6476;
    [milton.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Cooksville GO Station";
	[station.factoids addObject:@"Cooksville GO Station is served by Train-Bus during off-peak hours, and there is also a bus service to University of Guelph via Square One Bus Terminal and Aberfoyle Park & Ride."];
	[station.factoids addObject:@"On October 13, 2008 the CP Spirit Train had a stop at Cooksville GO station to promote the Vancouver 2010 Olympic Winter Games."];
	[station.factoids addObject:@"Cooksville GO Station has over 1450 parking spaces."];
	[station.factoids addObject:@"Cooksville GO Station's was opened for service on October 27th, 1981."];
	[station.factoids addObject:@"Cooksville GO Station's GO Transit code is \"CKGO\"."];
	station.isDescriptor = NO;
    station.address = @"3210 Hurontario St., Mississauga, ON";
	station.latitude = 43.5832;
	station.longitude = -79.6239;
	[milton.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Dixie GO Station";
	[station.factoids addObject:@"Dixie GO Station has over 650 parking spaces."];
	[station.factoids addObject:@"Dixie GO Station's was opened for service on October 27th, 1981."];
	[station.factoids addObject:@"Dixie GO Station's GO Transit code is \"DXGO\"."];
	[station.factoids addObject:@"Dixie GO Station allows for wheelchair-accessible train services through a raised mini-platform giving access to the 5th carriage from the locomotive; it is one of the only three stations on the Milton Line that offer the mini-platform."];
    station.isDescriptor = NO;
    station.address = @"2445 Dixie Rd., Mississauga, ON";
	station.latitude = 43.6078;
	station.longitude = -79.5774;
	[milton.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Kipling GO Station";
	[station.factoids addObject:@"Because the Kipling GO Station's only exit leads through TTC property, GO trains must skip Kipling when the TTC is on strike."];
	[station.factoids addObject:@"Kipling GO Station's was opened for service on October 27th, 1981."];
	[station.factoids addObject:@"Kipling GO Station's GO Transit code is \"KPGO\"."];
	station.isDescriptor = NO;
	station.address = @"27 St. Albans Rd., Toronto, ON";
	station.latitude = 43.6357;
	station.longitude = -79.5373;
    [milton.stations addObject:station];
    [station release];
}
static void initializeKitchenerData(NSMutableDictionary* mLineDictionary)
{
	ModelLine* georgetown = [ModelLine new];
	georgetown.name = @"Kitchener";
	[georgetown.directions addObject:@"East"];
	[georgetown.directions addObject:@"West"];
	georgetown.r = 48;
	georgetown.g = 129;
	georgetown.b = 45;
	
	[mLineDictionary setObject:georgetown forKey:georgetown.name];
	//Set daytypes
    /* Georgetown used to have a monday to thursday schedule
	[georgetown.dayTypes addObject:mondayToThursdayString];
	[georgetown.dayTypes addObject:fridayString];
     */
    [georgetown.dayTypes addObject:mondayToFridayString];
	[georgetown.dayTypes addObject:saturdayString];
	[georgetown.dayTypes addObject:sundayString];
	//[georgetown.dayTypes addObject:holidayString];
	
    //Georgetown - East
    /* Georgetown used to have a monday to thursday schedule
	ModelRouteTypePage* georgetownEastMondayToThursday = [ModelRouteTypePage new];
    georgetownEastMondayToThursday.direction = @"East";
    georgetownEastMondayToThursday.pages = 4;
    georgetownEastMondayToThursday.dayType = mondayToThursdayString;
    georgetownEastMondayToThursday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=31&direction=0&day=C&page=%i";
	
	ModelRouteTypePage* georgetownEastFriday = [ModelRouteTypePage new];
    georgetownEastFriday.direction = @"East";
    georgetownEastFriday.pages = 5;
    georgetownEastFriday.dayType = fridayString;
    georgetownEastFriday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=31&direction=0&day=F&page=%i";
	*/
	
    ModelRouteTypePage* georgetownEastMondayFriday = [ModelRouteTypePage new];
    georgetownEastMondayFriday.direction = @"East";
    georgetownEastMondayFriday.dayType = mondayToFridayString;
    georgetownEastMondayFriday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=31&direction=0&day=1&page=%i";
    
	ModelRouteTypePage* georgetownEastSaturday = [ModelRouteTypePage new];
    georgetownEastSaturday.direction = @"East";
    georgetownEastSaturday.dayType = saturdayString;
    /*Previously a saturday on the Georgetown line was coded as day 'G'
    georgetownEastSaturday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=31&direction=0&day=6&page=%i";
     */
    georgetownEastSaturday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=31&direction=0&day=6&page=%i";
	
	ModelRouteTypePage* georgetownEastSunday = [ModelRouteTypePage new];
    georgetownEastSunday.direction = @"East";
    georgetownEastSunday.pages = 4;
    georgetownEastSunday.dayType = sundayString;
    /* Georgetown Sunday day type used to be 'H'
    georgetownEastSunday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=31&direction=0&day=H&page=%i";
     */
    georgetownEastSunday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=31&direction=0&day=7&page=%i";
	
    /*
	ModelRouteTypePage* georgetownEastHoliday = [ModelRouteTypePage new];
    georgetownEastHoliday.direction = @"East";
    georgetownEastHoliday.pages = 4;
    georgetownEastHoliday.dayType = holidayString;
    // Georgetown Holiday day type used to be 'H'
    //georgetownEastHoliday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=31&direction=0&day=I&page=%i";
     
    georgetownEastHoliday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=31&direction=0&day=9&page=%i";
    */
    
    /* Georgetown used to have a monday to thursday schedule
	[georgetown.routeTypePages addObject:georgetownEastMondayToThursday];
	[georgetown.routeTypePages addObject:georgetownEastFriday];
     */
    
    [georgetown.routeTypePages addObject:georgetownEastMondayFriday];
	[georgetown.routeTypePages addObject:georgetownEastSaturday];
	[georgetown.routeTypePages addObject:georgetownEastSunday];
	//[georgetown.routeTypePages addObject:georgetownEastHoliday];
	
	//Georgetown - West
    
    /* Georgetown used to have a monday to thursday schedule
	ModelRouteTypePage* georgetownWestMondayToThursday = [ModelRouteTypePage new];
    georgetownWestMondayToThursday.direction = @"West";
    georgetownWestMondayToThursday.pages = 6;
    georgetownWestMondayToThursday.dayType = mondayToThursdayString;
    georgetownWestMondayToThursday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=31&direction=1&day=C&page=%i";
	
	ModelRouteTypePage* georgetownWestFriday = [ModelRouteTypePage new];
    georgetownWestFriday.direction = @"West";
    georgetownWestFriday.pages = 5;
    georgetownWestFriday.dayType = fridayString;
    georgetownWestFriday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=31&direction=1&day=F&page=%i";
	*/
    
    ModelRouteTypePage* georgetownWestMondayToFriday = [ModelRouteTypePage new];
    georgetownWestMondayToFriday.direction = @"West";
    georgetownWestMondayToFriday.dayType = mondayToFridayString;
    georgetownWestMondayToFriday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=31&direction=1&day=1&page=%i";
    
	ModelRouteTypePage* georgetownWestSaturday = [ModelRouteTypePage new];
    georgetownWestSaturday.direction = @"West";
    georgetownWestSaturday.pages = 4;
    georgetownWestSaturday.dayType = saturdayString;
    georgetownWestSaturday.tableHeaderRowsToOffset = 1;
    /*
    georgetownWestSaturday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=31&direction=1&day=G&page=%i";
     */
    georgetownWestSaturday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=31&direction=1&day=6&page=%i";
	
	ModelRouteTypePage* georgetownWestSunday = [ModelRouteTypePage new];
    georgetownWestSunday.direction = @"West";
    georgetownWestSunday.pages = 6;
    georgetownWestSunday.dayType = sundayString;
    georgetownWestSunday.tableHeaderRowsToOffset = 1;
    /* Georgetown Sunday type used to be 'H'
    georgetownWestSunday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=31&direction=1&day=H&page=%i";
     */
    georgetownWestSunday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=31&direction=1&day=7&page=%i";
	
    /*
	ModelRouteTypePage* georgetownWestHoliday = [ModelRouteTypePage new];
    georgetownWestHoliday.direction = @"West";
    georgetownWestHoliday.dayType = holidayString;
    georgetownWestHoliday.tableHeaderRowsToOffset = 1;
    // Georgetown Holiday day type used to be 'I'
    //georgetownWestHoliday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=31&direction=1&day=I&page=%i";
    
    georgetownWestHoliday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=31&direction=1&day=9&page=%i";
	 */
    
	/* Georgetown used to have a monday to thursday schedule
     [georgetown.routeTypePages addObject:georgetownWestMondayToThursday];
	[georgetown.routeTypePages addObject:georgetownWestFriday];
     */
    [georgetown.routeTypePages addObject:georgetownWestMondayToFriday];
	[georgetown.routeTypePages addObject:georgetownWestSaturday];
	[georgetown.routeTypePages addObject:georgetownWestSunday];
	//[georgetown.routeTypePages addObject:georgetownWestHoliday];
	
	//Stations
	ModelStation* station;
	//Georgetown
	station = [ModelStation new];
    station.name = @"Bloor GO Station";
	[station.factoids addObject:@"Bloor GO Station's GO Transit code is \"BOGO\"."];
    station.isDescriptor = NO;
    station.address = @"1456 Bloor Street West, Toronto, ON";
	station.latitude = 43.658;
	station.longitude = -79.4509;
	[georgetown.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Weston GO Station";
	[station.factoids addObject:@"Weston GO Station's GO Transit code is \"WSGO\"."];
	[station.factoids addObject:@"Weston GO Station has over 100 parking spaces."];
    station.isDescriptor = NO;
	station.address = @"39 John Street, Etobicoke, ON";
	station.latitude = 43.701;
	station.longitude = -79.5147;
    [georgetown.stations addObject:station];
    [station release];
	
	
	station = [ModelStation new];
    station.name = @"Malton GO Station";
	[station.factoids addObject:@"Malton GO Station's GO Transit code is \"MTGO\"."];
	[station.factoids addObject:@"Malton GO Station has over 500 parking spaces."];
    station.isDescriptor = NO;
    station.address = @"3060 Derry Rd. E., Mississauga, ON";
	station.latitude = 43.705;
	station.longitude = -79.6382;
	[georgetown.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Etobicoke North GO stn";
	[station.factoids addObject:@"Etobicoke North GO Station's GO Transit code is \"ETGO\"."];
	[station.factoids addObject:@"Etobicoke North GO Station has over 500 parking spaces."];
    station.isDescriptor = NO;
    station.address = @"1949 Kipling Ave., Etobicoke, ON";
	station.latitude = 43.7063;
	station.longitude = -79.5624;
	[georgetown.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Bramalea City Centre";
	station.address = @"160 Central Park Dr., Brampton, ON";
	station.latitude = 43.719;
	station.longitude = -79.7205;
    station.isDescriptor = YES;
    [georgetown.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Bramalea GO Station";
	[station.factoids addObject:@"Bramalea GO Station's GO Transit code is \"BLGO\"."];
	[station.factoids addObject:@"Bramalea GO Station has over 2,150 parking spaces."];
    station.isDescriptor = NO;
	station.address = @"1713 Steeles Avenue, Bramalea, ON";
	station.latitude = 43.7017;
	station.longitude = -79.6911;
	[georgetown.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Brampton-Steeles and Ruther";
    station.isDescriptor = YES;
	station.address = @"Steeles Ave. at Rutherford Rd.";
	station.latitude = 43.6859;
	station.longitude = -79.7115;
    [georgetown.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Brampton GO Station";
	[station.factoids addObject:@"Brampton GO Station's GO Transit code is \"BRGO\"."];
	[station.factoids addObject:@"Brampton GO Station has over 950 parking spaces."];
    [station.factoids addObject:@"The city of Brampton was incorporated as a village in 1853, taking its name from the rural town of Brampton, Cumbria, England."];
	station.isDescriptor = NO;
    station.address = @"27 Church St. W., Brampton, ON";
	station.latitude = 43.6868;
	station.longitude = -79.7647;
	[georgetown.stations addObject:station];
    [station release];
	
	
	station = [ModelStation new];
    station.name = @"Brampton-Shopper's World";
    station.isDescriptor = YES;
	station.address = @"499 Main St. S., Brampton, ON";
	station.latitude = 43.666;
	station.longitude = -79.7332;
    [georgetown.stations addObject:station];
    [station release];	

	station = [ModelStation new];
    station.name = @"Brampton Bus Terminal";
	station.address = @"8 Nelson St. W., Brampton, ON";
	station.latitude = 43.6868;
	station.longitude = -79.7619;
    station.isDescriptor = YES;
    [georgetown.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Brampton-Hwy10 and Bovaird";
    station.isDescriptor = YES;
	station.address = @"Hurontario St. (Hwy. 10) & Bovaird Dr. (Hwy. 7)";
    station.latitude = 43.7058;
	station.longitude =-79.7869;
	[georgetown.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Mount Pleasant GO Station";
	[station.factoids addObject:@"Mount Pleasant GO Station's GO Transit code is \"MPGO\"."];
	[station.factoids addObject:@"Mount Pleasant GO Station has over 600 parking spaces."];
    station.isDescriptor = NO;
    station.address = @"1600 Bovaird Drive West, Brampton, ON";
	station.latitude = 43.6751;
	station.longitude = -79.8227;
	[georgetown.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Norval-Hwy 7 and King";
    station.isDescriptor = YES;
	station.address = @"Hwy 7 (Guelph St) @ King St.";
	station.latitude = 43.6466;
	station.longitude = -79.8602;
    [georgetown.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Georgetown Market";
    station.isDescriptor = YES;
	station.address = @"Guelph St. (Hwy. 7) @ Alcott Dr.";
	station.latitude = 43.6489;
	station.longitude = -79.8988;
    [georgetown.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Georgetown GO Station";
	[station.factoids addObject:@"Georgetown GO Station's GO Transit code is \"GEGO\"."];
	[station.factoids addObject:@"Georgetown GO Station has over 600 parking spaces."];
    [station.factoids addObject:@"Georgetown takes its name from George Kennedy, who settled in the area in 1821."];
	station.isDescriptor = YES;
    station.address = @"55 Queen St., Georgetown, ON";
	station.latitude = 43.6556;
	station.longitude = -79.9186;
	[georgetown.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Georgetown-MainandWesleyan";
    station.isDescriptor = YES;
    station.address = @"Main St. at Wesleyan St.";
	station.latitude = 43.6498;
	station.longitude = -79.9267;
	[georgetown.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Acton - Main St. North";
    station.isDescriptor = YES;
	station.address = @"Main St. N. (Hwy. 25) & Mill St. (Hwy .7)";
	station.latitude = 43.63;
	station.longitude = -80.0418;
    [georgetown.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Rockwood";
    station.isDescriptor = YES;
	station.address = @"Alma St. & Main St. (Hwy. 7)";
	station.latitude = 43.6185;
	station.longitude = -80.1437;
    [georgetown.stations addObject:station];
    [station release];

	station = [ModelStation new];
    station.name = @"Guelph Bus Terminal";
    station.isDescriptor = YES;
	station.address = @"141 MacDonell St., Guelph, ON";
	station.latitude = 43.5466;
	station.longitude = -80.2455;
    [georgetown.stations addObject:station];
    [station release];

	station = [ModelStation new];
    station.name = @"University of Guelph";
	station.address = @"50 Stone Road East, Guelph, ON";
	station.latitude = 43.5296;
	station.longitude = -80.2256;
    station.isDescriptor = YES;
    [georgetown.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Yorkdale Bus Terminal";
	station.address = @"1 Yorkdale Road., North York, ON";
	station.latitude = 43.7256;
	station.longitude = -79.4479;
    station.isDescriptor = YES;
    [georgetown.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"York Mills Bus Terminal";
	station.address = @"4023 Yonge St., North York, ON";
	station.latitude = 43.7446;
	station.longitude = -79.4069;
    station.isDescriptor = YES;
    [georgetown.stations addObject:station];
    [station release];
	
	
}
static void initializeBarrieData(NSMutableDictionary* mLineDictionary)
{
	ModelLine* barrie = [ModelLine new];
	barrie.name = @"Barrie";
	[barrie.directions addObject:@"North"];
	[barrie.directions addObject:@"South"];
	[mLineDictionary setObject:barrie forKey:barrie.name];
	barrie.r = 86;
	barrie.g = 178;
	barrie.b = 208;
	//Set daytypes
	[barrie.dayTypes addObject:mondayToFridayString];
	[barrie.dayTypes addObject:saturdayString];
	[barrie.dayTypes addObject:sundayString];
	//[barrie.dayTypes addObject:holidayString];
    
	//Barrie - South
	ModelRouteTypePage* barrieEastMondayToFriday = [ModelRouteTypePage new];
    barrieEastMondayToFriday.direction = @"South";
    barrieEastMondayToFriday.pages = 5;
    barrieEastMondayToFriday.dayType = mondayToFridayString;
    barrieEastMondayToFriday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=65&direction=0&day=1&page=%i";
	
	ModelRouteTypePage* barrieSouthSaturday = [ModelRouteTypePage new];
    barrieSouthSaturday.direction = @"South";
    barrieSouthSaturday.pages = 3;
    barrieSouthSaturday.dayType = saturdayString;
    barrieSouthSaturday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=65&direction=0&day=6&page=%i";
	
	ModelRouteTypePage* barrieSouthSunday = [ModelRouteTypePage new];
    barrieSouthSunday.direction = @"South";
    barrieSouthSunday.pages = 3;
    barrieSouthSunday.dayType = sundayString;
    barrieSouthSunday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=65&direction=0&day=7&page=%i";
	
    /*
	ModelRouteTypePage* barrieSouthHoliday = [ModelRouteTypePage new];
    barrieSouthHoliday.direction = @"South";
    barrieSouthHoliday.pages = 3;
    barrieSouthHoliday.dayType = holidayString;
    barrieSouthHoliday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=65&direction=0&day=9&page=%i";
	*/
     
	[barrie.routeTypePages addObject:barrieEastMondayToFriday];
	[barrie.routeTypePages addObject:barrieSouthSaturday];
	[barrie.routeTypePages addObject:barrieSouthSunday];
	//[barrie.routeTypePages addObject:barrieSouthHoliday];
	
	//Barrie - North
	ModelRouteTypePage* barrieNorthMondayToFriday = [ModelRouteTypePage new];
    barrieNorthMondayToFriday.direction = @"North";
    barrieNorthMondayToFriday.pages = 6;
    barrieNorthMondayToFriday.dayType = mondayToFridayString;
    barrieNorthMondayToFriday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=65&direction=1&day=1&page=%i";
	
	ModelRouteTypePage* barrieNorthSaturday = [ModelRouteTypePage new];
    barrieNorthSaturday.direction = @"North";
    barrieNorthSaturday.pages = 3;
    barrieNorthSaturday.dayType = saturdayString;
    barrieNorthSaturday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=65&direction=1&day=6&page=%i";
	
	ModelRouteTypePage* barrieNorthSunday = [ModelRouteTypePage new];
    barrieNorthSunday.direction = @"North";
    barrieNorthSunday.pages = 3;
    barrieNorthSunday.dayType = sundayString;
    barrieNorthSunday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=65&direction=1&day=7&page=%i";
	
    /*
	ModelRouteTypePage* barrieNorthHoliday = [ModelRouteTypePage new];
    barrieNorthHoliday.direction = @"North";
    barrieNorthHoliday.pages = 3;
    barrieNorthHoliday.dayType = holidayString;
    barrieNorthHoliday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=65&direction=1&day=9&page=%i";
	*/
    
	[barrie.routeTypePages addObject:barrieNorthMondayToFriday];
	[barrie.routeTypePages addObject:barrieNorthSaturday];
	[barrie.routeTypePages addObject:barrieNorthSunday];
	//[barrie.routeTypePages addObject:barrieNorthHoliday];
	
	//Stations
	ModelStation* station;
	//Barrie
	station = [ModelStation new];
    station.name = @"Aurora Rd. and Hwy. 404";
    station.isDescriptor = YES;
	station.address = @"Aurora Rd. & Hwy. 404";
	station.latitude = 44.0137;
	station.longitude = -79.4072;
    [barrie.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Aurora GO Station";
	[station.factoids addObject:@"Aurora GO Station's GO Transit code is \"AUGO\"."];
    [station.factoids addObject:@"Aurora GO Station's has over 1,700 parking spaces."];
    station.isDescriptor = NO;
	station.address = @"121 Wellington Street East, Aurora, ON";
	station.latitude = 44.0007;
	station.longitude = -79.4599;
    [barrie.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Newmarket Bus Terminal";
    station.isDescriptor = YES;
	station.address = @"320 Eagle St. W., Newmarket, ON";
	station.latitude = 44.0524;
	station.longitude = -79.4848;
    [barrie.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Holland Landing";
    station.isDescriptor = YES;
	station.address = @"Yonge St. (Hwy. 11) & Mount Albert Rd.";
	station.latitude = 44.0956;
	station.longitude = -79.4902;
    [barrie.stations addObject:station];
    [station release];

	station = [ModelStation new];
    station.name = @"Bradford GO Station";
	[station.factoids addObject:@"Bradford GO Station's GO Transit code is \"BDGO\"."];
	[station.factoids addObject:@"Bradford GO Station has just over 90 parking spots."];
    [station.factoids addObject:@"Bradford GO Station was the terminus of the Bradford line before it was extended to Barrie and renamed the Barrie line on December 17, 2007."];
	station.isDescriptor = NO;
	station.address = @"251 Holland St. E., Bradford, ON";
	station.latitude = 44.1172;
	station.longitude = -79.5562;
    [barrie.stations addObject:station];
    [station release];
	
	
	station = [ModelStation new];
    station.name = @"Bradford-Barrie @  John";
    station.isDescriptor = YES;
	station.address = @"Barrie St. (Hwy. 11) at John St.";
	station.latitude = 44.1153;
	station.longitude = -79.5651;
    [barrie.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Churchill-Hwy11/Killarney";
	station.address = @"Hwy. 11 (Yonge St.) at Killarney Beach Rd.";
	station.latitude = 44.215;
	station.longitude = -79.59;
    station.isDescriptor = YES;
    [barrie.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Stroud-11andVictoria";
    station.isDescriptor = YES;
	station.address = @"Hwy. 11 (Yonge St.) & Victoria Rd.";
	station.latitude = 44.3244;
	station.longitude = -79.6192;
    [barrie.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Barrie South GO Station";
	[station.factoids addObject:@"Barrie South GO Station's GO Transit code is \"BSGO\"."];
	[station.factoids addObject:@"Barrie South GO Station has over 450 parking spots."];
    [station.factoids addObject:@"Barrie South GO Station restores GO train service to Barrie, which was cut in the 1990s."];
	[station.factoids addObject:@"Barrie South GO Station was open for service in December 17th, 2007."];
	[station.factoids addObject:@"The first train to ever depart Barrie South GO was a morning train at 5:43am."];	
	[station.factoids addObject:@"Barrie South GO is used by around 675 riders per day, up from 350 at the time of its opening."];
	station.isDescriptor = NO;
	station.address = @"833 Yonge St, Barrie, ON";
	station.latitude = 44.3489;
	station.longitude = -79.6272;
    [barrie.stations addObject:station];
    [station release];	
	
	station = [ModelStation new];
    station.name = @"Barrie Bus Terminal";
    station.isDescriptor = YES;
	station.address = @"24 Maple Avenue, Barrie, ON";
	station.latitude = 44.3876;
	station.longitude = -79.6902;
    [barrie.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"York University GO Stn";
	[station.factoids addObject:@"York University GO Station's GO Transit code is \"YKGO\"."];
	[station.factoids addObject:@"York University GO Station was opened for service on September 6th, 2002."];
    station.isDescriptor = NO;
	station.address = @"595-A Canarctic Dr., North York, ON";
	station.latitude = 43.7788;
	station.longitude = -79.4834;
    [barrie.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Rutherford GO Station";
	[station.factoids addObject:@"Rutherford GO Station's GO Transit code is \"RUGO\"."];
	[station.factoids addObject:@"Rutherford GO Station was opened for service on September 7th, 2001."];
    [station.factoids addObject:@"Rutherford GO Station's has over 950 parking spaces."];
	station.isDescriptor = NO;
	station.address = @"699 Westburne Drive, Concord, ON";
	station.latitude = 43.8384;
	station.longitude = -79.4983;	
    [barrie.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Maple GO Station";
	[station.factoids addObject:@"Maple GO Station's GO Transit code is \"MAGO\"."];
	[station.factoids addObject:@"Maple GO Station originally built in 1903, to replace the 1853 original, which had burned down."];
    [station.factoids addObject:@"Maple GO Station's has over 350 parking spaces."];
    station.isDescriptor = NO;
	station.address = @"30 Station St., Vaughan, ON";
	station.latitude = 43.8594;
	station.longitude = -79.5071;	
    [barrie.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"King City GO Station";
	[station.factoids addObject:@"King City GO Station's GO Transit code is \"KGGO\"."];
	[station.factoids addObject:@"King City GO Station was open for service on September 7th, 1982."];
    [station.factoids addObject:@"King City GO Station's has over 350 parking spaces."];
	[station.factoids addObject:@"King City was home to Canada's first Doppler weather radar."];
    station.isDescriptor = NO;
	station.address = @"7 Station Rd., King City, ON";
	station.latitude = 43.92;
	station.longitude = -79.527;
    [barrie.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Newmarket GO Station";
	[station.factoids addObject:@"Newmarket GO Station's GO Transit code is \"NMGO\"."];
    [station.factoids addObject:@"Newmarket GO Station's has over 250 parking spaces."];
    station.isDescriptor = NO;
	station.address = @"465 Davis Dr., Newmarket, ON";
	station.latitude = 44.0607;
	station.longitude = -79.4604;
    [barrie.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"East Gwillimbury GO Stn";
	[station.factoids addObject:@"East Gwillimbury GO Station's GO Transit code is \"GWIL\"."];
    [station.factoids addObject:@"East Gwillimbury GO Station's has over 600 parking spaces."];
	[station.factoids addObject:@"East Gwillimbury GO Station was open for service on November 1st, 2004."];
    [station.factoids addObject:@"The town of East Gwillimbury was named after, Elizabeth Simcoe Gwillim, wife of the first Lieutenant Governor of Upper Canada."];
	station.isDescriptor = NO;
    station.address = @"845 Green Lane E., East Gwillimbury, ON";
	station.latitude = 44.077;
	station.longitude = -79.4552;
	[barrie.stations addObject:station];
    [station release];
}
static void initializeRichmondHillData(NSMutableDictionary* mLineDictionary)
{
	ModelLine* richmondHill = [ModelLine new];
	richmondHill.name = @"Richmond Hill";
	[richmondHill.directions addObject:@"North"];
	[richmondHill.directions addObject:@"South"];
	richmondHill.r = 34;
	richmondHill.g = 85;
	richmondHill.b = 132;
	
	[mLineDictionary setObject:richmondHill forKey:richmondHill.name];
	//Set daytypes
	//Richmond hill only has monday to friday schedules
	[richmondHill.dayTypes addObject:mondayToFridayString];

	//Richmond Hill - South
	ModelRouteTypePage* richmondHillSouthMondayToFriday = [ModelRouteTypePage new];
    richmondHillSouthMondayToFriday.direction = @"South";
    richmondHillSouthMondayToFriday.pages = 2;
    richmondHillSouthMondayToFriday.dayType = mondayToFridayString;
    richmondHillSouthMondayToFriday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=61&direction=0&day=1&page=%i";
	richmondHillSouthMondayToFriday.tableHeaderRowsToOffset = 1;
	[richmondHill.routeTypePages addObject:richmondHillSouthMondayToFriday];
	
	//Richmond Hill - North
	ModelRouteTypePage* richmondHillNorthMondayToFriday = [ModelRouteTypePage new];
    richmondHillNorthMondayToFriday.direction = @"North";
    richmondHillNorthMondayToFriday.pages = 2;
    richmondHillNorthMondayToFriday.dayType = mondayToFridayString;
    richmondHillNorthMondayToFriday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=61&direction=1&day=1&page=%i";
	richmondHillNorthMondayToFriday.tableHeaderRowsToOffset = 1;
	[richmondHill.routeTypePages addObject:richmondHillNorthMondayToFriday];
	
	//Stations
	ModelStation* station;
	//Richmond Hill
	station = [ModelStation new];
    station.name = @"Oriole GO Station";
	[station.factoids addObject:@"Oriole GO Station's GO Transit code is \"ORGO\"."];
    [station.factoids addObject:@"Oriole GO Station's has over 250 parking spaces."];
	[station.factoids addObject:@"Oriole GO Station was open for service on May 1st, 1978"];
	[station.factoids addObject:@"Oriole GO Station's platform passes under Highway 401"];
	station.isDescriptor = NO;
	station.address = @"3300 Leslie St., North York, ON";
	station.latitude = 43.7654;
	station.longitude = -79.3646;
    [richmondHill.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Old Cummer GO Station";
	[station.factoids addObject:@"Old Cummer GO Station's GO Transit code is \"CMGO\"."];
    [station.factoids addObject:@"Old Cummer GO Station's has over 400 parking spaces."];
	[station.factoids addObject:@"Old Cummer GO Station was open for service on May 1st, 1978"];
    station.isDescriptor = NO;
	station.address = @"5760 Leslie St., North York, ON";
	station.latitude = 43.7924;
	station.longitude = -79.3712;
    [richmondHill.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Langstaff GO Station";
	[station.factoids addObject:@"Langstaff GO Station's GO Transit code is \"LNGO\"."];
    [station.factoids addObject:@"Langstaff GO Station's has over 1,000 parking spaces."];
	[station.factoids addObject:@"Langstaff GO Station was open for service on May 1st, 1978"];	
    station.isDescriptor = NO;
	station.address = @"10 Red Maple Road, Thornhill, ON";
	station.latitude = 43.8383;
	station.longitude = -79.4233;
    [richmondHill.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Richmond Hill GO Station";
	[station.factoids addObject:@"Richmond Hill GO Station's GO Transit code is \"RHGO\"."];
    [station.factoids addObject:@"Richmond Hill GO Station's has over 1,200 parking spaces."];
	[station.factoids addObject:@"Richmond Hill GO Station was open for service on May 1st, 1978"];		
    [station.factoids addObject:@"Richmond Hill's geography was formed during the last ice-age, when southerly glaciers amassed and left a considerable amount of earth after receding."];		
	station.address = @"6 Newkirk Road, Richmond Hill, ON";
	station.latitude = 43.8749;
	station.longitude = -79.4267;
	station.isDescriptor = NO;
    [richmondHill.stations addObject:station];
    [station release];
}
static void initializeStouffvilleData(NSMutableDictionary* mLineDictionary)
{
	ModelLine* stouffville = [ModelLine new];
	stouffville.name = @"Stouffville";
	[stouffville.directions addObject:@"North"];
	[stouffville.directions addObject:@"South"];
	[mLineDictionary setObject:stouffville forKey:stouffville.name];
	
	[stouffville.dayTypes addObject:mondayToFridayString];
	[stouffville.dayTypes addObject:saturdayString];
	[stouffville.dayTypes addObject:sundayString];
	//[stouffville.dayTypes addObject:holidayString];
	
	stouffville.r = 180;
	stouffville.g = 151;
	stouffville.b = 140;
	
	//Stouffville - South
	ModelRouteTypePage* stouffvilleSouthMondayToFriday = [ModelRouteTypePage new];
    stouffvilleSouthMondayToFriday.direction = @"South";
    stouffvilleSouthMondayToFriday.dayType = mondayToFridayString;
    stouffvilleSouthMondayToFriday.urlFormat = @"http://gotransitnlb.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=71&direction=0&day=1&page=%i";
	
	ModelRouteTypePage* stouffvilleSouthSaturday = [ModelRouteTypePage new];
    stouffvilleSouthSaturday.direction = @"South";
    stouffvilleSouthSaturday.pages = 2;
    stouffvilleSouthSaturday.dayType = saturdayString;
    stouffvilleSouthSaturday.urlFormat = @"http://gotransitnlb.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=71&direction=0&day=6&page=%i";
	stouffvilleSouthSaturday.tableHeaderRowsToOffset = 1;
	
	ModelRouteTypePage* stouffvilleSouthSunday = [ModelRouteTypePage new];
    stouffvilleSouthSunday.direction = @"South";
    stouffvilleSouthSunday.pages = 2;
    stouffvilleSouthSunday.dayType = sundayString;
    stouffvilleSouthSunday.urlFormat = @"http://gotransitnlb.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=71&direction=0&day=7&page=%i";
	stouffvilleSouthSunday.tableHeaderRowsToOffset = 1;
	
	/*ModelRouteTypePage* stouffvilleSouthHoliday = [ModelRouteTypePage new];
    stouffvilleSouthHoliday.direction = @"South";
    stouffvilleSouthHoliday.pages = 2;
    stouffvilleSouthHoliday.dayType = holidayString;
    stouffvilleSouthHoliday.urlFormat = @"http://gotransitnlb.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=71&direction=0&day=9&page=%i";
	stouffvilleSouthHoliday.tableHeaderRowsToOffset = 1;
     */
	
	[stouffville.routeTypePages addObject:stouffvilleSouthMondayToFriday];
	[stouffville.routeTypePages addObject:stouffvilleSouthSaturday];
	[stouffville.routeTypePages addObject:stouffvilleSouthSunday];
	//[stouffville.routeTypePages addObject:stouffvilleSouthHoliday];
	
	//Stouffville - North
	ModelRouteTypePage* stouffvilleNorthMondayToFriday = [ModelRouteTypePage new];
    stouffvilleNorthMondayToFriday.direction = @"North";
    stouffvilleNorthMondayToFriday.pages = 4;
    stouffvilleNorthMondayToFriday.dayType = mondayToFridayString;
    stouffvilleNorthMondayToFriday.urlFormat = @"http://gotransitnlb.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=71&direction=1&day=1&page=%i";
    stouffvilleNorthMondayToFriday.tableHeaderRowsToOffset = 1;
	
	ModelRouteTypePage* stouffvilleNorthSaturday = [ModelRouteTypePage new];
    stouffvilleNorthSaturday.direction = @"North";
    stouffvilleNorthSaturday.pages = 2;
    stouffvilleNorthSaturday.dayType = saturdayString;
    stouffvilleNorthSaturday.urlFormat = @"http://gotransitnlb.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=71&direction=1&day=6&page=%i";
	stouffvilleNorthSaturday.tableHeaderRowsToOffset = 1;
	
	ModelRouteTypePage* stouffvilleNorthSunday = [ModelRouteTypePage new];
    stouffvilleNorthSunday.direction = @"North";
    stouffvilleNorthSunday.pages = 2;
    stouffvilleNorthSunday.dayType = sundayString;
    stouffvilleNorthSunday.urlFormat = @"http://gotransitnlb.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=71&direction=1&day=7&page=%i";
	stouffvilleNorthSunday.tableHeaderRowsToOffset = 1;
	
	/*ModelRouteTypePage* stouffvilleNorthHoliday = [ModelRouteTypePage new];
    stouffvilleNorthHoliday.direction = @"North";
    stouffvilleNorthHoliday.pages = 2;
    stouffvilleNorthHoliday.dayType = holidayString;
    stouffvilleNorthHoliday.urlFormat = @"http://gotransitnlb.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=71&direction=1&day=9&page=%i";
	stouffvilleNorthHoliday.tableHeaderRowsToOffset = 1;*/
	
	[stouffville.routeTypePages addObject:stouffvilleNorthMondayToFriday];
	[stouffville.routeTypePages addObject:stouffvilleNorthSaturday];
	[stouffville.routeTypePages addObject:stouffvilleNorthSunday];
	//[stouffville.routeTypePages addObject:stouffvilleNorthHoliday];
	
	//Stations
	ModelStation* station;
	//stouffville
	station = [ModelStation new];
    station.name = @"Kennedy GO Station";
	[station.factoids addObject:@"Kennedy GO Station's GO Transit code is \"KDGO\"."];
	[station.factoids addObject:@"Kennedy GO Station was open for service on June 2nd, 2005"];
    station.isDescriptor = NO;
	station.address = @"2467 Eglinton Avenue East, Scarborough, ON";
	station.latitude = 43.7323;
	station.longitude = -79.2624;
    [stouffville.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Agincourt GO Station";
	[station.factoids addObject:@"Agincourt GO Station's GO Transit code is \"AGGO\"."];
    [station.factoids addObject:@"Agincourt GO Station's has over 250 parking spaces."];
	[station.factoids addObject:@"Agincourt GO Station was open for service on September 7th, 1982."];
    station.isDescriptor = NO;
    station.address = @"4100 Sheppard Ave. E., Scarborough, ON";
    station.latitude = 43.7855;
    station.longitude = -79.284;
    [stouffville.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Milliken GO Station";
	[station.factoids addObject:@"Milliken GO Station's GO Transit code is \"MIGO\"."];
    [station.factoids addObject:@"Milliken GO Station's has over 700 parking spaces."];
	[station.factoids addObject:@"Milliken GO Station was open for service on September 6th, 2005."];
    station.isDescriptor = NO;
    station.address = @"39 Redlea Ave., Scarborough, ON";
    station.latitude = 43.8232;
    station.longitude = -79.3016;
    [stouffville.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Unionville GO Station";
	[station.factoids addObject:@"Unionville GO Station's GO Transit code is \"UVGO\"."];
    [station.factoids addObject:@"Unionville GO Station's has over 1,500 parking spaces."];
    station.isDescriptor = NO;
    station.address = @"7970 Kennedy Road, Markham, ON";
    station.latitude = 43.8516;
    station.longitude = -79.3148;
    [stouffville.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Centennial GO Station";
	[station.factoids addObject:@"Centennial GO Station's GO Transit code is \"CEGO\"."];
    [station.factoids addObject:@"Centennial GO Station's has over 150 parking spaces."];
    station.isDescriptor = NO;
    station.address = @"320 Bullock Drive, Markham, ON";
    station.latitude = 43.8737;
    station.longitude = -79.2894;
    [stouffville.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Markham GO Station";
	[station.factoids addObject:@"Markham GO Station's GO Transit code is \"MKGO\"."];
    [station.factoids addObject:@"Markham GO Station's has over 250 parking spaces."];
    station.isDescriptor = NO;
    station.address = @"214 Main Street Markham N., Markham, ON";
    station.latitude = 43.8827;
    station.longitude = -79.2626;
    [stouffville.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Mount Joy GO Station";
	[station.factoids addObject:@"Mount Joy GO Station's GO Transit code is \"MJGO\"."];
    [station.factoids addObject:@"Mount Joy GO Station's has over 450 parking spaces."];
    station.isDescriptor = NO;
    station.address = @"1801 Bur Oak Ave., Markham, ON";
    station.latitude = 43.9004; 
    station.longitude = -79.263;
    [stouffville.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Stouffville GO Station";
	[station.factoids addObject:@"Stouffville GO Station's GO Transit code is \"SVGO\"."];
    [station.factoids addObject:@"Stouffville GO Station's has over 200 parking spaces."];
    station.isDescriptor = NO;
	station.address = @"6176 Main Street, Stouffville, ON";
    station.latitude = 43.9714;
    station.longitude = -79.2501;
	
    [stouffville.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Lincolnville GO Station";
	[station.factoids addObject:@"Lincolnville GO Station's GO Transit code is \"LCGO\"."];
    [station.factoids addObject:@"Lincolnville GO Station's has over 150 parking spaces."];
    station.isDescriptor = NO;
    station.address = @"6840 Bethesda Road, Stouffville, ON";
    station.latitude = 43.9948;
    station.longitude = -79.2344;
    [stouffville.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Goodwood-Hwy 47andFront";
    station.isDescriptor = YES;
    station.address = @"Hwy. 47 @ Front St.";
    station.latitude = 44.0372;
    station.longitude = -79.1961;
    [stouffville.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Uxbridge-RailwayandSpruce";
    station.isDescriptor = YES;
    station.address = @"Railway St. & Spruce St.";
    station.latitude = 44.1098;
    station.longitude = -79.1249;
    [stouffville.stations addObject:station];
    [station release];
}
static void initializeLakeshoreEastData(NSMutableDictionary* mLineDictionary)
{
	//Lines
	ModelLine* lakeshoreEast = [ModelLine new];
    lakeshoreEast.name = @"Lakeshore East";
	[lakeshoreEast.directions addObject:@"East"];
	[lakeshoreEast.directions addObject:@"West"];
	lakeshoreEast.r = 169;
	lakeshoreEast.g = 76;
	lakeshoreEast.b = 65;
	
	//Store Lines in Line Dictionary
	[mLineDictionary setObject:lakeshoreEast forKey:lakeshoreEast.name];
	//Set daytypes
	[lakeshoreEast.dayTypes addObject:mondayToFridayString];
	[lakeshoreEast.dayTypes addObject:saturdayString];
	[lakeshoreEast.dayTypes addObject:sundayString];
	//[lakeshoreEast.dayTypes addObject:holidayString];
    
	//Lakeshore East - Westward
    ModelRouteTypePage* lakeshoreEastWestwardMondayToFriday = [ModelRouteTypePage new];
    lakeshoreEastWestwardMondayToFriday.direction = @"West";
    lakeshoreEastWestwardMondayToFriday.pages = 5;
    lakeshoreEastWestwardMondayToFriday.dayType = mondayToFridayString;
    lakeshoreEastWestwardMondayToFriday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=09&direction=0&day=1&page=%i";
	ModelRouteTypePage* lakeshoreEastWestwardSaturday = [ModelRouteTypePage new];
    lakeshoreEastWestwardSaturday.direction = @"West";
    lakeshoreEastWestwardSaturday.pages = 2;
    lakeshoreEastWestwardSaturday.dayType = saturdayString;
    lakeshoreEastWestwardSaturday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=09&direction=0&day=6&page=%i";
    ModelRouteTypePage* lakeshoreEastWestwardSunday = [ModelRouteTypePage new];
    lakeshoreEastWestwardSunday.direction = @"West";
    lakeshoreEastWestwardSunday.pages = 3;
    lakeshoreEastWestwardSunday.dayType = sundayString;
    lakeshoreEastWestwardSunday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=09&direction=0&day=7&page=%i";
	
    /*
    ModelRouteTypePage* lakeshoreEastWestwardHoliday = [ModelRouteTypePage new];
    lakeshoreEastWestwardHoliday.direction = @"West";
    lakeshoreEastWestwardHoliday.pages = 3;
    lakeshoreEastWestwardHoliday.dayType = holidayString;
    lakeshoreEastWestwardHoliday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=09&direction=0&day=9&page=%i";
    */
     
	[lakeshoreEast.routeTypePages addObject:lakeshoreEastWestwardMondayToFriday];
	[lakeshoreEast.routeTypePages addObject:lakeshoreEastWestwardSaturday];
	[lakeshoreEast.routeTypePages addObject:lakeshoreEastWestwardSunday];
	//[lakeshoreEast.routeTypePages addObject:lakeshoreEastWestwardHoliday];
	
    //Lakeshore East - Eastward
    ModelRouteTypePage* lakeshoreEastEastwardMondayToFriday = [ModelRouteTypePage new];
    lakeshoreEastEastwardMondayToFriday.direction = @"East";
    lakeshoreEastEastwardMondayToFriday.pages = 6;
    lakeshoreEastEastwardMondayToFriday.dayType = mondayToFridayString;
    lakeshoreEastEastwardMondayToFriday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=09&direction=1&day=1&page=%i";
	ModelRouteTypePage* lakeshoreEastEastwardSaturday = [ModelRouteTypePage new];
    lakeshoreEastEastwardSaturday.direction = @"East";
    lakeshoreEastEastwardSaturday.pages = 2;
    lakeshoreEastEastwardSaturday.dayType = saturdayString;
    lakeshoreEastEastwardSaturday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=09&direction=1&day=6&page=%i";
    ModelRouteTypePage* lakeshoreEastEastwardSunday = [ModelRouteTypePage new];
    lakeshoreEastEastwardSunday.direction = @"East";
    lakeshoreEastEastwardSunday.pages = 2;
    lakeshoreEastEastwardSunday.dayType = sundayString;
    lakeshoreEastEastwardSunday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=09&direction=1&day=7&page=%i";
	/*
    ModelRouteTypePage* lakeshoreEastEastwardHoliday = [ModelRouteTypePage new];
    lakeshoreEastEastwardHoliday.direction = @"East";
    lakeshoreEastEastwardHoliday.pages = 2;
    lakeshoreEastEastwardHoliday.dayType = holidayString;
    lakeshoreEastEastwardHoliday.urlFormat = @"http://www.gotransit.com/publicroot/en/schedules/pubsched.aspx?table=09&direction=1&day=9&page=%i";
     */
	
    [lakeshoreEast.routeTypePages addObject:lakeshoreEastEastwardMondayToFriday];
    [lakeshoreEast.routeTypePages addObject:lakeshoreEastEastwardSaturday];
	[lakeshoreEast.routeTypePages addObject:lakeshoreEastEastwardSunday];
	//[lakeshoreEast.routeTypePages addObject:lakeshoreEastEastwardHoliday];
	
	//Stations
	ModelStation* station;
    //Lakeshore West
    station = [ModelStation new];
    station.name = @"Newcastle-Bus Loop";
    station.isDescriptor = YES;
    station.address = @"Hwy. 2 (King St.) @ Mill St.";
    station.latitude = 43.9175;
    station.longitude = -78.5889;
	[lakeshoreEast.stations addObject:station];
    [station release];
    
    station = [ModelStation new];
    station.name = @"Bowmanville-WaverlyandBase";
    station.isDescriptor = YES;
    station.address = @"Waverly Rd. at Baseline Rd.";
    station.latitude = 43.8978;
    station.longitude = -78.690;
    [lakeshoreEast.stations addObject:station];
    [station release];
    
    station = [ModelStation new];
    station.name = @"Bowmanville-KingandLiberty";
    station.isDescriptor = YES;
    station.address = @"King St. (Hwy. 2) at Liberty St.";
    station.latitude = 43.9106;
    station.longitude = -78.6802;
    [lakeshoreEast.stations addObject:station];
    [station release];
    
    station = [ModelStation new];
    station.name = @"Bowmanville Park and Ride";
    station.isDescriptor = YES;
    station.address = @"Prince William Boulevard, Bowmanville, ON";
    station.latitude = 43.9114;
    station.longitude = -78.7021;
    [lakeshoreEast.stations addObject:station];
    [station release];

    station = [ModelStation new];
    station.name = @"Courtice-King/Courtice";
    station.isDescriptor = YES;
    station.address = @"Hwy. 2 (King St.) at Courtice Rd.";
    station.latitude = 43.912;
    station.longitude = -78.778;
    [lakeshoreEast.stations addObject:station];
    [station release];
    
    station = [ModelStation new];
    station.name = @"Oshawa-BondandCentre";
    station.isDescriptor = YES;
    station.address = @"Bond St., west of Centre St.";
    station.latitude = 43.8979;
    station.longitude = -78.8662;
    [lakeshoreEast.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Oshawa-KingandCentre";
    station.isDescriptor = YES;
    station.address = @"King St., west of Centre St.";
    station.latitude = 43.8971;
    station.longitude = -78.8657;
    [lakeshoreEast.stations addObject:station];
    [station release];
    
    station = [ModelStation new];
    station.name = @"Oshawa Centre Mall";
    station.isDescriptor = YES;
    station.address = @"Stevenson Rd, south of King St (Hwy 2).";
    station.latitude = 43.8931;
    station.longitude = -78.8834;
    [lakeshoreEast.stations addObject:station];
    [station release];
    
    station = [ModelStation new];
    station.name = @"Oshawa GO Station";
    station.isDescriptor = NO;
    station.address = @"915 Bloor Street West, Oshawa, ON";
    station.latitude = 43.8708;
    station.longitude = -78.8847;
	[station.factoids addObject:@"Oshawa GO Station's GO Transit code is \"OSGO\"."];
	[station.factoids addObject:@"Oshawa GO Station was opened in the 1960s, but not added to the Lakeshore East GO line until 1995."];
    [station.factoids addObject:@"Oshawa GO Station has over 2,200 parking spaces."];
	[lakeshoreEast.stations addObject:station];
    [station release];
    
    station = [ModelStation new];
    station.name = @"Whitby GO Station";
    station.isDescriptor = NO;
    station.address = @"1350 Brock Street South, Whitby, ON";
    station.latitude = 43.8648;
    station.longitude = -78.938;
	[station.factoids addObject:@"Whitby GO Station briefly served as it's line's eastern terminus, before the Oshawa GO Station was completed."];
	[station.factoids addObject:@"Whitby GO Station's GO Transit code is \"WHGO\"."];
	[station.factoids addObject:@"Whitby GO Station has over 2,950 parking spaces."];
	[lakeshoreEast.stations addObject:station];
    [station release];
    
    station = [ModelStation new];
    station.name = @"Ajax GO Station";
    station.address = @"100 Westney Road South, Ajax, ON";
    station.latitude = 43.8484;
    station.longitude = -79.0416;
	[station.factoids addObject:@"Ajax GO Station's GO Transit code is \"AJGO\"."];
	[station.factoids addObject:@"Ajax GO Station has over 1,800 parking spaces."];
    station.isDescriptor = NO;
	[lakeshoreEast.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Pickering GO Station";
    station.address = @"1322 Bayly St., Pickering, ON";
    station.latitude = 43.8311;
    station.longitude = -79.0857;
	[station.factoids addObject:@"Pickering GO Station's GO Transit code is \"PKGO\"."];
	[station.factoids addObject:@"Pickering GO Station has over 1,950 parking spaces."];
    station.isDescriptor = NO;
	[lakeshoreEast.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Rouge Hill GO Station";
    station.address = @"6251 Lawrence Avenue East, Scarborough, ON";
    station.latitude = 43.7802;
    station.longitude = -79.1302;
	[station.factoids addObject:@"Rouge Hill GO Station's GO Transit code is \"ROGO\"."];
	[station.factoids addObject:@"Rouge Hill GO Station has over 1,000 parking spaces."];
	[station.factoids addObject:@"Rouge Hill GO Station was opened for service on May 23rd, 1967."];
    station.isDescriptor = NO;
	[lakeshoreEast.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Guildwood GO Station";
    station.address = @"4105 Kingston Rd., Scarborough, ON";
    station.latitude = 43.755;
    station.longitude = -79.198;
	[station.factoids addObject:@"Guildwood GO Station's GO Transit code is \"GUGO\"."];
	[station.factoids addObject:@"Guildwood GO Station has over 1,300 parking spaces."];
    station.isDescriptor = NO;
	[lakeshoreEast.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Eglinton GO Station";
    station.address = @"2995 Eglinton Ave. E., Scarborough, ON";
    station.latitude = 43.7394;
    station.longitude = -79.2322;
	[station.factoids addObject:@"Eglinton GO Station's GO Transit code is \"EGGO\"."];
	[station.factoids addObject:@"Eglinton GO Station has over 800 parking spaces."];
    station.isDescriptor = NO;
	[lakeshoreEast.stations addObject:station];
    [station release];

	station = [ModelStation new];
    station.name = @"Scarborough GO Station";
    station.address = @"3615 St. Clair Avenue East, Toronto, ON";
    station.latitude = 43.7169;
    station.longitude = -79.255;
	[station.factoids addObject:@"Scarborough GO Station's GO Transit code is \"SCGO\"."];
	[station.factoids addObject:@"Scarborough GO Station has over 600 parking spaces."];
    station.isDescriptor = NO;
	[lakeshoreEast.stations addObject:station];
    [station release];
	
	station = [ModelStation new];
    station.name = @"Danforth GO Station";
    station.address = @"213 Main St., Toronto, ON";
    station.latitude = 43.6866;
    station.longitude = -79.2994;
	[station.factoids addObject:@"Danforth GO Station's GO Transit code is \"DAGO\"."];
    station.isDescriptor = NO;
	[lakeshoreEast.stations addObject:station];
    [station release];
}
static NSMutableDictionary* prepopulateData()
{
	NSMutableDictionary* mLineDictionary = [NSMutableDictionary new];
    //Initialize lines
	initializeLakeshoreWestData(mLineDictionary);
	initializeMiltonData(mLineDictionary);
	initializeKitchenerData(mLineDictionary);
	initializeBarrieData(mLineDictionary);
	initializeRichmondHillData(mLineDictionary);
	initializeStouffvilleData(mLineDictionary);
	initializeLakeshoreEastData(mLineDictionary);
	return mLineDictionary;
}
static CDStation* insertStation(NSManagedObjectContext *context, CDLine* line, ModelStation* mStation)
{
	CDStation* station = [NSEntityDescription insertNewObjectForEntityForName:@"CDStation" inManagedObjectContext:context];
	station.Name = mStation.name;
	station.Latitude = [NSNumber numberWithDouble:mStation.latitude];
	station.Longitude = [NSNumber numberWithDouble:mStation.longitude];
	station.isDescriptor = [NSNumber numberWithBool:mStation.isDescriptor];
	station.Address = mStation.address;
	
	for(NSString* factoidString in [mStation factoids])
	{
		CDFactoid* factoid = [NSEntityDescription insertNewObjectForEntityForName:@"CDFactoid" inManagedObjectContext:context];
		factoid.Body = [factoidString copy];
		factoid.Entity = station;
	}
	if(line)
	{
		[station addLinesObject:line];
	}
	
	return station;
}
static NSMutableDictionary* populateLinesAndStations(NSManagedObjectContext *context)
{
	/* Common Directions */
	NSArray* directions;
	CDDirection* northDirection = [NSEntityDescription insertNewObjectForEntityForName:@"CDDirection" inManagedObjectContext:context];
	northDirection.Name = @"North";
	CDDirection* southDirection = [NSEntityDescription insertNewObjectForEntityForName:@"CDDirection" inManagedObjectContext:context];
	southDirection.Name = @"South";
	CDDirection* westDirection = [NSEntityDescription insertNewObjectForEntityForName:@"CDDirection" inManagedObjectContext:context];
	westDirection.Name = @"West";
	CDDirection* eastDirection = [NSEntityDescription insertNewObjectForEntityForName:@"CDDirection" inManagedObjectContext:context];
	eastDirection.Name = @"East";
	directions = [NSArray arrayWithObjects:northDirection,southDirection,westDirection,eastDirection,nil];
	/* Common DayTypes */
	NSArray* dayTypes;
	
	CDDayType* mondayToFriday = [NSEntityDescription insertNewObjectForEntityForName:@"CDDayType" inManagedObjectContext:context];
	mondayToFriday.Name = mondayToFridayString;
	mondayToFriday.ShortenedName = @"Mon>Fri";
	mondayToFriday.Order = [NSNumber numberWithInt:0];
	
	CDDayType* mondayToThursday = [NSEntityDescription insertNewObjectForEntityForName:@"CDDayType" inManagedObjectContext:context];
	mondayToThursday.Name = mondayToThursdayString;
	mondayToThursday.ShortenedName = @"Mon>Th";
	mondayToThursday.Order = [NSNumber numberWithInt:1];
	
	CDDayType* friday = [NSEntityDescription insertNewObjectForEntityForName:@"CDDayType" inManagedObjectContext:context];
	friday.Name = fridayString;
	friday.ShortenedName = @"Fri";
	friday.Order = [NSNumber numberWithInt:2];
	
	CDDayType* saturday = [NSEntityDescription insertNewObjectForEntityForName:@"CDDayType" inManagedObjectContext:context];
	saturday.Name = saturdayString;
	saturday.ShortenedName = @"Sat";
	saturday.Order = [NSNumber numberWithInt:3];
	
	CDDayType* sunday = [NSEntityDescription insertNewObjectForEntityForName:@"CDDayType" inManagedObjectContext:context];
	sunday.Name = sundayString;
	sunday.ShortenedName = @"Sun";
	sunday.Order = [NSNumber numberWithInt:4];
	
	CDDayType* holiday = [NSEntityDescription insertNewObjectForEntityForName:@"CDDayType" inManagedObjectContext:context];
	holiday.Name = holidayString;
	holiday.ShortenedName = @"Holiday";
	holiday.Order = [NSNumber numberWithInt:5];
	
	dayTypes = [NSArray arrayWithObjects:mondayToThursday,mondayToFriday,friday,saturday,sunday,holiday,nil];
	/* Common Stations */
	//Transfer
    ModelStation* transferStation = [ModelStation new];
    transferStation.name = @"Transfer Node";
    transferStation.isDescriptor = YES;
	[transferStation.factoids addObject:@"Serving 200,000 passengers a day, it is the busiest passenger transportation facility in Canada."];
	
	//Union
    ModelStation* unionStation = [ModelStation new];
    unionStation.name = @"Union Station";
	[unionStation.factoids addObject:@"Union Station is the busiest passenger transportation facility in Canada, serving approximately quarter of a million passengers each day."];
	[unionStation.factoids addObject:@"Union Station's was opened for service on August 6th, 1927."];
	[unionStation.factoids addObject:@"Union Station's GO Transit code is \"USTN\"."];
	unionStation.address = @"140 Bay St., Toronto, ON";
	unionStation.latitude = 43.6456;
	unionStation.longitude = -79.3795;
	
	ModelStation* unionBusStation = [ModelStation new];
    unionBusStation.name = @"Toronto-Union Bus Term";
    unionBusStation.isDescriptor = YES;
	
	/* CDStations */
	CDStation* cdTransferStation = insertStation(context,nil,transferStation);
	CDStation* cdUnionStation = insertStation(context,nil,unionStation);
	CDStation* cdTransferBusStation = insertStation(context,nil,unionBusStation);
	
    //Create Lines Array
	NSMutableDictionary* lineModels = prepopulateData();
	for(NSString* lineKey in lineModels)
	{
		ModelLine* mLine = [lineModels objectForKey:lineKey];
		CDLine *line = [NSEntityDescription insertNewObjectForEntityForName:@"CDLine" inManagedObjectContext:context];
		line.Name = mLine.name;
		
		float r,g,b;
		r =  mLine.r / 255.0;
		g = mLine.g  / 255.0;
		b = mLine.b  / 255.0;
	
		line.PrimaryColourR = [NSNumber numberWithFloat:r];
		line.PrimaryColourG = [NSNumber numberWithFloat:g];
		line.PrimaryColourB = [NSNumber numberWithFloat:b];
		
		for(NSString* direction in mLine.directions)
		{
			for(CDDirection* cdDirection in directions)
			{
				if([direction isEqualToString:cdDirection.Name])
				{
					[line addDirectionsObject:cdDirection];
				}
			}
		}
		
		for(NSString* dayType in mLine.dayTypes)
		{
			for(CDDayType* cdDayType in dayTypes)
			{
				if([dayType isEqualToString:cdDayType.Name])
				{
					[line addDayTypesObject:cdDayType];
				}
			}
		}
		
		//Add Common stations to line
		[cdTransferStation addLinesObject:line];
		[cdUnionStation addLinesObject:line];
		[cdTransferBusStation addLinesObject:line];

		for(ModelStation* mStation in mLine.stations)
		{
			CDStation* station = [NSEntityDescription insertNewObjectForEntityForName:@"CDStation" inManagedObjectContext:context];
			station.Name = mStation.name;
			station.Latitude = [NSNumber numberWithDouble:mStation.latitude];
			station.Longitude = [NSNumber numberWithDouble:mStation.longitude];
			station.isDescriptor = [NSNumber numberWithBool:mStation.isDescriptor];
			station.Address = mStation.address;
			
			for(NSString* factoidString in [mStation factoids])
			{
				CDFactoid* factoid = [NSEntityDescription insertNewObjectForEntityForName:@"CDFactoid" inManagedObjectContext:context];
				factoid.Body = [factoidString copy];
				factoid.Entity = station;
			}
			
			[station addLinesObject:line];
		}
	}
	
	//Add common stations to lineModels
	for(NSString* lineKey in lineModels)
	{
		ModelLine* line = [lineModels objectForKey:lineKey];
		[line.stations addObject:transferStation];
		[line.stations addObject:unionStation];
		[line.stations addObject:unionBusStation];
	}
	//Release the models now that they've been added to the arrays
	[transferStation release];
	[unionStation release];
	[unionBusStation release];
	
	return lineModels;
}
void storeRoute(NSManagedObjectContext *context,ModelRoute* mRoute, NSString* dateType, NSMutableDictionary* stationNameRowLookupDictionary)
{
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"CDLine" inManagedObjectContext:context];
	NSFetchRequest *lineRequest = [[[NSFetchRequest alloc] init] autorelease];
	[lineRequest setEntity:entityDescription];
	[lineRequest setPredicate:[NSPredicate predicateWithFormat:@"(Name = %@)", mRoute.line]];
	NSArray *lineRequestResults = [context executeFetchRequest:lineRequest error:nil];
	CDLine* line = [lineRequestResults objectAtIndex:0];
	
    CDRoute* route = [NSEntityDescription insertNewObjectForEntityForName:@"CDRoute" inManagedObjectContext:context];
    route.Line = line;
	
	//Set route direction
	for(CDDirection* direction in line.Directions)
	{
		if([mRoute.direction isEqualToString:direction.Name])
		{
			route.Direction = direction;
			break;
		}
	}
    int stopCounter = 1;
	
	#if (PRINT_EACH_RECORDED_STOP==1)
	NSMutableString* routeDescription = [[NSMutableString alloc] initWithFormat:@"\n\nRoute on line : %@ \n",route.Line.Name];
	#endif
    for(ModelStop* mStop in mRoute.stops)
    {
        CDStop *stop = [NSEntityDescription insertNewObjectForEntityForName:@"CDStop" inManagedObjectContext:context];
        NSString *stationName = [stationNameRowLookupDictionary objectForKey:[[NSNumber numberWithInt: mStop.stationNumber] stringValue]];
		
		#if (PRINT_EACH_RECORDED_STOP==1)
		[routeDescription appendFormat:@"Stop:%i Station: %@ Time: %@ \n",stopCounter, stationName, mStop.time];
		#endif
		
		//Lookup station name in Core Data Context
		NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"CDStation" inManagedObjectContext:context];
		NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
		[request setEntity:entityDescription];
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Name = %@)", stationName];
		[request setPredicate:predicate];
        
        NSArray *array = [context executeFetchRequest:request error:nil];
        if([array count] > 0)
        {
            stop.Station = [array objectAtIndex:0];
            stop.Route = route;
            if([mStop.type isEqualToString:@"Bus"])
            {
                stop.isTrain = [NSNumber numberWithBool:NO];
            }
            else 
            {
                stop.isTrain = [NSNumber numberWithBool:YES];
            }
            stop.DayType = [dateType copy];
			stop.finalStop = [NSNumber numberWithBool: mStop.isFinal];
            
            //Parse Date
            NSString* filteredDate;
			//Removes those pesky trailing characters
			if([mStop.time length] >= 5)
			{
				filteredDate = [mStop.time stringByReplacingOccurrencesOfString:@" " withString:@""];
				filteredDate = [filteredDate stringByReplacingOccurrencesOfString:@"n" withString:@""];
				filteredDate = [filteredDate stringByReplacingOccurrencesOfString:@"k" withString:@""];
				filteredDate = [filteredDate stringByReplacingOccurrencesOfString:@"b" withString:@""];
				filteredDate = [filteredDate stringByReplacingOccurrencesOfString:@"h" withString:@""];
				filteredDate = [filteredDate stringByReplacingOccurrencesOfString:@"L" withString:@""];
				filteredDate = [filteredDate stringByReplacingOccurrencesOfString:@"D" withString:@""];
			}
			else 
			{
				filteredDate = mStop.time;
			}

			NSMutableString *mutableTime = [filteredDate mutableCopy];
			
            [mutableTime insertString:@":" atIndex:(mutableTime.length -2)];
            [mutableTime insertString:@"1/1/2000 " atIndex:0];
			NSDate* time = [NSDate dateWithNaturalLanguageString:mutableTime locale:nil ];
			
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:(kCFCalendarUnitHour | kCFCalendarUnitMinute) fromDate:time];
            NSInteger hour = [components hour];
            
			//If time is before 3AM, count it as part of the next day
            if(hour < 3)
            {
                time = [time addTimeInterval:24*60*60];
            }
            
			stop.Time = time;
			[mutableTime release];
        }
        stopCounter++;
    }
	#if (PRINT_EACH_RECORDED_STOP==1)
	NSLog(routeDescription);
	#endif
    
}
//Deals with the logic of creating, appending to, and ending routes
static void parseTime(NSMutableDictionary* routes,ModelLine* mLine,ModelRouteTypePage* routePageType, NSMutableArray* finishedRoutes,NSString* rowLabel, HTMLNode*  cell, int column, int row)
{
	NSAutoreleasePool *miniPool = [NSAutoreleasePool new];
	//Checks if the station is part of this line
	BOOL lineStation = NO;
	for(ModelStation *station in mLine.stations)
	{		
		if([station.name isEqualToString:rowLabel])
		{
			#if (PRINT_EACH_VALIDATED_STATION==1)
			NSLog(@"Station named '%@' is valid ",rowLabel);
			#endif
			lineStation = YES;
			break;
		}
	}
	
	#if (PRINT_EACH_UNRECORDED_STOP==1)
	if(!lineStation)
	{
		NSLog(@"Did not record stop, Station named = '%@' did not match any stations on line '%@'",rowLabel,mLine.name);
	}
	#endif
	
	//String value of column number
	NSString *key = [[NSNumber numberWithInt:column]stringValue];
	//Currently chained route for column, nil if no route being chained
	ModelRoute* route = [routes objectForKey:key];
	//If Station is on the line
	if(lineStation)
	{
		//If cell has no content
		if(![cell contents])
		{
			//If cell has no content, and there's a route being chained, cut it off and store it
			if(route)
			{
				[routes removeObjectForKey:key];
				
				int count = [route.stops count];
				ModelStop* finalStop = [route.stops objectAtIndex:count - 1];
				finalStop.isFinal = YES;
				
				[finishedRoutes addObject:route];
			}
			//else do nothing
		}
		//If cell has content
		else 
		{
			BOOL created = NO;
			//If there's content, but no route in memory, create one
			if(!route)
			{
				//Start new route
				created = YES;
				route = [ModelRoute new];	
                route.direction = [routePageType.direction copy];
				route.line = [mLine.name copy];
			}
			NSString* stopType;
			NSString* cellClass = [cell getAttributeNamed:@"class"];
			if([cellClass isEqualToString:@"BUS"])
			{
				stopType = @"Bus";
			}
			else if([cellClass isEqualToString:@"TRAIN"])
			{
				stopType = @"Train";
			}
			else 
			{
				NSString * cellData;
				HTMLNode *div = [cell findChildTag:@"div"];
				if(div)
				{
					cellData = [div contents];
				}
				else 
				{	
					cellData = [cell contents];
					
				}
				if([cellData isEqualToString : @"NOSTOP"])
				{
					stopType = @"NO STOP";
				}
				else 
				{
				stopType = @"! Error !";	
				}
			}
			if([stopType isEqualToString:@"NO STOP"])
			{
                //Not a stop
                
                //NOTE: NOT SURE IF NEEDED, WAS COMMENTED OUT
                //Remove current entity, so there's no repeat
                //[route removeLastObject];
			}
            else if([[cell contents] rangeOfString:@"↓"].length > 0)
            {
                NSLog(@"%@",[cell contents]);
                //Not a stop
            }
			else		
			{
				ModelStop* stop = [ModelStop new];
				stop.stationNumber = row;
				
				if([[cell contents] isKindOfClass:[NSString class]])
				{
                    NSString* filteredCellContents = [[cell contents] stringByReplacingOccurrencesOfString:@"s" withString:@""];
                    
					stop.time = [filteredCellContents copy];
					stop.type = [stopType copy];	
					[route.stops addObject:stop];
					if(created)
					{
						[routes setValue:route forKey:[[NSNumber numberWithInt:column] stringValue] ];
					}
				}
			}
			[stopType release];
		}
		[key release];
	}
	//If Station is not on the line
	else 
	{
		//If there's a route for this column, then the route is leaving the current Line
		if(route)
		{
			//End chain
			[routes removeObjectForKey:key];
			
			int count = [route.stops count];
			ModelStop* finalStop = [route.stops objectAtIndex:count - 1];
			finalStop.isFinal = YES;
			
			[finishedRoutes addObject:route];
			
			// TODO : Transition to another line
		}
	}

	[miniPool drain];
}
static BOOL parsePage(NSManagedObjectContext *context,NSString* sUrl,ModelLine* line, ModelRouteTypePage* routePageType)
{
	//Save completed routes
	NSMutableArray *finishedRoutes = [NSMutableArray new];
	//Save routes being tracked
	NSMutableDictionary *routeDictionary = [NSMutableDictionary new];
	//Save station names mapped to the row they were found on
    NSMutableDictionary*stationNameRowLookupDictionary = [NSMutableDictionary new];
	
	int minColumnRange = 7;
	int maxColumnRange =  - 1;
    BOOL isFurtherPage = NO;
	
	NetworkRequest* request = [[NetworkRequest alloc] initWithUrl:sUrl];
	NSString *response = [[request post:nil] retain];
    
    //Detects if there is a further page
    if([response rangeOfString:@"tri_r.jpg"].location != NSNotFound )
    {
        isFurtherPage = YES;
    }
	
	BOOL transformStationNames = YES;
	BOOL filterTags = YES;
	BOOL filterArtifacts = YES;
	BOOL filterBus = YES;
	BOOL filterTransfer = YES;
	BOOL filterTrain = YES;
	BOOL filterNoStop = YES;
    BOOL filterTripExceptions = YES;
	
	//Transform Station Names
	if(transformStationNames)
	{
		response = [response stringByReplacingOccurrencesOfString:@"Toronto-Union Bus Term" withString:@"Union Station"];
	}
	//TAGS
	if(filterTags)
	{
		response = [response stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"<b><font face=\"Verdana\" size=\"2\">" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"</b></font>" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"<font>" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"<font face=\"Verdana\" size=\"1\">" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"</font>" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];	
		response = [response stringByReplacingOccurrencesOfString:@"<HEAD>" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"<TITLE>GOTransit.com - Timetable Details</TITLE>" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"</HEAD>" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"<font color=black>" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"<font color=#008000>" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"</div>\r\n</form>" withString:@"</form>"];
		response = [response stringByReplacingOccurrencesOfString:@"</form>" withString:@""];
	}
	//Artifacts
	if(filterArtifacts)
	{
		response = [response stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"id=\"arrowkey\"" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"id=arrowkey" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"id=\"bbb\"" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"id=\"YY\"" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"id=wchair" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"id=\"wchair\"" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"id=\"zone\"" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"id=\"remark\"" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"id=\"sname\"" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"id=\"arrdepart\"" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"<!===================== Instructions & Links ================================>" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"<!===================== Schedule Description ================================>" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"<!===================== Schedule times ====================================>" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"<!======================= Schedule notes =======================!>" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"% nowrap" withString:@""];
		//response = [response stringByReplacingOccurrencesOfString:@"&" withString:@"and"];	
	}
	//TRAINS
	if(filterTrain)
	{
		response = [response stringByReplacingOccurrencesOfString:@"id=\"G\"" withString:@"class='TRAIN'"];
	}
	else 
	{
		response = [response stringByReplacingOccurrencesOfString:@"id=\"G\"" withString:@" "];
	}
	//BUSES
	if(filterBus)
	{
		response = [response stringByReplacingOccurrencesOfString:@"id=\"Y\"" withString:@"class='BUS'"];
	}
	else 
	{
		response = [response stringByReplacingOccurrencesOfString:@"id=\"Y\"" withString:@" "];
	}
	//TRANSFER
	if(filterTransfer)
	{
		response = [response stringByReplacingOccurrencesOfString:@"id=\"P\"" withString:@"class='TRANSFER'"];
		response = [response stringByReplacingOccurrencesOfString:@"id=\"E\"" withString:@"class='TRANSFER'"];	
	}
	else {
		response = [response stringByReplacingOccurrencesOfString:@"id=\"P\"" withString:@" "];
		response = [response stringByReplacingOccurrencesOfString:@"id=\"E\"" withString:@" "];
	}
	//NO STOP
	if(filterNoStop)
	{
		response = [response stringByReplacingOccurrencesOfString:@"id=\"YY\"" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"id=\"GG\"" withString:@""];
		response = [response stringByReplacingOccurrencesOfString:@"↓" withString:@"<div class='NOSTOP'>NOSTOP</div>"];
	}
	else 
	{
		response = [response stringByReplacingOccurrencesOfString:@"id=\"YY\"" withString:@" "];
		response = [response stringByReplacingOccurrencesOfString:@"id=\"GG\"" withString:@" "];
	}
    //FILTER TRIP EXCEPTIONS
    if(filterTripExceptions)
    {
        response = [response stringByReplacingOccurrencesOfString:@"id=YYYY" withString:@""];
    }
    
	if(response)
	{
        #if (LOG_HTTP_RESPONSE == 1)
        NSLog(@"Response : %@",response);
        #endif
		HTMLParser *parser = [[HTMLParser alloc] initWithString:response error:nil];
		HTMLNode * bodyNode = [parser body];
		NSArray * scheduleTables = [bodyNode findChildTags:@"table"];
		//Schedule Table
		HTMLNode *scheduleTable = [scheduleTables objectAtIndex:1]; 
		NSArray * tableRows = [scheduleTable findChildTags:@"tr"];
		
		int rowCounter = 0;
		for(HTMLNode *row in tableRows)
		{
            rowCounter++;
            /*if(rowCounter == 1)
            {
				int cellCounter = 0;
				NSArray * rowCells = [row findChildTags:@"td"];
				for(HTMLNode *cell in rowCells)
				{
					cellCounter++;
					if(cellCounter == 7)
					{
						//Get  Schedule Type
                            //TODO : Implement dynamic date type
						//dateType = [cell contents];
					}
				}
            }*/
            //Use this Column to count the amounts of columns to parse
            if(rowCounter == routePageType.tableHeaderRowsToOffset)
            {
				NSArray * rowCells = [row findChildTags:@"td"];
				for(HTMLNode *cell in rowCells)
				{
					maxColumnRange++;
				}
            }
            //Where the route data begins
            else if (rowCounter >= (routePageType.tableHeaderRowsToOffset + 1))
            {
                bool validRow = YES;
				int cellCounter = 0;
				NSArray * rowCells = [row findChildTags:@"td"];
				//The label set for the row (usually a station name)
				NSString* rowLabel;
				
				for(HTMLNode *cell in rowCells)
				{
					cellCounter++;
					//Station Number
					if(cellCounter == 1)
					{
						//Get Station Number
                        //DO NOTHING
					}
					//Station Name
					else if(cellCounter == 2)
					{
                        //Save station name
                        if(![cell contents])
                        {
                            HTMLNode* AHref = [[cell children] objectAtIndex:0];
                            rowLabel = [[AHref contents] stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
                        }
                        else
                        {
                            rowLabel = [cell contents];
                        }
                        //Break out of invalid rows
                        if([rowLabel rangeOfString:@"*Trip Exceptions"].location != NSNotFound)
                        {
                            //Breaks out of for loop
                            break;
                        }

                        //If this is a valid row, add the station name to the dictionary
                        [stationNameRowLookupDictionary setObject:rowLabel forKey:[NSString stringWithFormat:@"%i",rowCounter]];
                        
					}
					//else if(cellCounter ==8)
					else if(cellCounter >= minColumnRange /*&& cellCounter <= maxColumnRange*/)
					{
						parseTime(routeDictionary,line,routePageType,finishedRoutes,rowLabel,cell,cellCounter,rowCounter);
					}
				}
			}
			else 
			{
				//Skip unneeded rows
				continue;
			}
		}
		//Any Routes continuing to the end, should be cut off and stored.
		for(NSString* key in [routeDictionary allKeys])
		{
			ModelRoute* route = [routeDictionary objectForKey:key];
			[routeDictionary removeObjectForKey:key ];
			[finishedRoutes addObject:route];
		}
		//[stationDictionary release];
	}
	
	int counter = 1;
	NSMutableArray *routesToRemove = [NSMutableArray new];
	
	for(ModelRoute* route in finishedRoutes)
	{
		NSMutableArray *stopsToRemove = [NSMutableArray new];
		int stopCounter = 1;
		BOOL previousWasTransfer = NO;
		NSString* previousStop = @"";
		NSString* previousTime = @"";
		
		int counter = 0;
		for(ModelStop* stop in route.stops)
		{
			counter++;
			if(counter == [route.stops count])
			{
				stop.isFinal = YES;
			}

			NSNumber * StationNumber = [NSNumber numberWithInt:stop.stationNumber];
			
			NSString *stationName = [stationNameRowLookupDictionary objectForKey:[StationNumber stringValue]];
			if([stop.type isEqualToString:@"! Error !"])
			{
				if(previousWasTransfer)
				{
					[stopsToRemove addObject:stop];
				}
				previousWasTransfer = YES;
			}
			else 
			{
				previousWasTransfer = NO;
				
				NSString* timeCopy = [stop.time copy];
				
					if([timeCopy isEqualToString:previousTime])
					{
						if([stationName isEqualToString:previousStop])
						{
							[stopsToRemove addObject:stop];
						}
					}

				//[timeCopy release];
				previousStop = [stationName copy];
				previousTime = [stop.time copy];

			}
			stopCounter++;
		}
		
		//If ends on transfer, remove it
		if(previousWasTransfer)
		{
			if(![stopsToRemove containsObject:[route.stops lastObject]])
			{
				[stopsToRemove addObject:[route.stops lastObject]];
			}
		}
		
		//Delete all rougue Transfer squares, and repeat stops with same time
		if(stopsToRemove)
		{
			[route.stops removeObjectsInArray:stopsToRemove];
		}
		
		//Delete all 1 or less square routes
		if([route.stops count] <= 1)
		{
			[routesToRemove addObject:route];	
		}
		counter++;
	}
	[finishedRoutes removeObjectsInArray:routesToRemove];
	
    //Store all collected routes in Core Data
    for(ModelRoute* route in finishedRoutes)
    {
        storeRoute(context,route,routePageType.dayType ,stationNameRowLookupDictionary);
    }
    //Release objects
    [stationNameRowLookupDictionary release];
	[routeDictionary release];

    return isFurtherPage;
}
static void parseSubwayStations(NSManagedObjectContext *context)
{
	NSData *databuffer;
	NSFileHandle* file;
	file = [NSFileHandle fileHandleForReadingAtPath: @"subwaystations.txt"];
	if (file == nil)
        NSLog(@"Failed to open file");
	databuffer = [file readDataToEndOfFile];
	[file closeFile];
	
	NSString* xmlString = [[NSString alloc] initWithData:databuffer encoding:NSASCIIStringEncoding];
	TBXML * subwayXmlParser = [TBXML tbxmlWithXMLString:xmlString];
	TBXMLElement* rootElement = subwayXmlParser.rootXMLElement;
	
	TBXMLElement* stationElement = rootElement->firstChild;
	while(stationElement)
	{
		
		NSString* nodeName = [NSString stringWithCString:stationElement->name];
		if([nodeName isEqualToString:@"root"])
		{
			break;
		}
		
		TBXMLElement* nameElement = [TBXML childElementNamed:@"title" parentElement:stationElement];
		TBXMLElement* descriptionElement = [TBXML childElementNamed:@"description" parentElement:stationElement];
		TBXMLElement* addressElement = [TBXML childElementNamed:@"address" parentElement:stationElement];
		TBXMLElement* latLongElement = [TBXML childElementNamed:@"georss:point" parentElement:stationElement];
		
		NSString* name = [NSString stringWithCString:nameElement->text encoding:NSUTF8StringEncoding];
		NSString* description = [NSString stringWithCString:descriptionElement->text encoding:NSUTF8StringEncoding];
		NSString* address = [NSString stringWithCString:addressElement->text encoding:NSUTF8StringEncoding];
		
		
		NSString* latLongString = [NSString stringWithCString:latLongElement->text encoding:NSUTF8StringEncoding];
		NSString* latString = [[latLongString componentsSeparatedByString:@" "] objectAtIndex:0];
		NSString* longString = [[latLongString componentsSeparatedByString:@" "] objectAtIndex:1];
		
		double lat = [latString doubleValue];
		double lon = [longString doubleValue];
		
		CDSubwayStation* subwayStation = [NSEntityDescription insertNewObjectForEntityForName:@"CDSubwayStation" inManagedObjectContext:context];
		subwayStation.Name = name;
		subwayStation.Address = address;
		subwayStation.Latitude = [NSNumber numberWithDouble:lat];
		subwayStation.Longitude =  [NSNumber numberWithDouble:lon];
		subwayStation.Description = description;
		
		stationElement = stationElement->nextSibling;
	}

}

static void parseTrafficCameras(NSManagedObjectContext *context)
{
	NSData *databuffer;
	NSFileHandle* file;
	file = [NSFileHandle fileHandleForReadingAtPath: @"trafficcameras.txt"];
	if (file == nil)
        NSLog(@"Failed to open file");
	databuffer = [file readDataToEndOfFile];
	[file closeFile];
	
	CDRoadway* rGardinerLakeshore = [NSEntityDescription insertNewObjectForEntityForName:@"CDRoadway" inManagedObjectContext:context];
	rGardinerLakeshore.Name = @"Gardiner / Lakeshore";
	rGardinerLakeshore.BaseUrl = @"http://www.mto.gov.on.ca/english/traveller/compass/camera/pictures";

	//http://www.mto.gov.on.ca/english/traveller/compass/camera/pictures/BurlCamera/
	
	
	CDRoadway* rQEW = [NSEntityDescription insertNewObjectForEntityForName:@"CDRoadway" inManagedObjectContext:context];
	rQEW.Name = @"QEW";
	rQEW.BaseUrl = @"http://www.mto.gov.on.ca/english/traveller/compass/camera/pictures";

	CDRoadway* r401 = [NSEntityDescription insertNewObjectForEntityForName:@"CDRoadway" inManagedObjectContext:context];
	r401.Name = @"401";
	r401.BaseUrl = @"http://www.mto.gov.on.ca/english/traveller/compass/camera/pictures";

	CDRoadway* r404 = [NSEntityDescription insertNewObjectForEntityForName:@"CDRoadway" inManagedObjectContext:context];
	r404.Name = @"404";
	r404.BaseUrl = @"http://www.mto.gov.on.ca/english/traveller/compass/camera/pictures";
	
	CDRoadway* r400 = [NSEntityDescription insertNewObjectForEntityForName:@"CDRoadway" inManagedObjectContext:context];
	r400.Name = @"400";
	r400.BaseUrl = @"http://www.mto.gov.on.ca/english/traveller/compass/camera/pictures";

	CDRoadway* r427 = [NSEntityDescription insertNewObjectForEntityForName:@"CDRoadway" inManagedObjectContext:context];
	r427.Name = @"427";
	r427.BaseUrl = @"http://www.mto.gov.on.ca/english/traveller/compass/camera/pictures";
	
	CDRoadway* r403 = [NSEntityDescription insertNewObjectForEntityForName:@"CDRoadway" inManagedObjectContext:context];
	r403.Name = @"403";
	r403.BaseUrl = @"http://www.mto.gov.on.ca/english/traveller/compass/camera/pictures";
	
	CDRoadway* r410 = [NSEntityDescription insertNewObjectForEntityForName:@"CDRoadway" inManagedObjectContext:context];
	r410.Name = @"410";
	r410.BaseUrl = @"http://www.mto.gov.on.ca/english/traveller/compass/camera/pictures";
	
	/*
	 Gardiner / Lakeshore - http://www.city.toronto.on.ca/trafficimages/
	 401 - http://www.mto.gov.on.ca/english/traveller/compass/camera/pictures
	 QEW - http://www.mto.gov.on.ca/english/traveller/compass/camera/pictures
	 404 - http://www.mto.gov.on.ca/english/traveller/compass/camera/pictures
	 400 - http://www.mto.gov.on.ca/english/traveller/compass/camera/pictures
	 427 - http://www.mto.gov.on.ca/english/traveller/compass/camera/pictures
	 403 - http://www.mto.gov.on.ca/english/traveller/compass/camera/pictures
	 410 - http://www.mto.gov.on.ca/english/traveller/compass/camera/pictures
	 */
	
	NSString* xmlString = [[NSString alloc] initWithData:databuffer encoding:NSASCIIStringEncoding];
	TBXML * subwayXmlParser = [TBXML tbxmlWithXMLString:xmlString];
	TBXMLElement* rootElement = subwayXmlParser.rootXMLElement;
	
	TBXMLElement* cameraElement = rootElement->firstChild;
	while(cameraElement)
	{
		
		NSString* nodeName = [NSString stringWithCString:cameraElement->name];
		if([nodeName isEqualToString:@"cameras"])
		{
			break;
		}
		
		TBXMLElement* pointElement = [TBXML childElementNamed:@"point" parentElement:cameraElement];
		TBXMLElement* thumbElement = [TBXML childElementNamed:@"thumb" parentElement:cameraElement];
		TBXMLElement* titleElement = [TBXML childElementNamed:@"title" parentElement:cameraElement];
		TBXMLElement* regionElement = [TBXML childElementNamed:@"region" parentElement:cameraElement];
		
		
		NSString * latString = [TBXML valueOfAttributeNamed:@"lat" forElement:pointElement];
		NSString * longString = [TBXML valueOfAttributeNamed:@"lng" forElement:pointElement];
		NSString * relativeUrlString = [TBXML valueOfAttributeNamed:@"url" forElement:thumbElement];
		NSString * nameString = [NSString stringWithCString:titleElement->text encoding:NSUTF8StringEncoding];
		NSString * regionString = [NSString stringWithCString:regionElement->text encoding:NSUTF8StringEncoding];
		
		
		double lat = [latString doubleValue];
		double lon = [longString doubleValue];
		CDCamera* camera = [NSEntityDescription insertNewObjectForEntityForName:@"CDCamera" inManagedObjectContext:context];
		camera.Latitude = [NSNumber numberWithDouble:lat];
		camera.Longitude = [NSNumber numberWithDouble:lon];
		camera.Name = nameString;
		camera.RelativeUrl = relativeUrlString;
		
		if([regionString isEqualToString:@"Gardiner / Lakeshore"])
		{
			camera.Roadway = rGardinerLakeshore;
		}
		else if([regionString isEqualToString:@"QEW"])
		{
			camera.Roadway = rQEW;
		}
		else if([regionString isEqualToString:@"401"])
		{
			camera.Roadway = r401;
		}
		else if([regionString isEqualToString:@"400"])
		{
			camera.Roadway = r400;
		}
		else if([regionString isEqualToString:@"404"])
		{
			camera.Roadway = r404;
		}
		else if([regionString isEqualToString:@"427"])
		{
			camera.Roadway = r427;
		}
		else if([regionString isEqualToString:@"403"])
		{
			camera.Roadway = r403;
		}
		else
		{
			camera.Roadway = r410;
		}
	
		cameraElement = cameraElement->nextSibling;
	}
	
}

int main (int argc, const char * argv[]) {
	
	NSAutoreleasePool *poolOne = [NSAutoreleasePool new];
    objc_startCollectorThread();
	// Create the managed object context
    NSManagedObjectContext *context = managedObjectContext();
    //Add all lines & stations to the database
    NSMutableDictionary* mLinesDictionary = populateLinesAndStations(context);
	
    //For every line, initiate parsing
    for(NSString* lineKey in mLinesDictionary)
    {
        //Get line
        ModelLine* line = [mLinesDictionary objectForKey:lineKey];
        //Get Route Type Page
        for(ModelRouteTypePage* routePageType in line.routeTypePages)
        {
            BOOL isFurtherPage = YES;
            int pageCounter = 1;
            
            while(isFurtherPage)
            {
                //Parse each page, retrieve all route data
            
                //for(int page = 1; page <= routePageType.pages; page++)
                //{
                NSAutoreleasePool *poolTwo = [NSAutoreleasePool new];
                //Construct URL
				NSString* url = [NSString stringWithFormat:routePageType.urlFormat,pageCounter];

				if(isNew)
				{
					url = [url stringByAppendingString:@"&new=Y"];
				}
				
				isFurtherPage = parsePage(context, url,line, routePageType);
                pageCounter++;
                [poolTwo drain];
            }
        }
    }
	//
	parseSubwayStations(context);
	parseTrafficCameras(context);
	
	[poolOne drain];
	// Save the managed object context
	NSError *error = nil;    
	if (![context save:&error]) 
	{
		NSLog(@"Error while saving\n%@",
		([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
		exit(1);
	}
 
	return 0;
}



NSManagedObjectModel *managedObjectModel() {

static NSManagedObjectModel *model = nil;

if (model != nil) {
	return model;
}

NSString *path = [[[NSProcessInfo processInfo] arguments] objectAtIndex:0];
	path = [path stringByDeletingPathExtension];
	NSURL *modelURL = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"mom"]];
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return model;
}

NSManagedObjectContext *managedObjectContext() {
	
    static NSManagedObjectContext *context = nil;
    if (context != nil) {
        return context;
    }
    
    context = [[NSManagedObjectContext alloc] init];
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: managedObjectModel()];
    [context setPersistentStoreCoordinator: coordinator];
    
    NSString *STORE_TYPE = NSSQLiteStoreType;
	
	NSString *path = [[[NSProcessInfo processInfo] arguments] objectAtIndex:0];
	path = [path stringByDeletingPathExtension];
	NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"sqlite"]];
    
	#if (DELETE_EXISTING_DATASTORE==1)
	NSError *deleteDatastoreError;
	[[NSFileManager defaultManager] removeItemAtURL:url error:&deleteDatastoreError];
	#endif
	
	NSError *error;
    NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:STORE_TYPE configuration:nil URL:url options:nil error:&error];
    
    if (newStore == nil) {
        NSLog(@"Store Configuration Failure\n%@",
              ([error localizedDescription] != nil) ?
              [error localizedDescription] : @"Unknown Error");
    }
    
    return context;
}

