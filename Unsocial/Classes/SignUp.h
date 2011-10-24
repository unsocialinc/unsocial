
#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

#import <Three20UICommon/UIViewControllerAdditions.h>
#import <Three20UI/UIViewAdditions.h>

@interface SignUp : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
	UITableView		*itemTableView;
	UITextField		*FillLoginId;
	UITextField		*FillPassword;
	UITextField		*FillPassword2;
	UITextField		*FillPrefix;
	UITextField		*FillPersonName;
	UITextField		*FillContact;
	NSString *deviceString;
	NSString *userid; 
	BOOL cameraUse, iscemera, savingProfile, whereClicked;
	UIImagePickerController *imgPicker;
	UIAlertView *alertOnChoose;
	UIImageView *imgHeadview, *imgBack, *imageGrabed;
	NSArray			*dataSourceArray;
	UIActivityIndicatorView *activityView;
	UILabel *loading, *FillBlank, *lblControl, *heading;
	UIImageView *FillPhoto;
	UIButton *btnAdd;
	UIButton *btnLinkedIn;
	UILabel *lblLinkedIn;
}
- (void) moveToUpDownAnimation:(NSInteger) upOrDown:(NSInteger) yAxis;
- (void)defaultControls;
- (void)resignAll;
- (void)storeToMutableArray;
-(void) captureImage;
- (void)dialogSelection;
- (void) switchTouched;
- (IBAction)recordNow;
- (void)createControls;
- (void) updateDataFileOnSave:(NSString *)uid;
- (void) updateDataFileOnSave4Img:(NSString *)uid;
- (BOOL) sendReqForSignUp: (NSString *) flag;
@property (nonatomic, retain, readonly) UILabel *FillBlank;
@property (nonatomic, retain, readonly) UIImageView *FillPhoto;
@property (nonatomic, retain, readonly) UITextField	*FillLoginId;
@property (nonatomic, retain, readonly) UITextField	*FillPassword;
@property (nonatomic, retain, readonly) UITextField	*FillPassword2;
@property (nonatomic, retain, readonly) UITextField	*FillPrefix;
@property (nonatomic, retain, readonly) UITextField	*FillPersonName;
@property (nonatomic, retain, readonly) UITextField	*FillContact;
@property (nonatomic, retain) NSArray *dataSourceArray;

@end
