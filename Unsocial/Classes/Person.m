//
//  Person.m
//  BadOnlineDates
//
//  Created by santosh khare on 3/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Person.h"


@implementation Person
@synthesize userpassword, username, useremail, userid, userind, usersubind, userindid, usersubindid, userroleid, userrole, userprefix, usercompany, userlinkedin, userwebsite, usercontact, userabout, userindustry, userfunction;
@synthesize collectionindustry, collectionsubindustry, collectionrole;
@synthesize selectedSecurityLevel, displayedSecurityItems, currentloaction, videourl, setMilesForEvents, setMilesForPeople, setdataforvideo, strsetstatus, strsetkeywords, strsettags, strrecentsearchtags,userlinkedinmailid, usertitle;

- (id) init {
	if(self = [super init]) {
		userpassword = [[NSString alloc] init];
		username = [[NSString alloc] init];
		userprefix = [[NSString alloc] init];
		useremail = [[NSString alloc] init];
		userrole = [[NSString alloc] init];
		userind = [[NSString alloc] init];
		userid = [[NSString alloc] init];
		usersubind = [[NSString alloc] init];
		
		userindid = [[NSString alloc] init];
		usersubindid = [[NSString alloc] init];
		
		usercompany = [[NSString alloc] init];
		userlinkedin = [[NSString alloc] init];
		userwebsite = [[NSString alloc] init];
		usercontact = [[NSString alloc] init];
		userabout = [[NSString alloc] init];
		userindustry = [[NSString alloc] init];
		userfunction = [[NSString alloc] init];
		
		collectionindustry = [[NSString alloc] init];
		collectionsubindustry = [[NSString alloc] init];
		collectionrole = [[NSString alloc] init];
		
		selectedSecurityLevel = [[NSString alloc] init];
		currentloaction = [[NSString alloc] init];
		displayedSecurityItems = [[NSString alloc] init];
		videourl = [[NSString alloc] init];
		
		setMilesForPeople = [[NSString alloc] init];
		setMilesForEvents = [[NSString alloc] init];
		
		setdataforvideo = [[NSString alloc] init];
		
		strsetstatus = [[NSString alloc] init];
		strsetkeywords = [[NSString alloc] init];
		strsettags = [[NSString alloc] init];
		strrecentsearchtags = [[NSString alloc] init];
		userlinkedinmailid = [[NSString alloc] init];
		usertitle = [[NSString alloc] init];
	}
	return self;
}

- (void) dealloc {
	[userpassword release];
	[username release];
	[userind release];
	[usersubind release];
	[useremail release];
	[userrole release];
	[userindid release];
	[usersubindid release];
	[userroleid release];
	[userprefix release];
	[userid release];
	[usercompany release];
	[userlinkedin release];
	[userwebsite release];
	[usercontact release];
	[userindustry release];
	[userfunction release];
	[userabout release];
	[collectionindustry release];
	[collectionsubindustry release];
	[collectionrole release];
	[selectedSecurityLevel release];
	[currentloaction release];
	[displayedSecurityItems release];
	[videourl release];
	[setMilesForPeople release];
	[setMilesForEvents release];
	[setdataforvideo release];
	[strsetstatus release];
	[strsetkeywords release];
	[strsettags release];
	[strrecentsearchtags release];
	[userlinkedinmailid release];
	[usertitle release];
	[super dealloc];
}

