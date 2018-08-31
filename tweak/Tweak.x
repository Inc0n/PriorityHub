#import "Variables.h"
#import "Headers.h"
#import <UIKit/UIKit.h>
#import <dlfcn.h>
#import <AppList/AppList.h>
// #import "substrate.h"

static BOOL isRemovingNotice = NO;

/*
	Utility functions
*/

CGSize appViewSize() {
	if (![prefs() boolForKey:@"ncEnabled"])
		return CGSizeZero;

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

	BOOL numberStyleBelow = [prefs() boolForKey:@"ncNumberStyle"];
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


static NSUInteger bulletinNum = 0;
static void sendTestNotification(NSUInteger destinations);

// Must be invoked on the BBServerQueue!
static NSString * nextBulletinID() {
	++bulletinNum;
	return [NSString stringWithFormat:@"com.thomasfinch.priorityhub.notification-id-%@", @(bulletinNum)];
	sendTestNotification(0);
}


static void sendTestNotification(NSUInteger destinations) {
	NSString *bulletinID = nextBulletinID();
	BBBulletinRequest *bulletin = [[%c(BBBulletinRequest) alloc] init];
	bulletin.title = @"Priority Hub";
	bulletin.subtitle = @"This is a test notification!";
	bulletin.sectionID = @"com.apple.springboard";
	bulletin.recordID = bulletinID;
	bulletin.publisherBulletinID = bulletinID;
	bulletin.clearable = YES;
	bulletin.showsMessagePreview = YES;
	NSDate *date = [NSDate date];
	bulletin.date = date;
	bulletin.publicationDate = date;
	bulletin.lastInterruptDate = date;

	NSURL *url= [NSURL URLWithString:@"prefs:root=PriorityHub"];
	bulletin.defaultAction = [%c(BBAction) actionWithLaunchURL:url];

	if ([bbServer respondsToSelector:@selector(publishBulletinRequest:destinations:)]) {
		[bbServer publishBulletinRequest:bulletin destinations:destinations];
	}
}

/*
	Main hooks
*/
%group StackXI

%hook NCNotificationPriorityList
-(NSUInteger)removeNotificationRequest:(NCNotificationRequest *)request {
    NSUInteger ret = %orig;
    [phController removeNotificationRequest:request];
    return ret;
}
%end

%end
/*
	start group common
*/
%group common

%hook BBServer
-(id)init {
	self = %orig;
	bbServer = self;
	return self;
}
%end

%hook NCNotificationPriorityList
-(unsigned long long)count {
	if (phController.selected && !isStackXI) { // nothing selected do the normal behavior
		return 0;
	}
	return %orig;
}
-(NSMutableOrderedSet *)requests {
	if (phController.selected && isStackXI) { // nothing selected do the normal behavior
		NSMutableOrderedSet *orderedSet = [[NSMutableOrderedSet alloc]init];
		[orderedSet addObjectsFromArray:phController.currentNotifications[phController.selectedAppID]];
		return orderedSet;
	}
	return %orig;
}
%end

%hook NCNotificationChronologicalList
-(NSMutableArray *)sections {
	// NSMutableArray *_sections = %orig;

	if (phController.section == nil) { // initialize section once
		phController.section = [self _newSectionForDate:[NSDate date]];
	}
	if (phController.selected) { // nothing selected do the normal behavior
		return (NSMutableArray *)@[phController.section];
	}
	if ([prefs() boolForKey:@"ncShowAllWhenNotSelected"]) {
		return %orig;
	}
	return [@[] mutableCopy];
}

-(void)clearSectionWithIdentifier:(id)arg1 {
	if (!phController.selected) { // nothing selected do the normal behavior
		%orig;
	}
	NSLog(@"%@", NSStringFromSelector(_cmd));
}
%end

%hook NCNotificationListSectionHeaderView
-(void)_clearButtonAction:(id)arg1 {

	if (self.clearButton.clearButtonState == 1) {
		if (phController.selected) {
			[self.clearButton setState:0 animated:YES];
			[phController clearAllCurrentNotifications];
			return;
		}
	}
	%orig;
	NSLog(@"%@ %@ %lld %@", NSStringFromSelector(_cmd), arg1, self.clearButton.clearButtonState, arg1);
}
%end


%hook NCNotificationListCollectionView

// add more scroolcontent since we moved everythig down
-(void)setContentInset:(UIEdgeInsets)inset {
	%orig(UIEdgeInsetsMake(inset.top, inset.left, inset.bottom + appViewSize().height + 10, inset.right));
} 

%end

%hook NCNotificationCombinedListViewController

-(BOOL)_shouldShowRevealHintView {
	// NSLog(@"%@ %d %d", NSStringFromSelector(_cmd), self.showingNotificationsHistory, [prefs boolForKey:@"ncShowAllWhenNotSelected"]);
	if (self.showingNotificationsHistory) {
		[phController.hintView removeFromSuperview];
	}
	return NO;
	return %orig && [prefs() boolForKey:@"ncShowAllWhenNotSelected"];
}

-(NCNotificationListCell *)collectionView:(id)arg1 cellForItemAtIndexPath:(id)arg2 {
	NCNotificationListCell *cell = %orig;
	if (![prefs() boolForKey:@"timeOnlyEnabled"])
		return cell;
		
	UIView *obj;
	UIView *target = cell;

	for (int i = 0; i < 4; i ++) {
		if (target.subviews.count > 0) 
			obj = target.subviews[0];
		else 
			break;
		if (IsClass(obj, NCNotificationShortLookView)) {
			break;
		} else {
			target = obj;
			obj = nil;
		}
	}
	if (!obj) {
		return cell;
	}
	NCNotificationShortLookView *slView = (NCNotificationShortLookView *)obj;
	MTPlatterHeaderContentView *headerContentView = IvarOf(slView, _headerContentView);

	if (phController.selected) {
		
		headerContentView.iconButton.hidden = YES;
		headerContentView.dateLabel.hidden = YES;
		
		NSString *time = headerContentView.dateLabel.text;
		headerContentView.title = time;

		NSMutableAttributedString *text = [headerContentView.titleLabel.attributedText mutableCopy];
		[text removeAttribute:NSParagraphStyleAttributeName range:(NSRange){0, [time length]}];
		headerContentView.titleLabel.attributedText = text;

		NSLog(@"%@ %@ %@", NSStringFromSelector(_cmd), slView, nil);
	} else {
		headerContentView.iconButton.hidden = NO;
		headerContentView.dateLabel.hidden = NO;
	}
	return cell;
}
-(void)viewDidLoad {
	%orig;

	// PHContainerView *ncPhContainerView = ncPhContainerView;
	UIView *pullToClearView =  ncPullToClearView;

	// Create the PHContainerView
	if (!phController) {
		phController = [PHViewController new];
		
		CGSize size = appViewSize();
		size.width = CGRectGetWidth(self.view.bounds);
		phController.phContainer.frame = (CGRect) {CGPointZero, size};
		
		[self.collectionView addSubview:phController.phContainer];

		NSBundle *sb = [NSBundle bundleWithIdentifier:@"com.apple.springboard"];
		UIImage *myImage = [UIImage imageNamed:@"grabber-chevron" inBundle:sb compatibleWithTraitCollection:nil];
		phController.hintView = [UIView.alloc initWithFrame: (CGRect) {{0, size.height}, size}];	
	}

	phController.ncdelegate = (id<PHControllerDelegate>)self;

	if (!pullToClearView) {
		pullToClearView = [PHPullToClearView new];
		[self.collectionView addSubview:pullToClearView];
	}
	
	notificationViewController = self;

	CGSize size = self.collectionView.contentSize;
	size.height += 30;
	self.collectionView.contentSize = size;
}

/* 
	hook this method so phcontainerview will be sticky
*/
-(void)scrollViewDidScroll:(UIScrollView*)scrollView {
	%orig;
	if (!ENABLED) 
		return;

	// CGFloat height = appViewSize(IN_LS).height;
	CGRect headerFrame = phController.phContainer.frame;
	CGFloat offset = headerFrame.origin.y;
	if (scrollView.contentOffset.y <= offset) {
		headerFrame.origin.y = - 10;
	}
	headerFrame.origin.y = MAX(- 10, scrollView.contentOffset.y + 25);
    phController.phContainer.frame = headerFrame;

// 	// TODO: pull to clear
}

/*
	update priority hub view
*/
-(void)viewWillAppear:(BOOL)arg1 {
	%orig;
	[phController updateHubView];
	// [phController.phContainer layoutSubviews];
	// [phController loadNotifications];
	// [phController updateNoticesIfNeed];
}
-(void)viewWillDisappear:(BOOL)arg1 {
	%orig;
	phController.selectedAppID = nil;
	[phController updateSelectedView];
}
%end

// %hook SBDashBoardViewController
// - (void)viewDidLoad {
// 	%orig;
// 	dashBoardViewController = self;
// }
// %end

%hook NCNotificationListCollectionViewFlowLayout
- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
	NCNotificationCombinedListViewController* controller = (NCNotificationCombinedListViewController*)self.collectionView.delegate;

	if (![prefs() boolForKey:@"ncEnabled"])
		return %orig;

	NSArray *attributes = %orig;
	CGFloat PADDING = appViewSize().height;
	BOOL hasPriorityNotifi = controller.notificationPriorityList.count > 0;
	if (hasPriorityNotifi) {
		PADDING += 15;
	}

	for (UICollectionViewLayoutAttributes* curAttributes in attributes) {
		curAttributes.frame = CGRectOffset(curAttributes.frame, 0, PADDING);
	}

	if (debug)
		NSLog(@"ATTRIBUTES: %@", attributes);

	return attributes;
}
%end

