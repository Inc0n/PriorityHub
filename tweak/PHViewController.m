
#import "PHViewController.h"
#import "Variables.h"

@interface PHViewController () {
	// PHContainerScrollView *phContainer
}
@end

@implementation PHViewController {
	NSMutableDictionary <NSString *, NSMutableArray *> *_d_allNotifications;
	NSMutableArray *_appIDs;
	NSUserDefaults *defaults;
	CGFloat beginOffset, beginLabelCenterY;
	BOOL beganDrag;
}

- (PHViewController *)init {
	self = [super init];
	if (self) {
		self.phContainer = [[PHContainerScrollView alloc] init];
		self.phContainer.bounces = YES;
		self.phContainer.showsHorizontalScrollIndicator = NO;
		self.phContainer.controller = self;
		
		self.appHubs = [NSMutableDictionary new];
		_orderedSet = [NSMutableOrderedSet new];
		_d_allNotifications = [NSMutableDictionary new];
		_appIDs = [NSMutableArray array];
		defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.kunderscore.priorityhub"];
	}
	return self;
}

- (NSMutableOrderedSet *)orderedSet {
	[_orderedSet removeAllObjects];
	[_orderedSet addObjectsFromArray:self.d_allNotifications[self.selectedAppID]];
	return _orderedSet;
}
- (void)sortNotificationsIn:(NSString *)hubID { 
	NSArray *sortedArray = (NSArray *)_d_allNotifications[hubID];
	
	if (sortedArray.count < 2) return ;

	sortedArray = [sortedArray sortedArrayUsingComparator:^NSComparisonResult(NCNotificationRequest *a, NCNotificationRequest *b) {
		NSDate *first = [a timestamp];
		NSDate *second = [b timestamp];
		return -1 * [first compare:second];
	}];

	_d_allNotifications[hubID] = [sortedArray mutableCopy];
}

- (void)updateNotifications {
	NSArray *requests = [_ncdelegate allNotificationRequests];
	if ([self totalNotificationRequests] == requests.count) return;
	
	[self removeAllNotificationRequests];
	// _d_allNotifications = [NSMutableDictionary new];
	_appIDs = [NSMutableArray array];

	for (NCNotificationRequest *request in requests) {
		[self addNotificationRequest:request];
	}
}
- (void)addNotificationRequest:(NCNotificationRequest *)request {
	NSString *identifier = [request sectionIdentifier];
	
	NSMutableArray *requests;
	NSLog(@"%@ %@", NSStringFromSelector(_cmd), identifier);
	
	if ([_appIDs containsObject:identifier]) {
		if ([self containsNotification:request withAppId:identifier])
			return;

		requests = [self.d_allNotifications[identifier] mutableCopy];
		[requests insertObject:request atIndex:0];
		_d_allNotifications[identifier] = requests;
		
		[_appIDs removeObject:identifier];
		[_appIDs insertObject:identifier atIndex:0];

		[self updateNotificationCount:identifier];

	} else {
		requests = [NSMutableArray arrayWithObject:request];
		[_d_allNotifications setObject:requests forKey:identifier];

		[self createAndAddNewAppHub:identifier];
	}
	// if ()
	// _selectedAppID = identifier;
	// if (self.selected) {
	// 	[self updateSelectedView];
	// }
}

- (NCNotificationRequest *)requestAtIndex:(NSInteger)index {
	if (index > -1 && index < [self currentNotificationCount])
		return _d_allNotifications[_selectedAppID][index];
	return nil;
}

- (void)updateNotificationCount:(NSString *)identifier {

	PHAppView *appHub = _appHubs[identifier];
	if (appHub) {
		NSInteger count = _d_allNotifications[identifier].count;
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

- (void)createAndAddNewAppHub:(NSString *)appID {
	// [_appIDs insertObject:appID atIndex:0];
	[_appIDs addObject:appID];

	PHAppView *appHub = [PHAppView.alloc initWithIcon:iconForIdentifier(appID) identifier:appID];

	[appHub addTarget:self action:@selector(appViewTapped:) forControlEvents:UIControlEventTouchUpInside];
	
	[appHub setNumNotifications:((NSArray *)_d_allNotifications[appID]).count];

	[_appHubs setObject:appHub forKey:appID];
	[self.phContainer addSubview:appHub];
}

- (NSInteger)currentNotificationCount {
	return _d_allNotifications[_selectedAppID].count;
}

- (NSInteger)totalNotificationRequests {
	NSInteger total = 0;
	for (NSString *appID in _d_allNotifications) {
		total += _d_allNotifications[appID].count;
	}
	return total;
}

# pragma mark notificationRequest checks 

- (BOOL)containsNotification:(NCNotificationRequest *)request withAppId:(NSString *)identifier {
	return [_d_allNotifications[identifier] containsObject:request];
}

- (BOOL)shouldRemoveNotifcation:(NCNotificationRequest *)request {
	NSString *identifier = [request sectionIdentifier];
	return _d_allNotifications[identifier] && 
		   [self containsNotification:request withAppId:identifier];
}

# pragma mark removal of notificationRequest 

- (void)removeNotificationRequest:(NCNotificationRequest *)request {
	if ([self shouldRemoveNotifcation:request]) {
		NSString *identifier = [request sectionIdentifier];
		[_d_allNotifications[identifier] removeObject:request];
		[self updateNotificationCount:identifier];
	}
}

- (void)removeAllNotificationRequests {
	[_appHubs enumerateKeysAndObjectsUsingBlock:^(NSString *key, PHAppView *appView, BOOL *stop) {
		[appView removeFromSuperview];
	}];
	[_appHubs removeAllObjects];
	[_d_allNotifications removeAllObjects];
}

# pragma mark clearing notificationRequest

- (void)clearAllCurrentNotifications:(NCNotificationListCell *)cell completion:(void (^)())completion {
	[self clearAllCurrentNotifications:cell];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(250 * USEC_PER_SEC)), dispatch_get_main_queue(), completion);
}

