
#import "Headers.h"

#define ENABLED [prefs boolForKey:@"ncEnabled"]

#define kScreenFrame UIScreen.mainScreen.bounds

static NSUserDefaults *prefs = nil;

static BBServer *bbServer = nil;
static NCBulletinNotificationSource *notificationSource;

static PHViewController *phController = nil;
static UIView *ncPullToClearView = nil;
static SBDashBoardViewController *dashBoardViewController = nil;
static CGFloat phcontainerViewInitialY;

static NCNotificationCombinedListViewController *notificationViewController = nil;