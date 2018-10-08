#import "Variables.h"
#import "Headers.h"
#import <UIKit/UIKit.h>
#import <dlfcn.h>
#import <AppList/AppList.h>

static NCNotificationPriorityList *priorityList;
static NCNotificationChronologicalList *chronologicalList;
/*
	Utility functions
*/

CGSize appViewSize() {
	CGFloat width = 0;
	NSInteger iconSize = [prefs() integerForKey:@"ncIconSize"];
	
	switch (iconSize) {
		default:
		case 0:
			width = 40;
			break;
		case 1:
			width = 53;
			break;
		case 2:
			width = 63;
			break;
		case 3:
			width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 106 : 84;
			break;
	}

	BOOL numberStyleBelow = getBoolWithKey(@"ncNumberStyle");
	CGFloat height = (numberStyleBelow) ? width * 1.45 : width;
	return CGSizeMake(width, height);
}

UIImage* iconForIdentifier(NSString* identifier) {
	UIImage *icon = [[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier:identifier];

	if (!icon) {
		// somehow get a NCNotificationRequest for this identifier
		// then get NCNotificationContent with request.content
		// then get icon with content.icon (20 x 20 but better than nothing)

		NSLog(@"NO ICON");
	}

	return icon;

	// Apple 2FA identifier: com.apple.springboard.SBUserNotificationAlert
	// Low power mode identifier (maybe): com.apple.DuetHeuristic-BM

	// return [UIImage _applicationIconImageForBundleIdentifier:identifier format:0 scale:[UIScreen mainScreen].scale];
}

// Must be invoked on the BBServerQueue!

static void sendTestNotification(NSString *sectionID) {
	dispatch_sync(__BBServerQueue, ^{
        BBBulletin *bulletin = [[BBBulletin alloc] init];

        bulletin.title = @"Priority Hub";
        bulletin.message = @"Test notification!";
        bulletin.sectionID = sectionID;
        bulletin.bulletinID = [[NSProcessInfo processInfo] globallyUniqueString];
        bulletin.recordID = [[NSProcessInfo processInfo] globallyUniqueString];
        bulletin.publisherBulletinID = [[NSProcessInfo processInfo] globallyUniqueString];
        bulletin.date = [NSDate date];
        bulletin.defaultAction = [BBAction actionWithLaunchBundleID:sectionID callblock:nil];

        [bbServer publishBulletin:bulletin destinations:4 alwaysToLockScreen:YES];
    });
}

static void sendNotificationCallback() {
	[SharedInstance(SBLockScreenManager) lockUIFromSource:1 withOptions:0];
	sendTestNotification(@"com.apple.mobilephone");
    sendTestNotification(@"com.apple.mobilephone");
    sendTestNotification(@"com.apple.mobilephone");
    sendTestNotification(@"com.apple.mobilephone");
    sendTestNotification(@"com.apple.mobilephone");
    sendTestNotification(@"com.apple.Music");
    sendTestNotification(@"com.apple.MobileSMS");
}

static void updatePHContainerViewHidden() {
	if (SharedInstance(SBBacklightController).screenIsOn) {
		phController.phContainer.hidden = !ENABLED();
	}
}
/*
	Main hooks
*/
/*
	start group common
*/
%group common

%hook BBServer

- (id)initWithQueue:(id)arg1 {
    bbServer = %orig;

    return bbServer;
}

- (id)initWithQueue:(id)arg1 dataProviderManager:(id)arg2 syncService:(id)arg3 dismissalSyncCache:(id)arg4 observerListener:(id)arg5 utilitiesListener:(id)arg6 conduitListener:(id)arg7 systemStateListener:(id)arg8 settingsListener:(id)arg9 {
    bbServer = %orig;
    return bbServer;
}

- (void)dealloc {
	if (bbServer == self) {
		bbServer = nil;
	}
	%orig;
}
%end

%hook NCNotificationListCell
-(void)cellClearButtonPressed:(id)arg1 {
	if (phController.selected) {
		NCNotificationRequest *request = self.contentViewController.notificationRequest;

		NSString *appHubID = phController.selectedAppID;
		phController.selectedAppID = nil;
		[phController updateSelectedView];
		[phController updateHubView];

		[phController clearNotificationRequest:request origin:self];
		BOOL onlyOneLeft = [phController currentNotificationCount] == 1;
		if (!onlyOneLeft) {
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(400 * USEC_PER_SEC)), dispatch_get_main_queue(), ^{
				phController.selectedAppID = appHubID;
				[phController updateSelectedView];
				[phController updateHubView];
			});
		}
		// [chronologicalList removeNotificationRequest:request];
		// [priorityList removeNotificationRequest:request];
		// %orig;
		return;
	}
	%orig;
}
%end

%hook NCNotificationPriorityList
-(id)init {
    NSLog(@"[StackXI] Init!");
    id orig = %orig;
    priorityList = self;
    return orig;
}
-(NSMutableOrderedSet *)requests {
	if (phController.selected) { // nothing selected do the normal behavior
		return phController.orderedSet;
	}
	
	if (!getBoolWithKey(@"ncShowAllWhenNotSelected"))
		return [NSMutableOrderedSet new];
	return %orig;
}
%end

%hook NCNotificationChronologicalList
-(id)init {
    id orig = %orig;
    chronologicalList = self;
    return orig;
}
-(NSMutableArray *)sections {
	if (phController.selected) { // nothing selected do the normal behavior
		return [@[] mutableCopy];
	}
	if (!getBoolWithKey(@"ncShowAllWhenNotSelected"))
		return [@[] mutableCopy];
	return %orig;
}
%end


%hook NCNotificationListCollectionView