- (void)clearAllCurrentNotifications:(NCNotificationListCell *)cell {
	NSString *hubID = self.selectedAppID;
	_selectedAppID = nil;
	[self updateSelectedView];
	[self updateHubView];
	NSArray *requests = _d_allNotifications[hubID];
	NSLog(@"%@ %@", NSStringFromSelector(_cmd), @(_d_allNotifications[hubID].count));

	if (requests.count > 0) {
		[requests enumerateObjectsUsingBlock:^(NCNotificationRequest *request, NSUInteger index, BOOL *stop) {
			[self clearNotificationRequest:request origin:nil];
		}];
	}
}

- (void)clearNotificationRequest:(NCNotificationRequest *)request origin:(NCNotificationListCell *)cell {
	NCNotificationAction *action = request.clearAction;
	[action.actionRunner executeAction:action fromOrigin:cell withParameters:[NSArray array] completion:nil];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(250 * USEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self removeNotificationRequest:request];
	});
}
// - (UIImage *)getImageForNotfication:(NCNotificationRequest *)request {
// 	NSIndexPath *indePath = [_ncdelegate indexPathForNotificationRequest:request];
// 	NCNotificationListCell *cell = [_ncdelegate collectionView:_ncdelegate.collectionView cellForItemAtIndexPath:indexPath];
// 	NCNotificationShortLookView *shortlookview = IvarOf(cell.contentViewController.view, _contentView);

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

		// _section.notificationRequests = (NSMutableArray *);		
		NCNotificationRequest *fristRequest = self.d_allNotifications[_selectedAppID][0];

		if ([fristRequest respondsToSelector:@selector(sxiExpand)]) {
			[fristRequest sxiExpand];
		}
		// _section.title = fristRequest.content.header;

		NSLog(@"%@ select %d", NSStringFromSelector(_cmd), isStackXI);

	} else {
		[UIView animateWithDuration:0.15 animations:^{
			_phContainer.selectedView.alpha = 0;
		}];

		NSArray *requests = self.d_allNotifications[_selectedAppID];
		if (requests.count > 0) {
			NCNotificationRequest *firstRequest = requests[0];

			if ([firstRequest respondsToSelector:@selector(sxiCollapse)]) {
				[firstRequest sxiCollapse];
			}
		}
		_selectedAppID = nil;
		// _section.title = @"";
		// _section.notificationRequests = (NSMutableArray *)@[];
		NSLog(@"%@ deselect", NSStringFromSelector(_cmd));
	}
}

- (void)updateHubView {
	// reload for notifications
	// [_phContainer updateSubviews];
	[_ncdelegate.collectionView.collectionViewLayout invalidateLayout];
	[_ncdelegate.collectionView reloadData];
	// Hide pull to clear view if no app is selected
}

# pragma mark pull to clear scroll view delegates

- (void)didScroll:(UIScrollView*)scrollView {
	if (!beganDrag) return ;

	CGFloat offset = scrollView.contentOffset.y;
	BOOL isPulling = offset <= -scrollView.contentInset.top;
	CGFloat currentLength = offset - beginOffset;

	if (currentLength > 0) currentLength = 0;
	
	if (!isPulling) {
		[self.pullToClearView hideAllHidable];
		return ;
	}

	CGFloat progress = fabs(currentLength) / (pullToClearThreshold - 5);
	[self.pullToClearView updateProgress:progress];

	BOOL hidden = progress > 1;
	self.pullToClearView.progressContainerView.hidden = hidden;
	self.pullToClearView.label.hidden = !hidden;

	// move label to above
	[self.pullToClearView setCenterForSubviewsByY:beginLabelCenterY - appViewSize().height - 10];
}

- (void)didBeginDragging:(UIScrollView*)scrollView {

	beginLabelCenterY = self.pullToClearView.center.y;
	beginOffset = scrollView.contentOffset.y;
	beganDrag = YES;
}

- (void)didEndDragging:(UIScrollView*)scrollView {
	beganDrag = NO;

	CGFloat offset = scrollView.contentOffset.y;
	CGFloat length = offset - beginOffset;
	__block UIEdgeInsets insets = scrollView.contentInset;
	
	BOOL didPull = length <= -pullToClearThreshold && offset < -insets.top;

	[self.pullToClearView hideAllHidable];

	if (!didPull) return;

	if (!(scrollView.dragging || scrollView.tracking)) return ;

	NSLog(@"should clear %f %@", fabs(insets.top), @(didPull));
	
	insets.top += pullToClearThreshold;
	scrollView.contentInset = insets;
	scrollView.userInteractionEnabled = NO;

	[self.pullToClearView.spinner startAnimating];
	[self clearAllCurrentNotifications:nil completion:^{
		[self.pullToClearView.spinner stopAnimating];

		scrollView.userInteractionEnabled = YES;
		insets.top -= pullToClearThreshold;
		[UIView animateWithDuration:0.2 animations:^{
			scrollView.contentInset = insets;
		}];
	}];

        // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), );
	[self.pullToClearView updateProgress:0.0];
}

@end