
#import "PHViewController.h"
#import "Variables.h"

@interface PHViewController () {
	// PHContainerView *phContainer
}
@end

@implementation PHViewController {
	NSMutableDictionary <NSString *, NSMutableArray *> *_currentNotifications;
	NSMutableArray *_appIDs;
	NSUserDefaults *defaults;
}

- (PHViewController *)init {
	self = [super init];
	if (self) {
		self.phContainer = [[PHContainerView alloc] init];
		self.phContainer.controller = self;
		
		self.appHubs = [NSMutableDictionary new];
		_currentNotifications = [NSMutableDictionary new];
		_appIDs = [NSMutableArray array];
		
		defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.kunderscore.priorityhub"];
	}
	return self;
}

- (void)sortNotificationsIn:(NSString *)hubID { 
	NSArray *sortedArray = (NSArray *)_currentNotifications[hubID];
	
	if (sortedArray.count < 2) return ;

	sortedArray = [sortedArray sortedArrayUsingComparator:^NSComparisonResult(NCNotificationRequest *a, NCNotificationRequest *b) {
		NSDate *first = [a timestamp];
		NSDate *second = [b timestamp];
		return -1 * [first compare:second];
	}];
	// [_currentNotifications[hubID] removeAllObjects];
	// [_currentNotifications[hubID] addObjectsFromArray:sortedArray];
	_currentNotifications[hubID] = [sortedArray mutableCopy];
}

- (void)addNotificationRequest:(NCNotificationRequest *)request {
	NSString *identifier = [request sectionIdentifier];
	
	NSMutableArray *requests;
	NSLog(@"%@ %@", NSStringFromSelector(_cmd), identifier);
	
	if (_currentNotifications[identifier]) {
		if ([self containsNotification:request withAppId:identifier])
			return;

		requests = [NSMutableArray arrayWithArray:_currentNotifications[identifier]];
		[requests insertObject:request atIndex:0];
		_currentNotifications[identifier] = requests;
		
		[_appIDs removeObject:identifier];
		[_appIDs insertObject:identifier atIndex:0];

		[self updateNotificationCount:identifier];

	} else {
		requests = [NSMutableArray arrayWithObject:request];
		[_currentNotifications setObject:requests forKey:identifier];

		[self createAndAddNewAppHub:identifier];
	}
	// if ()
	// _selectedAppID = identifier;
	// if (self.selected) {
	// 	[self updateSelectedView];
	// }
}
- (NSInteger)totalNotificationRequests {
	NSInteger total = 0;
	for (NSString *appID in _currentNotifications) {
		total += _currentNotifications[appID].count;
	}
	return total;
}

- (void)updateNotificationCount:(NSString *)identifier {

	PHAppView *appHub = _appHubs[identifier];
	if (appHub) {
		NSInteger count = _currentNotifications[identifier].count;
		if (count == 0) {
			if ([identifier isEqualToString:self.selectedAppID]) _selectedAppID = nil;
			
			[_appHubs removeObjectForKey:identifier];
			[appHub removeFromSuperview];
			[self updateSelectedView];
		} else {
			[appHub setNumNotifications:count];
		}
	}
}

- (NSInteger)currentNotificationCount {
	return _currentNotifications[_selectedAppID].count;
}
- (BOOL)containsNotification:(NCNotificationRequest *)request withAppId:(NSString *)identifier {
	return [_currentNotifications[identifier] containsObject:request];
}

- (BOOL)shouldRemoveNotifcation:(NCNotificationRequest *)request {
	NSString *identifier = [request sectionIdentifier];
	return _currentNotifications[identifier] && 
		   [self containsNotification:request withAppId:identifier];
}

- (void)removeNotificationRequest:(NCNotificationRequest *)request {
	if ([self shouldRemoveNotifcation:request]){
		NSString *identifier = [request sectionIdentifier];
		[_currentNotifications[identifier] removeObject:request];
		[self updateNotificationCount:identifier];
	}
}

