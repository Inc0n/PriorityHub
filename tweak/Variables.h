
#import "Headers.h"


#define kScreenFrame UIScreen.mainScreen.bounds
// #define ENABLED(ncvc) (((SBDashBoardCombinedListViewController*)ncvc.parentViewController).deviceAuthenticated ? getBoolWithKey(@"ncEnabled") : getBoolWithKey(@"lsEnabled"))

// #define ENABLED_DASHBOARD(sbdbvc) (((SBDashBoardViewController*)sbdbvc).authenticated ? getBoolWithKey(@"ncEnabled") : getBoolWithKey(@"lsEnabled"))

static NSUserDefaults *_prefs = nil;

inline static NSUserDefaults *prefs(void) {
	if (_prefs == nil) {
		_prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.kunderscore.priorityhub"];
		static dispatch_once_t once_token;
		dispatch_once(&once_token, ^{
			[_prefs registerDefaults:@{
				@"lsEnabled": @YES,
				@"ncEnabled": @YES,
				@"ncIconSize": [NSNumber numberWithInt:1],
				@"ncNumberStyle": [NSNumber numberWithInt:1],
				@"ncEnablePullToClear": @YES,
				@"ncShowAllWhenNotSelected": [NSNumber numberWithInt:0],
				@"ncCollapseOnLock": @YES
			}];
		});
	}
    return _prefs;
}

static BOOL isStackXI = NO;
static BOOL debug = NO;

// pull to clear 
static CGFloat kThreshold = 80;
static CGFloat sBeginYOffset;

// notification
static BBServer *bbServer = nil;
static NCBulletinNotificationSource *notificationSource;

static PHViewController *phController = nil;
            
static PHPullToClearView *pullToClearView = nil;
static SBDashBoardViewController *dashBoardViewController = nil;
static CGFloat phcontainerViewInitialY;

static NCNotificationCombinedListViewController *notificationViewController = nil;

inline static BOOL ENABLED() {
	if (!phController.ncdelegate) return NO;
	return (((SBDashBoardCombinedListViewController *)phController.ncdelegate.parentViewController).deviceAuthenticated ? getBoolWithKey(@"ncEnabled") : getBoolWithKey(@"lsEnabled"));
}

extern dispatch_queue_t __BBServerQueue;