//
//  SecuritySettingsLevel1.h
//  Unsocial
//
//  Created by vaibhavsaran on 22/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecuritySettings.h"
#import <Three20/Three20.h>

@interface SecuritySettingsLevel1 : UIViewController {

	UIView *contentView;
	UILabel *loading;
	UILabel *personEmail, *personIndustry, *personCompany, *personContact;
	SecuritySettings *objSecuritySettings;
	UIActivityIndicatorView *activityView;
	UISwitch *switchPrivacyLevel, *switchCtl1, *switchCtl2, *switchCtl3, *switchCtl4;
	NSString *strdispMail, *strdispIndus, *strdispComp, *strdispCont;
	NSString *varSelectedLevel, *varSecurityItems, *varUserid, *userid, *userprefix;
	UIImageView *imgBack;
	UIButton *btnSave;
	UIButton *btnpersonEmail, *btnpersonIndustry, *btnpersonCompany, *btnpersonContact, *btnCngPwd;
	TTStyledTextLabel *lblTTWebsite;
}
//- (void) chngPwdMoveDown:(id)sender;
- (BOOL) getPrefixFromFile;
- (void) createControls;
- (BOOL) getDataFromFile;
- (void) updateDataFileOnSave:(NSString *)uid:(NSString *)level:(NSString *)securityItems;
- (BOOL)sendSecurityLevel:(NSString *)selsecurity:(NSString *)selectedLevel;
@property(retain, nonatomic) NSString *varSelectedLevel, *varSecurityItems, *varUserid, *userid, *selectedLevels;
@property(retain, nonatomic)NSString *strdispMail, *strdispIndus, *strdispComp, *strdispCont;
@end
