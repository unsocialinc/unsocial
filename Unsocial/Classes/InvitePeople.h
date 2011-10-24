//
//  InvitePeople.h
//  Unsocial
//
//  Created by vaibhavsaran on 24/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteUser.h"
#import "LinkedInNetworkUpdate.h"

@interface InvitePeople : UIViewController {

	IBOutlet UIImageView *imgBack, *imgTipsBack;
	IBOutlet UIButton *btnEmail;
	IBOutlet UIButton *btnLinkedIn;
	IBOutlet UITextView *txtInvite, *tipsInvite;
	IBOutlet UILabel *lblHeading, *lblInvite, *lblText;
	InviteUser *inviteuser;
	UIImageView *imgHeadview;
}

@end
