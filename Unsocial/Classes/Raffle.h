//
//  Raffle.h
//  Unsocial
//
//  Created by Pradeep on 17/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Raffle : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>{

	UIActivityIndicatorView *activityView;
	UILabel *loading;
	UIImageView *imgHeadview, *imgBack;
	NSString *userid;
	NSString *eventid, *featureid, *featuretypeid, *featuretypename, *featuredispname;
	NSMutableArray *aryraffleticketid, *aryraffledesc, *aryraffleresult;
	
}
@property(nonatomic, retain) NSString *userid, *eventid, *featureid, *featuretypeid, *featuretypename, *featuredispname;
- (void)createControls;

- (NSString *) getRaffleTicket: (NSString *) flag : (NSString *) featid;

@end
