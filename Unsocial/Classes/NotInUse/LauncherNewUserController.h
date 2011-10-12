#import <Three20/Three20.h>
#import "Settings.h"
 
@interface LauncherNewUserController : TTViewController <TTLauncherViewDelegate> {
  TTLauncherView* _launcherView;
	Settings *settings;
	NSMutableArray * springBoardTabsAry;
	UIImageView *imgBackgrnd;
}
@property (nonatomic, retain) Settings *settings;
- (void) getTabs;
@end
