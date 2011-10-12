//
//  PeopleSendMessage.h
//  Unsocial
//
//  Created by vaibhavsaran on 23/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PeopleSendMessage : UIViewController <UITextViewDelegate, UITextFieldDelegate>{

	UIActivityIndicatorView *activityView;
	UILabel *loading;
	UIButton *btnDone;
	UIImageView *mainBackImage;
	UITextView *textViewSendMsg;
	NSString *userid;
	NSInteger sendReply;
}
@property (assign, nonatomic) NSInteger sendReply;
@property(nonatomic, retain) NSString *userid;
- (BOOL) sendMessage;
- (void)createControls;
@end