// For the deselect on lock feature on lock screen
%hook SBLockScreenViewControllerBase

- (void)setInScreenOffMode:(BOOL)locked {
	%orig;
	if (locked && [prefs() boolForKey:@"ncEnabled"] && [prefs() boolForKey:@"collapseOnLock"] && phController) {
		[phController updateSelectedView];
	}
}

%end
/*
	end group common
*/
%end 

%group iOS11

%hook NCNotificationCombinedListViewController

- (BOOL)insertNotificationRequest:(NCNotificationRequest *)request forCoalescedNotification:(id)arg2 {
	// BOOL ret = %orig;
	[phController addNotification:request];
	if (phController.selected || ![prefs() boolForKey:@"ncShowAllWhenNotSelected"]) {
		return NO;
	}

	return %orig;
}

-(void)removeNotificationRequest:(NCNotificationRequest *)request forCoalescedNotification:(id)arg2 {
	// NSLog(@"%@ %d %@", NSStringFromSelector(_cmd), phController.selected, arg2);
	[phController removeNotificationRequest:request];
	%orig; 
}
%end

%hook NCNotificationListCell
-(void)cellClearButtonPressed:(id)arg1 {
	if (phController.selected) {
		if ([phController currentNotificationCount] == 1) {
			[phController clearAllCurrentNotificationsWith];
			return;
		} else {
			NCNotificationListCollectionView *collectionView = (NCNotificationListCollectionView *)self.superview;
			
			NCNotificationCombinedListViewController *vc = (NCNotificationCombinedListViewController *)collectionView.listDelegate;
			NCNotificationRequest *request = [vc notificationRequestAtIndexPath:[collectionView indexPathForCell:self]];
			[phController clearNotificationRequest:request];
			[phController removeNotificationRequest:request];
			return;
		}
	}
	%orig;
}
%end
%end


#define kSettingsChangedNotification (CFStringRef)@"com.kunderscore.priorityhub.prefschanged;"

static NSUserDefaults *statckxipref;

static void preferencesChanged() {
	NSLog(@"priorityhub update prefs");
}

%ctor {
	//dlopen'ing tweaks causes their dylib to be loaded and their constructors to be executed first.
	//This fixes a lot of layout problems because then priority hub's layout code runs last and
	//has the last say in the layout of some views.
	// dlopen("/Library/MobileSubstrate/DynamicLibraries/SubtleLock.dylib", RTLD_NOW);
	// dlopen("/Library/MobileSubstrate/DynamicLibraries/Roomy.dylib", RTLD_NOW);
	
	statckxipref = [[NSUserDefaults alloc] initWithSuiteName:@"io.ominousness.stackxi"];
	isStackXI = [statckxipref boolForKey:@"Enabled"];
	if (isStackXI) {
		%init(StackXI);
	}
	NSLog(@"isStackXI %d %@", isStackXI, statckxipref);

	%init(common);
	
	if (IOS_GTE(@"11.0")) {
		%init(iOS11);
	}
	// CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)preferencesChanged, kSettingsChangedNotification, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}