// add more scrollcontent since we moved everythig down
-(void)setContentInset:(UIEdgeInsets)inset {
	%orig(UIEdgeInsetsMake(inset.top, inset.left, inset.bottom + appViewSize().height, inset.right));
}

# pragma mark - crash fix
// -(void)insertItemsAtIndexPaths:(id)arg1 { 
// 	[self.collectionViewLayout invalidateLayout];
// 	[self reloadData];
// 	// %orig;
// }

%end

%hook NCNotificationCombinedListViewController

-(BOOL)_shouldShowRevealHintView {
	if (isStackXI || phController.selected) return NO;

	return %orig && getBoolWithKey(@"ncShowAllWhenNotSelected");
}

- (BOOL)insertNotificationRequest:(NCNotificationRequest *)request forCoalescedNotification:(id)arg2 {
	[phController addNotificationRequest:request];
	if (!getBoolWithKey(@"ncShowAllWhenNotSelected"))
		return NO;

	BOOL ret = %orig;
	return ret;
}

-(void)removeNotificationRequest:(NCNotificationRequest *)request forCoalescedNotification:(id)arg2 {
// 	// NSLog(@"%@ %d %@", NSStringFromSelector(_cmd), phController.selected, arg2);
	// need to remove the notification before the orig
	[phController removeNotificationRequest:request];
	%orig;
}

-(void)viewDidLoad {
	%orig;

	NSLog(@"NCNotificationCombinedListViewController %@", NSStringFromSelector(_cmd));

	// Create the PHContainerScrollView
	if (!phController) {
		phController = [PHViewController new];
		
		CGSize size = appViewSize();
		size.width = CGRectGetWidth(self.view.bounds);
		phController.phContainer.frame = (CGRect) {CGPointZero, size};
		
		[self.view addSubview:phController.phContainer];
		phController.ncdelegate = (UICollectionViewController<PHControllerDelegate> *)self;

		phController.pullToClearView = [PHPullToClearView new];
		[phController.phContainer addSubview:phController.pullToClearView];
	}
}

/* 
	hook this method so phcontainerview will be sticky
*/
-(void)scrollViewDidScroll:(UIScrollView*)scrollView {
	%orig;
	if (!ENABLED()) return;

	const float padding = 25;

	CGRect headerFrame = phController.phContainer.frame;
	
	headerFrame.origin.y = MAX(padding, -scrollView.contentOffset.y);
	// headerFrame.origin.y = MAX(padding, scrollView.contentOffset.y + 25);
    phController.phContainer.frame = headerFrame;

	// pull to clear
	if (!phController.selected) return ;

	[phController didScroll:scrollView];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)arg1 {
	%orig;

	if (!phController.selected) return ;
	[phController didBeginDragging:arg1];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)arg2 targetContentOffset:(CGPoint*)arg3 {
	%orig;
	
	if (!phController.selected) return ;
	[phController didEndDragging:scrollView];
}

/*
	update priority hub view
*/
-(void)viewWillAppear:(BOOL)arg1 {
	%orig;
	NSLog(@"%@ is enabled now: %d", NSStringFromSelector(_cmd), ENABLED());
	updatePHContainerViewHidden();
	[phController updateHubView];
	[phController updateNotifications];
	// [phController.phContainer layoutSubviews];
}

// use did disappear so unhidden will not be seen 
-(void)viewDidDisappear:(BOOL)arg1 {
	%orig;
	NSLog(@"%@ %d", NSStringFromSelector(_cmd), ENABLED());
	phController.phContainer.hidden = NO;
	
	if (getBoolWithKey(@"collapseOnLock"));

	phController.selectedAppID = nil;
	[phController updateSelectedView];
}
%end

%hook NCNotificationListCollectionViewFlowLayout
- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
	NCNotificationCombinedListViewController* controller = (NCNotificationCombinedListViewController*)self.collectionView.delegate;

	NSArray *attributes = %orig;
	
	if (!(ENABLED() || [controller isBeingPresented])) return attributes;

	CGFloat PADDING = appViewSize().height;
	BOOL hasPriorityNotifi = controller.notificationPriorityList.count > 0;
	if (hasPriorityNotifi) {
		PADDING += 15;
	}

	for (UICollectionViewLayoutAttributes* curAttributes in attributes) {
		curAttributes.frame = CGRectOffset(curAttributes.frame, 0, PADDING);
	}

	return attributes;
}
%end

/*
	end group common
*/
%end 

#define kSettingsChangedNotification (CFStringRef)@"com.kunderscore.priorityhub.prefschanged"

static NSUserDefaults *stackxipref;

static void preferencesChanged() {
	updatePHContainerViewHidden();
}

%ctor {
	//dlopen'ing tweaks causes their dylib to be loaded and their constructors to be executed first.
	//This fixes a lot of layout problems because then priority hub's layout code runs last and
	//has the last say in the layout of some views.
	// dlopen("/Library/MobileSubstrate/DynamicLibraries/SubtleLock.dylib", RTLD_NOW);
	// dlopen("/Library/MobileSubstrate/DynamicLibraries/Roomy.dylib", RTLD_NOW);
	if (!IOS_GTE(@"11.0")) return;
	
	stackxipref = [[NSUserDefaults alloc] initWithSuiteName:@"io.ominousness.stackxi"];
	isStackXI = [stackxipref boolForKey:@"Enabled"];

	NSLog(@"isStackXI %d %@", isStackXI, stackxipref);

	// getBoolWithKey(@"Enabled");
	%init(common);
	
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)sendNotificationCallback, (CFStringRef)@"showTestNotificationNotification", NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)preferencesChanged, kSettingsChangedNotification, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}