- (void)clearAllCurrentNotifications {
	NSString *hubID = self.selectedAppID;
	_selectedAppID = nil;
	[self updateSelectedView];
	[self updateHubView];

	for (NCNotificationRequest *request in _currentNotifications[hubID]) {
		[self clearNotificationRequest:request];
	}
}

- (void)clearNotificationRequest:(NCNotificationRequest *)request {
	[request.clearAction.actionRunner executeAction:request.clearAction fromOrigin:nil withParameters:[NSArray new] completion:nil];
}
// - (UIImage *)getImageForNotfication:(NCNotificationRequest *)request {
// 	NSIndexPath *indePath = [_ncdelegate indexPathForNotificationRequest:request];
// 	NCNotificationListCell *cell = [_ncdelegate collectionView:_ncdelegate.collectionView cellForItemAtIndexPath:indexPath];
// 	NCNotificationShortLookView *shortlookview = IvarOf(cell.contentViewController.view, _contentView);

- (void)createAndAddNewAppHub:(NSString *)appID {
	// [_appIDs insertObject:appID atIndex:0];
	[_appIDs addObject:appID];

	PHAppView *appHub = [PHAppView.alloc initWithIcon:iconForIdentifier(appID) identifier:appID];

	[appHub addTarget:self action:@selector(appViewTapped:) forControlEvents:UIControlEventTouchUpInside];
	
	[appHub setNumNotifications:((NSArray *)_currentNotifications[appID]).count];

	[_appHubs setObject:appHub forKey:appID];
	[self.phContainer addSubview:appHub];
}

- (BOOL)selected {
	return self.selectedAppID.length != 0;
}

- (void)appViewTapped:(PHAppView*)appView {
	PHAppView *previousAppHub = [_appHubs objectForKey:_selectedAppID];
	[previousAppHub animateBadge:NO duration:0.15];

	NSString *appID = appView.identifier;
	BOOL isSelected = ![_selectedAppID isEqualToString:appID];
	
	_selectedAppID = isSelected ? appID : nil;
	[self updateSelectedView];
	[self updateHubView];
	
	[self sortNotificationsIn:appID];
}
- (void)updateSelectedView {
	if (self.selected) {
		PHAppView *currentAppHub = [_appHubs objectForKey:_selectedAppID];

		[UIView animateWithDuration:0.15 animations:^{
			_phContainer.selectedView.frame = currentAppHub.frame;
			_phContainer.selectedView.alpha = 1;
			[currentAppHub animateBadge:YES duration:0.15];

		}];

		_section.notificationRequests = (NSMutableArray *)self.currentNotifications[_selectedAppID];		
		NCNotificationRequest *fristRequest = _section.notificationRequests[0];

		if ([fristRequest respondsToSelector:@selector(sxiExpand)]) {
			[fristRequest sxiExpand];
		}
		_section.title = fristRequest.content.header;

		NSLog(@"%@ select %d", NSStringFromSelector(_cmd), isStackXI);

	} else {
		[UIView animateWithDuration:0.15 animations:^{
			_phContainer.selectedView.alpha = 0;
		}];

		if (_section.notificationRequests.count > 0) {
			NCNotificationRequest *fristRequest = _section.notificationRequests[0];

			if ([fristRequest respondsToSelector:@selector(sxiCollapse)]) {
				[fristRequest sxiCollapse];
			}
		}
		_selectedAppID = nil;
		_section.title = @"";
		_section.notificationRequests = (NSMutableArray *)@[];
		NSLog(@"%@ deselect", NSStringFromSelector(_cmd));
	}
}

- (void)updateHubView {
	// reload for notifications
	// [_phContainer updateSubviews];
	[_ncdelegate.collectionView.collectionViewLayout invalidateLayout];
	[_ncdelegate.collectionView reloadData];
	// Hide pull to clear view if no app is selected
	// UIView *pullToClearView = ncPullToClearView;
	// (pullToClearView).hidden = !self.selectedAppID;
}

@end