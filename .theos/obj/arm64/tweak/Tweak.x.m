#line 1 "tweak/Tweak.x"
#import "Variables.h"
#import "Headers.h"
#import <UIKit/UIKit.h>
#import <dlfcn.h>
#import <AppList/AppList.h>


static BOOL isRemovingNotice = NO;





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
		
		
		

		NSLog(@"NO ICON");
	}

	return icon;

	
	

	
}


static NSUInteger bulletinNum = 0;
static void sendTestNotification(NSUInteger destinations);


static NSString * nextBulletinID() {
	++bulletinNum;
	return [NSString stringWithFormat:@"com.thomasfinch.priorityhub.notification-id-%@", @(bulletinNum)];
	sendTestNotification(0);
}



#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class NCNotificationChronologicalList; @class BBAction; @class BBServer; @class NCNotificationListCell; @class NCNotificationListSectionHeaderView; @class NCNotificationCombinedListViewController; @class BBBulletinRequest; @class SBLockScreenViewControllerBase; @class NCNotificationListCollectionView; @class NCNotificationPriorityList; @class NCNotificationListCollectionViewFlowLayout; 

static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$BBAction(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("BBAction"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$BBBulletinRequest(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("BBBulletinRequest"); } return _klass; }
#line 73 "tweak/Tweak.x"
static void sendTestNotification(NSUInteger destinations) {
	NSString *bulletinID = nextBulletinID();
	BBBulletinRequest *bulletin = [[_logos_static_class_lookup$BBBulletinRequest() alloc] init];
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
	bulletin.defaultAction = [_logos_static_class_lookup$BBAction() actionWithLaunchURL:url];

	if ([bbServer respondsToSelector:@selector(publishBulletinRequest:destinations:)]) {
		[bbServer publishBulletinRequest:bulletin destinations:destinations];
	}
}




static NSUInteger (*_logos_orig$StackXI$NCNotificationPriorityList$removeNotificationRequest$)(_LOGOS_SELF_TYPE_NORMAL NCNotificationPriorityList* _LOGOS_SELF_CONST, SEL, NCNotificationRequest *); static NSUInteger _logos_method$StackXI$NCNotificationPriorityList$removeNotificationRequest$(_LOGOS_SELF_TYPE_NORMAL NCNotificationPriorityList* _LOGOS_SELF_CONST, SEL, NCNotificationRequest *); 


static NSUInteger _logos_method$StackXI$NCNotificationPriorityList$removeNotificationRequest$(_LOGOS_SELF_TYPE_NORMAL NCNotificationPriorityList* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NCNotificationRequest * request) {
    NSUInteger ret = _logos_orig$StackXI$NCNotificationPriorityList$removeNotificationRequest$(self, _cmd, request);
    [phController removeNotificationRequest:request];
    return ret;
}






static BBServer* (*_logos_orig$common$BBServer$init)(_LOGOS_SELF_TYPE_INIT BBServer*, SEL) _LOGOS_RETURN_RETAINED; static BBServer* _logos_method$common$BBServer$init(_LOGOS_SELF_TYPE_INIT BBServer*, SEL) _LOGOS_RETURN_RETAINED; static void (*_logos_orig$common$NCNotificationListCell$cellClearButtonPressed$)(_LOGOS_SELF_TYPE_NORMAL NCNotificationListCell* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$common$NCNotificationListCell$cellClearButtonPressed$(_LOGOS_SELF_TYPE_NORMAL NCNotificationListCell* _LOGOS_SELF_CONST, SEL, id); static unsigned long long (*_logos_orig$common$NCNotificationPriorityList$count)(_LOGOS_SELF_TYPE_NORMAL NCNotificationPriorityList* _LOGOS_SELF_CONST, SEL); static unsigned long long _logos_method$common$NCNotificationPriorityList$count(_LOGOS_SELF_TYPE_NORMAL NCNotificationPriorityList* _LOGOS_SELF_CONST, SEL); static NSMutableOrderedSet * (*_logos_orig$common$NCNotificationPriorityList$requests)(_LOGOS_SELF_TYPE_NORMAL NCNotificationPriorityList* _LOGOS_SELF_CONST, SEL); static NSMutableOrderedSet * _logos_method$common$NCNotificationPriorityList$requests(_LOGOS_SELF_TYPE_NORMAL NCNotificationPriorityList* _LOGOS_SELF_CONST, SEL); static NSMutableArray * (*_logos_orig$common$NCNotificationChronologicalList$sections)(_LOGOS_SELF_TYPE_NORMAL NCNotificationChronologicalList* _LOGOS_SELF_CONST, SEL); static NSMutableArray * _logos_method$common$NCNotificationChronologicalList$sections(_LOGOS_SELF_TYPE_NORMAL NCNotificationChronologicalList* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$common$NCNotificationChronologicalList$clearSectionWithIdentifier$)(_LOGOS_SELF_TYPE_NORMAL NCNotificationChronologicalList* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$common$NCNotificationChronologicalList$clearSectionWithIdentifier$(_LOGOS_SELF_TYPE_NORMAL NCNotificationChronologicalList* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$common$NCNotificationListSectionHeaderView$_clearButtonAction$)(_LOGOS_SELF_TYPE_NORMAL NCNotificationListSectionHeaderView* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$common$NCNotificationListSectionHeaderView$_clearButtonAction$(_LOGOS_SELF_TYPE_NORMAL NCNotificationListSectionHeaderView* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$common$NCNotificationListCollectionView$setContentInset$)(_LOGOS_SELF_TYPE_NORMAL NCNotificationListCollectionView* _LOGOS_SELF_CONST, SEL, UIEdgeInsets); static void _logos_method$common$NCNotificationListCollectionView$setContentInset$(_LOGOS_SELF_TYPE_NORMAL NCNotificationListCollectionView* _LOGOS_SELF_CONST, SEL, UIEdgeInsets); static BOOL (*_logos_orig$common$NCNotificationCombinedListViewController$_shouldShowRevealHintView)(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST, SEL); static BOOL _logos_method$common$NCNotificationCombinedListViewController$_shouldShowRevealHintView(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST, SEL); static BOOL (*_logos_orig$common$NCNotificationCombinedListViewController$insertNotificationRequest$forCoalescedNotification$)(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST, SEL, NCNotificationRequest *, id); static BOOL _logos_method$common$NCNotificationCombinedListViewController$insertNotificationRequest$forCoalescedNotification$(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST, SEL, NCNotificationRequest *, id); static void (*_logos_orig$common$NCNotificationCombinedListViewController$removeNotificationRequest$forCoalescedNotification$)(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST, SEL, NCNotificationRequest *, id); static void _logos_method$common$NCNotificationCombinedListViewController$removeNotificationRequest$forCoalescedNotification$(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST, SEL, NCNotificationRequest *, id); static NCNotificationListCell * (*_logos_orig$common$NCNotificationCombinedListViewController$collectionView$cellForItemAtIndexPath$)(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST, SEL, id, id); static NCNotificationListCell * _logos_method$common$NCNotificationCombinedListViewController$collectionView$cellForItemAtIndexPath$(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST, SEL, id, id); static void (*_logos_orig$common$NCNotificationCombinedListViewController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$common$NCNotificationCombinedListViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$common$NCNotificationCombinedListViewController$scrollViewDidScroll$)(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST, SEL, UIScrollView*); static void _logos_method$common$NCNotificationCombinedListViewController$scrollViewDidScroll$(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST, SEL, UIScrollView*); static void (*_logos_orig$common$NCNotificationCombinedListViewController$viewWillAppear$)(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$common$NCNotificationCombinedListViewController$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void (*_logos_orig$common$NCNotificationCombinedListViewController$viewWillDisappear$)(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$common$NCNotificationCombinedListViewController$viewWillDisappear$(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST, SEL, BOOL); static NSArray* (*_logos_orig$common$NCNotificationListCollectionViewFlowLayout$layoutAttributesForElementsInRect$)(_LOGOS_SELF_TYPE_NORMAL NCNotificationListCollectionViewFlowLayout* _LOGOS_SELF_CONST, SEL, CGRect); static NSArray* _logos_method$common$NCNotificationListCollectionViewFlowLayout$layoutAttributesForElementsInRect$(_LOGOS_SELF_TYPE_NORMAL NCNotificationListCollectionViewFlowLayout* _LOGOS_SELF_CONST, SEL, CGRect); static void (*_logos_orig$common$SBLockScreenViewControllerBase$setInScreenOffMode$)(_LOGOS_SELF_TYPE_NORMAL SBLockScreenViewControllerBase* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$common$SBLockScreenViewControllerBase$setInScreenOffMode$(_LOGOS_SELF_TYPE_NORMAL SBLockScreenViewControllerBase* _LOGOS_SELF_CONST, SEL, BOOL); 


static BBServer* _logos_method$common$BBServer$init(_LOGOS_SELF_TYPE_INIT BBServer* __unused self, SEL __unused _cmd) _LOGOS_RETURN_RETAINED {
	self = _logos_orig$common$BBServer$init(self, _cmd);
	bbServer = self;
	return self;
}



static void _logos_method$common$NCNotificationListCell$cellClearButtonPressed$(_LOGOS_SELF_TYPE_NORMAL NCNotificationListCell* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {
	if (phController.selected) {
		if ([phController currentNotificationCount] == 1) {
			[phController clearAllCurrentNotifications];
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
	_logos_orig$common$NCNotificationListCell$cellClearButtonPressed$(self, _cmd, arg1);
}



static unsigned long long _logos_method$common$NCNotificationPriorityList$count(_LOGOS_SELF_TYPE_NORMAL NCNotificationPriorityList* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	if (phController.selected && !isStackXI) { 
		return 0;
	}
	return _logos_orig$common$NCNotificationPriorityList$count(self, _cmd);
}
static NSMutableOrderedSet * _logos_method$common$NCNotificationPriorityList$requests(_LOGOS_SELF_TYPE_NORMAL NCNotificationPriorityList* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	if (phController.selected && isStackXI) { 
		NSMutableOrderedSet *orderedSet = [[NSMutableOrderedSet alloc]init];
		[orderedSet addObjectsFromArray:phController.currentNotifications[phController.selectedAppID]];
		return orderedSet;
	}
	return _logos_orig$common$NCNotificationPriorityList$requests(self, _cmd);
}



static NSMutableArray * _logos_method$common$NCNotificationChronologicalList$sections(_LOGOS_SELF_TYPE_NORMAL NCNotificationChronologicalList* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	

	if (phController.section == nil) { 
		phController.section = [self _newSectionForDate:[NSDate date]];
	}
	if (phController.selected) { 
		return (NSMutableArray *)@[phController.section];
	}
	if ([prefs() boolForKey:@"ncShowAllWhenNotSelected"]) {
		return _logos_orig$common$NCNotificationChronologicalList$sections(self, _cmd);
	}
	return [@[] mutableCopy];
}

static void _logos_method$common$NCNotificationChronologicalList$clearSectionWithIdentifier$(_LOGOS_SELF_TYPE_NORMAL NCNotificationChronologicalList* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {
	if (!phController.selected) { 
		_logos_orig$common$NCNotificationChronologicalList$clearSectionWithIdentifier$(self, _cmd, arg1);
	}
	NSLog(@"%@", NSStringFromSelector(_cmd));
}



static void _logos_method$common$NCNotificationListSectionHeaderView$_clearButtonAction$(_LOGOS_SELF_TYPE_NORMAL NCNotificationListSectionHeaderView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {

	if (self.clearButton.clearButtonState == 1) {
		if (phController.selected) {
			[self.clearButton setState:0 animated:YES];
			[phController clearAllCurrentNotifications];
			return;
		}
	}
	_logos_orig$common$NCNotificationListSectionHeaderView$_clearButtonAction$(self, _cmd, arg1);
	NSLog(@"%@ %@ %lld %@", NSStringFromSelector(_cmd), arg1, self.clearButton.clearButtonState, arg1);
}






static void _logos_method$common$NCNotificationListCollectionView$setContentInset$(_LOGOS_SELF_TYPE_NORMAL NCNotificationListCollectionView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIEdgeInsets inset) {
	_logos_orig$common$NCNotificationListCollectionView$setContentInset$(self, _cmd, UIEdgeInsetsMake(inset.top, inset.left, inset.bottom + appViewSize().height + 10, inset.right));
} 





static BOOL _logos_method$common$NCNotificationCombinedListViewController$_shouldShowRevealHintView(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	
	if (self.showingNotificationsHistory) {
		[phController.hintView removeFromSuperview];
	}
	return NO;
	return _logos_orig$common$NCNotificationCombinedListViewController$_shouldShowRevealHintView(self, _cmd) && [prefs() boolForKey:@"ncShowAllWhenNotSelected"];
}

static BOOL _logos_method$common$NCNotificationCombinedListViewController$insertNotificationRequest$forCoalescedNotification$(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NCNotificationRequest * request, id arg2) {
	
	[phController addNotificationRequest:request];
	if (phController.selected || ![prefs() boolForKey:@"ncShowAllWhenNotSelected"]) {
		return NO;
	}
	return _logos_orig$common$NCNotificationCombinedListViewController$insertNotificationRequest$forCoalescedNotification$(self, _cmd, request, arg2);
}

static void _logos_method$common$NCNotificationCombinedListViewController$removeNotificationRequest$forCoalescedNotification$(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NCNotificationRequest * request, id arg2) {
	
	[phController removeNotificationRequest:request];
	_logos_orig$common$NCNotificationCombinedListViewController$removeNotificationRequest$forCoalescedNotification$(self, _cmd, request, arg2); 
}

static NCNotificationListCell * _logos_method$common$NCNotificationCombinedListViewController$collectionView$cellForItemAtIndexPath$(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, id arg2) {
	NCNotificationListCell *cell = _logos_orig$common$NCNotificationCombinedListViewController$collectionView$cellForItemAtIndexPath$(self, _cmd, arg1, arg2);
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
static void _logos_method$common$NCNotificationCombinedListViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	_logos_orig$common$NCNotificationCombinedListViewController$viewDidLoad(self, _cmd);

	
	UIView *pullToClearView =  ncPullToClearView;

	
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




static void _logos_method$common$NCNotificationCombinedListViewController$scrollViewDidScroll$(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIScrollView* scrollView) {
	_logos_orig$common$NCNotificationCombinedListViewController$scrollViewDidScroll$(self, _cmd, scrollView);
	if (!ENABLED) 
		return;

	
	CGRect headerFrame = phController.phContainer.frame;
	CGFloat offset = headerFrame.origin.y;
	if (scrollView.contentOffset.y <= offset) {
		headerFrame.origin.y = - 10;
	}
	headerFrame.origin.y = MAX(- 10, scrollView.contentOffset.y + 25);
    phController.phContainer.frame = headerFrame;


}




static void _logos_method$common$NCNotificationCombinedListViewController$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL arg1) {
	_logos_orig$common$NCNotificationCombinedListViewController$viewWillAppear$(self, _cmd, arg1);
	[phController updateHubView];
	
	
	
}
static void _logos_method$common$NCNotificationCombinedListViewController$viewWillDisappear$(_LOGOS_SELF_TYPE_NORMAL NCNotificationCombinedListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL arg1) {
	_logos_orig$common$NCNotificationCombinedListViewController$viewWillDisappear$(self, _cmd, arg1);
	phController.selectedAppID = nil;
	[phController updateSelectedView];
}










static NSArray* _logos_method$common$NCNotificationListCollectionViewFlowLayout$layoutAttributesForElementsInRect$(_LOGOS_SELF_TYPE_NORMAL NCNotificationListCollectionViewFlowLayout* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, CGRect rect) {
	NCNotificationCombinedListViewController* controller = (NCNotificationCombinedListViewController*)self.collectionView.delegate;

	if (![prefs() boolForKey:@"ncEnabled"])
		return _logos_orig$common$NCNotificationListCollectionViewFlowLayout$layoutAttributesForElementsInRect$(self, _cmd, rect);

	NSArray *attributes = _logos_orig$common$NCNotificationListCollectionViewFlowLayout$layoutAttributesForElementsInRect$(self, _cmd, rect);
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





static void _logos_method$common$SBLockScreenViewControllerBase$setInScreenOffMode$(_LOGOS_SELF_TYPE_NORMAL SBLockScreenViewControllerBase* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL locked) {
	_logos_orig$common$SBLockScreenViewControllerBase$setInScreenOffMode$(self, _cmd, locked);
	if (locked && [prefs() boolForKey:@"ncEnabled"] && [prefs() boolForKey:@"collapseOnLock"] && phController) {
		[phController updateSelectedView];
	}
}





 

#define kSettingsChangedNotification (CFStringRef)@"com.kunderscore.priorityhub.prefschanged;"

static NSUserDefaults *statckxipref;

static void preferencesChanged() {
	NSLog(@"priorityhub update prefs");
}

static __attribute__((constructor)) void _logosLocalCtor_b88ac9a2(int __unused argc, char __unused **argv, char __unused **envp) {
	
	
	
	
	
	if (!IOS_GTE(@"11.0")) return;
	
	statckxipref = [[NSUserDefaults alloc] initWithSuiteName:@"io.ominousness.stackxi"];
	isStackXI = [statckxipref boolForKey:@"Enabled"];
	if (isStackXI) {
		{Class _logos_class$StackXI$NCNotificationPriorityList = objc_getClass("NCNotificationPriorityList"); MSHookMessageEx(_logos_class$StackXI$NCNotificationPriorityList, @selector(removeNotificationRequest:), (IMP)&_logos_method$StackXI$NCNotificationPriorityList$removeNotificationRequest$, (IMP*)&_logos_orig$StackXI$NCNotificationPriorityList$removeNotificationRequest$);}
	}
	NSLog(@"isStackXI %d %@", isStackXI, statckxipref);

	{Class _logos_class$common$BBServer = objc_getClass("BBServer"); MSHookMessageEx(_logos_class$common$BBServer, @selector(init), (IMP)&_logos_method$common$BBServer$init, (IMP*)&_logos_orig$common$BBServer$init);Class _logos_class$common$NCNotificationListCell = objc_getClass("NCNotificationListCell"); MSHookMessageEx(_logos_class$common$NCNotificationListCell, @selector(cellClearButtonPressed:), (IMP)&_logos_method$common$NCNotificationListCell$cellClearButtonPressed$, (IMP*)&_logos_orig$common$NCNotificationListCell$cellClearButtonPressed$);Class _logos_class$common$NCNotificationPriorityList = objc_getClass("NCNotificationPriorityList"); MSHookMessageEx(_logos_class$common$NCNotificationPriorityList, @selector(count), (IMP)&_logos_method$common$NCNotificationPriorityList$count, (IMP*)&_logos_orig$common$NCNotificationPriorityList$count);MSHookMessageEx(_logos_class$common$NCNotificationPriorityList, @selector(requests), (IMP)&_logos_method$common$NCNotificationPriorityList$requests, (IMP*)&_logos_orig$common$NCNotificationPriorityList$requests);Class _logos_class$common$NCNotificationChronologicalList = objc_getClass("NCNotificationChronologicalList"); MSHookMessageEx(_logos_class$common$NCNotificationChronologicalList, @selector(sections), (IMP)&_logos_method$common$NCNotificationChronologicalList$sections, (IMP*)&_logos_orig$common$NCNotificationChronologicalList$sections);MSHookMessageEx(_logos_class$common$NCNotificationChronologicalList, @selector(clearSectionWithIdentifier:), (IMP)&_logos_method$common$NCNotificationChronologicalList$clearSectionWithIdentifier$, (IMP*)&_logos_orig$common$NCNotificationChronologicalList$clearSectionWithIdentifier$);Class _logos_class$common$NCNotificationListSectionHeaderView = objc_getClass("NCNotificationListSectionHeaderView"); MSHookMessageEx(_logos_class$common$NCNotificationListSectionHeaderView, @selector(_clearButtonAction:), (IMP)&_logos_method$common$NCNotificationListSectionHeaderView$_clearButtonAction$, (IMP*)&_logos_orig$common$NCNotificationListSectionHeaderView$_clearButtonAction$);Class _logos_class$common$NCNotificationListCollectionView = objc_getClass("NCNotificationListCollectionView"); MSHookMessageEx(_logos_class$common$NCNotificationListCollectionView, @selector(setContentInset:), (IMP)&_logos_method$common$NCNotificationListCollectionView$setContentInset$, (IMP*)&_logos_orig$common$NCNotificationListCollectionView$setContentInset$);Class _logos_class$common$NCNotificationCombinedListViewController = objc_getClass("NCNotificationCombinedListViewController"); MSHookMessageEx(_logos_class$common$NCNotificationCombinedListViewController, @selector(_shouldShowRevealHintView), (IMP)&_logos_method$common$NCNotificationCombinedListViewController$_shouldShowRevealHintView, (IMP*)&_logos_orig$common$NCNotificationCombinedListViewController$_shouldShowRevealHintView);MSHookMessageEx(_logos_class$common$NCNotificationCombinedListViewController, @selector(insertNotificationRequest:forCoalescedNotification:), (IMP)&_logos_method$common$NCNotificationCombinedListViewController$insertNotificationRequest$forCoalescedNotification$, (IMP*)&_logos_orig$common$NCNotificationCombinedListViewController$insertNotificationRequest$forCoalescedNotification$);MSHookMessageEx(_logos_class$common$NCNotificationCombinedListViewController, @selector(removeNotificationRequest:forCoalescedNotification:), (IMP)&_logos_method$common$NCNotificationCombinedListViewController$removeNotificationRequest$forCoalescedNotification$, (IMP*)&_logos_orig$common$NCNotificationCombinedListViewController$removeNotificationRequest$forCoalescedNotification$);MSHookMessageEx(_logos_class$common$NCNotificationCombinedListViewController, @selector(collectionView:cellForItemAtIndexPath:), (IMP)&_logos_method$common$NCNotificationCombinedListViewController$collectionView$cellForItemAtIndexPath$, (IMP*)&_logos_orig$common$NCNotificationCombinedListViewController$collectionView$cellForItemAtIndexPath$);MSHookMessageEx(_logos_class$common$NCNotificationCombinedListViewController, @selector(viewDidLoad), (IMP)&_logos_method$common$NCNotificationCombinedListViewController$viewDidLoad, (IMP*)&_logos_orig$common$NCNotificationCombinedListViewController$viewDidLoad);MSHookMessageEx(_logos_class$common$NCNotificationCombinedListViewController, @selector(scrollViewDidScroll:), (IMP)&_logos_method$common$NCNotificationCombinedListViewController$scrollViewDidScroll$, (IMP*)&_logos_orig$common$NCNotificationCombinedListViewController$scrollViewDidScroll$);MSHookMessageEx(_logos_class$common$NCNotificationCombinedListViewController, @selector(viewWillAppear:), (IMP)&_logos_method$common$NCNotificationCombinedListViewController$viewWillAppear$, (IMP*)&_logos_orig$common$NCNotificationCombinedListViewController$viewWillAppear$);MSHookMessageEx(_logos_class$common$NCNotificationCombinedListViewController, @selector(viewWillDisappear:), (IMP)&_logos_method$common$NCNotificationCombinedListViewController$viewWillDisappear$, (IMP*)&_logos_orig$common$NCNotificationCombinedListViewController$viewWillDisappear$);Class _logos_class$common$NCNotificationListCollectionViewFlowLayout = objc_getClass("NCNotificationListCollectionViewFlowLayout"); MSHookMessageEx(_logos_class$common$NCNotificationListCollectionViewFlowLayout, @selector(layoutAttributesForElementsInRect:), (IMP)&_logos_method$common$NCNotificationListCollectionViewFlowLayout$layoutAttributesForElementsInRect$, (IMP*)&_logos_orig$common$NCNotificationListCollectionViewFlowLayout$layoutAttributesForElementsInRect$);Class _logos_class$common$SBLockScreenViewControllerBase = objc_getClass("SBLockScreenViewControllerBase"); MSHookMessageEx(_logos_class$common$SBLockScreenViewControllerBase, @selector(setInScreenOffMode:), (IMP)&_logos_method$common$SBLockScreenViewControllerBase$setInScreenOffMode$, (IMP*)&_logos_orig$common$SBLockScreenViewControllerBase$setInScreenOffMode$);}
	
	
}