- (id) initWithCoder:(NSCoder *)coder {
	userpassword = [[coder decodeObjectForKey:@"userpassword"] retain];
	username = [[coder decodeObjectForKey:@"username"] retain];
	userind = [[coder decodeObjectForKey:@"userind"] retain];
	usersubind = [[coder decodeObjectForKey:@"usersubind"] retain];
	userrole = [[coder decodeObjectForKey:@"userrole"] retain];

	userindid = [[coder decodeObjectForKey:@"userindid"] retain];
	usersubindid = [[coder decodeObjectForKey:@"usersubindid"] retain];
	userroleid = [[coder decodeObjectForKey:@"userroleid"] retain];

	userprefix = [[coder decodeObjectForKey:@"userprefix"] retain];
	useremail = [[coder decodeObjectForKey:@"useremail"] retain];	
	userid = [[coder decodeObjectForKey:@"userid"] retain];
	usercompany = [[coder decodeObjectForKey:@"usercompany"] retain];
	userlinkedin = [[coder decodeObjectForKey:@"userlinkedin"] retain];
	userwebsite = [[coder decodeObjectForKey:@"userwebsite"] retain];
	usercontact = [[coder decodeObjectForKey:@"usercontact"] retain];
	userabout = [[coder decodeObjectForKey:@"userabout"] retain];
	userindustry = [[coder decodeObjectForKey:@"userindustry"] retain];
	userfunction = [[coder decodeObjectForKey:@"userfunction"] retain];

	collectionindustry = [[coder decodeObjectForKey:@"collectionindustry"] retain];
	collectionsubindustry = [[coder decodeObjectForKey:@"collectionsubindustry"] retain];
	collectionrole = [[coder decodeObjectForKey:@"collectionrole"] retain];

	selectedSecurityLevel = [[coder decodeObjectForKey:@"selectedSecurityLevel"] retain];
	currentloaction = [[coder decodeObjectForKey:@"currentloaction"] retain];
	displayedSecurityItems = [[coder decodeObjectForKey:@"displayedSecurityItems"] retain];
	videourl = [[coder decodeObjectForKey:@"videourl"] retain];

	setMilesForEvents = [[coder decodeObjectForKey:@"setMilesForEvents"] retain];
	setMilesForPeople = [[coder decodeObjectForKey:@"setMilesForPeople"] retain];
	
	setdataforvideo = [[coder decodeObjectForKey:@"setdataforvideo"] retain];
	
	strsetstatus = [[coder decodeObjectForKey:@"strsetstatus"] retain];
	strsetkeywords = [[coder decodeObjectForKey:@"strsetkeywords"] retain];
	strsettags = [[coder decodeObjectForKey:@"strsettags"] retain];
	strrecentsearchtags = [[coder decodeObjectForKey:@"strrecentsearchtags"] retain];
	userlinkedinmailid = [[coder decodeObjectForKey:@"userlinkedinmailid"] retain];
	usertitle = [[coder decodeObjectForKey:@"usertitle"] retain];
	return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:userpassword forKey:@"userpassword"];
	[encoder encodeObject:username forKey:@"username"];
	[encoder encodeObject:userind forKey:@"userind"];
	[encoder encodeObject:usersubind forKey:@"usersubind"];
	[encoder encodeObject:userrole forKey:@"userrole"];
	[encoder encodeObject:useremail forKey:@"useremail"];

	[encoder encodeObject:userindid forKey:@"userindid"];
	[encoder encodeObject:usersubindid forKey:@"usersubindid"];
	[encoder encodeObject:userroleid forKey:@"userroleid"];
	
	[encoder encodeObject:userid forKey:@"userid"];
	[encoder encodeObject:userprefix forKey:@"userprefix"];
	[encoder encodeObject:usercompany forKey:@"usercompany"];
	[encoder encodeObject:userlinkedin forKey:@"userlinkedin"];
	[encoder encodeObject:userwebsite forKey:@"userwebsite"];
	[encoder encodeObject:usercontact forKey:@"usercontact"];
	[encoder encodeObject:userabout forKey:@"userabout"];
	[encoder encodeObject:userindustry forKey:@"userindustry"];
	[encoder encodeObject:userfunction forKey:@"userfunction"];
	
	[encoder encodeObject:collectionindustry forKey:@"collectionindustry"];
	[encoder encodeObject:collectionsubindustry forKey:@"collectionsubindustry"];
	[encoder encodeObject:collectionrole forKey:@"collectionrole"];

	[encoder encodeObject:currentloaction forKey:@"currentloaction"];
	[encoder encodeObject:selectedSecurityLevel forKey:@"selectedSecurityLevel"];
	[encoder encodeObject:displayedSecurityItems forKey:@"displayedSecurityItems"];
	[encoder encodeObject:videourl forKey:@"videourl"];

	[encoder encodeObject:setMilesForEvents forKey:@"setMilesForEvents"];
	[encoder encodeObject:setMilesForPeople forKey:@"setMilesForPeople"];
	
	[encoder encodeObject:setdataforvideo forKey:@"setdataforvideo"];
	
	[encoder encodeObject:strsetstatus forKey:@"strsetstatus"];
	[encoder encodeObject:strsetkeywords forKey:@"strsetkeywords"];	
	[encoder encodeObject:strsettags forKey:@"strsettags"];
	[encoder encodeObject:strrecentsearchtags forKey:@"strrecentsearchtags"];
	[encoder encodeObject:userlinkedinmailid forKey:@"userlinkedinmailid"];
	[encoder encodeObject:usertitle forKey:@"usertitle"];
}

@end
