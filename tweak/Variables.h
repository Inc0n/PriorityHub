
#import "Headers.h"


#define kScreenFrame UIScreen.mainScreen.bounds

static NSUserDefaults *_prefs = nil;

inline static NSUserDefaults *prefs(void) {
	if (_prefs == nil) {
		_prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.kunderscore.priorityhub"];
		static dispatch_once_t once_token;
		dispatch_once(&once_token, ^{
			[_prefs registerDefaults:@{
				@"ncEnabled": @YES,
				@"timeOnlyEnabled": @YES,
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

#define ENABLED [prefs() boolForKey:@"ncEnabled"]

static BOOL isStackXI = NO;
static BOOL debug = NO;

static BBServer *bbServer = nil;
static NCBulletinNotificationSource *notificationSource;

static PHViewController *phController = nil;
static UIView *ncPullToClearView = nil;
static SBDashBoardViewController *dashBoardViewController = nil;
static CGFloat phcontainerViewInitialY;

static NCNotificationCombinedListViewController *notificationViewController = nil;
