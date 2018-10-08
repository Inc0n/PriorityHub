#import <UIKit/UIKit.h>
#import "PHContainerScrollView.h"
#import "PHPullToClearView.h"

#import <UserNotificationsUIKit/NCNotificationChronologicalList.h>
#import <UserNotificationsUIKit/NCNotificationActionRunner.h>
#import <UserNotificationsUIKit/NCNotificationListCell.h>
#import <UserNotificationsKit/NCNotificationAction.h>

#import <libobjc.A.dylib/NCNotificationSectionList.h>

@protocol PHControllerDelegate <NSObject>
@property (nonatomic,retain) UICollectionView * collectionView;
@property (nonatomic,retain) NCNotificationChronologicalList *notificationSectionList;     
-(long long)collectionView:(id)arg1 numberOfItemsInSection:(long long)arg2;
-(long long)numberOfSectionsInCollectionView:(id)arg1;
// -(id)notificationRequestAtIndexPath:(NSIndexPath *)arg1 ;
// -(id)indexPathForNotificationRequest:(id)arg1 ;
-(NSArray *)allNotificationRequests;
// -(void)removeNotificationRequest:(id)arg1 forCoalescedNotification:(id)arg2; 
-(id)notificationRequestAtIndexPath:(NSIndexPath *)indexpath;
@end


@interface PHViewController : UIViewController
@property (nonatomic, retain) PHContainerScrollView *phContainer;
@property (nonatomic, retain) PHPullToClearView *pullToClearView;
@property (nonatomic, retain) NSMutableDictionary *appHubs;
@property (nonatomic, retain) NSDictionary* d_allNotifications;
@property (nonatomic,retain) NSMutableOrderedSet *orderedSet;
@property (nonatomic, copy) NSMutableArray *appIDs;
@property (assign) 	UICollectionViewController <PHControllerDelegate> *ncdelegate;
@property (nonatomic, readonly) BOOL selected;
@property (nonatomic, copy) NSString* selectedAppID;

- (BOOL)containsNotification:(NCNotificationRequest *)request withAppId:(NSString *)identifier;
- (void)updateHubView;
- (void)updateSelectedView;
- (void)updateNotifications;
- (NSInteger)currentNotificationCount;
- (NCNotificationRequest *)requestAtIndex:(NSInteger)index;
// - (void)clearAllCurrentNotifications:(NCNotificationListCell *)cell;
- (void)clearNotificationRequest:(NCNotificationRequest *)request origin:(NCNotificationListCell *)cell;
- (void)addNotificationRequest:(NCNotificationRequest *)request;
- (void)removeNotificationRequest:(NCNotificationRequest *)request;
- (void)didScroll:(UIScrollView*)scrollView;
- (void)didEndDragging:(UIScrollView*)scrollView;
- (void)didBeginDragging:(UIScrollView*)scrollView;
@end
