//
//  Person.h
//  BadOnlineDates
//
//  Created by santosh khare on 3/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Person : NSObject {
	NSString *username;
	NSString *useremail;
	NSString *userind;
	NSString *usersubind;
	NSString *userrole;
	NSString *userindid;
	NSString *usersubindid;
	NSString *userroleid;
	NSString *userid;
	NSString *userpassword, *userprefix, *usercompany, *userlinkedin, *userwebsite, *usercontact, *userabout, *userindustry, *userfunction;	// main userid created by web app
	NSString *collectionindustry, *collectionsubindustry, *collectionrole;
	NSString *selectedSecurityLevel, *displayedSecurityItems, *currentloaction;
	NSString *videourl;
	NSString *setMilesForPeople, *setMilesForEvents;
	NSString *setdataforvideo;
	NSString *strsetstatus;
	NSString *strsetkeywords; // user meta tags
	NSString *strsettags; // user tags
	NSString *strrecentsearchtags; // user's recent search tags added by pradeep on 13 nov 2010 for recent search improvement
	NSString *userlinkedinmailid, *usertitle;
}

@property (nonatomic, retain) NSString *strsetstatus, *strsetkeywords, *strsettags, *userlinkedinmailid, *usertitle;
@property (nonatomic, retain) NSString *strrecentsearchtags; // user's recent search tags added by pradeep on 13 nov 2010 for recent search improvement
@property (nonatomic, retain) NSString *setdataforvideo;
@property (nonatomic, retain) NSString *userpassword, *username, *useremail, *userid;
@property (nonatomic, retain) NSString *userind, *usersubind, *userrole, *userindid, *usersubindid, *userroleid, *userprefix, *usercompany, *userlinkedin, *userwebsite, *usercontact, *userabout, *userindustry, *userfunction;
@property (nonatomic, retain) NSString *collectionindustry, *collectionsubindustry, *collectionrole;
@property (nonatomic, retain) NSString *selectedSecurityLevel, *displayedSecurityItems, *currentloaction, *videourl;
@property (nonatomic, retain) NSString *setMilesForPeople, *setMilesForEvents;
@end
