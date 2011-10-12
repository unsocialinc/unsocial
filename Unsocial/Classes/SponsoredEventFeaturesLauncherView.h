#import <Three20/Three20.h>
#import "asyncimageview.h"


@interface SponsoredEventFeaturesLauncherView : TTViewController <TTLauncherViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, NSXMLParserDelegate> {
  TTLauncherView* _launcherView;
	
	
	UISearchBar	*mySearchBar;
	
	UIScrollView*   _scrollView;
	
	NSMutableArray * springBoardTabsAry;
	
	UIButton *imgBack, *imgBack2;
	UIActivityIndicatorView *activityView;
	UILabel *loading;
	
	NSArray *options;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	//NSArray * sortedArray;
	
	// a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
	
	NSString * currentElement, *userid;
	NSMutableString *featureid, *eventidoffeat, *featuretypeid, *featuretypename, *featuredispname, *featiconid;// , *strDescription, *strFromName, *strDateTime, *strMsgId, *strReadMsg;
	NSMutableString *currentImageURL, *currentImageURL2;
	
	NSString *eventid, *eventname;
	UIImageView *imgBackgrnd;
	
	// added by pradeep on 23 sep 2010 for add banner
	UIPageControl *pageControl;
	
	UIScrollView *scrollView;
	int kNumberOfPages;
	
	NSMutableArray *imageURLs4Lazy;
	AsyncImageView* asyncImage;
	
	UIImageView *imgBannerView;
	BOOL pageControlUsed;
	
		//Added By Ashutosh Srivastava
	NSMutableString *BannerURL;
	NSMutableArray *EVBanner;
	NSMutableDictionary * item2;
}

@property (nonatomic, retain) NSString *eventid, *eventname;

+ (BOOL) isFileExist: (NSString *) filename;
- (void) clickBanner:(NSString *)url;
- (void) getSponsoredEventFeatures;
- (void) parseXMLFileAtURL:(NSString *)URL;
- (NSString *) getURL4SingleWebsite: (NSString *) flag : (NSString *) featid;
- (void) imgBanner;
- (void)loadScrollViewWithPage:(int)page;
- (void)changePage:(id)sender;
- (void) loadScrollViewFirstTimeWithOutScrollCreatedByPradeep;
@end
