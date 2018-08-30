#import <UIKit/UIKit.h>
#import "PHContainerView.h"
#import "PHPullToClearView.h"

#import <UserNotificationsUIKit/NCNotificationChronologicalList.h>
#import <UserNotificationsUIKit/NCNotificationActionRunner.h>
#import <UserNotificationsKit/NCNotificationAction.h>

#import <libobjc.A.dylib/NCNotificationSectionList.h>

@protocol PHControllerDelegate <NSObject>
@property (nonatomic,retain) UICollectionView * collectionView;
@property (nonatomic,retain) NCNotificationChronologicalList *notificationSectionList;     
-(long long)collectionView:(id)arg1 numberOfItemsInSection:(long long)arg2;
-(long long)numberOfSectionsInCollectionView:(id)arg1;
-(id)notificationRequestAtIndexPath:(NSIndexPath *)arg1 ;
-(NSArray *)allNotificationRequests;
-(void)removeNotificationRequest:(id)arg1 forCoalescedNotification:(id)arg2; 
-(id)notificationRequestAtIndexPath:(NSIndexPath *)indexpath;
-(id)indexPathForNotificationRequest:(id)arg1 ;
@end


@interface PHViewController : UIViewController
@property UIView *hintView;
@property PHContainerView *phContainer;
@property NSMutableDictionary *appHubs;
@property (nonatomic, assign, readonly) BOOL selected;
@property (assign) 	id <PHControllerDelegate> ncdelegate;
@property (nonatomic, copy) NSString* selectedAppID;
@property (nonatomic, copy, getter=currentNotifications) NSDictionary* currentNotifications;
@property (nonatomic) NCNotificationListSection *section;

- (BOOL)containsNotification:(NCNotificationRequest *)request withAppId:(NSString *)identifier;
- (void)updateHubView;
- (void)updateWithPref;
- (void)updateSelectedView;
- (void)updateNoticesIfNeed;
- (NSInteger)currentNotificationCount;
- (void)clearAllCurrentNotificationsWith;
- (void)clearNotification:(NCNotificationRequest *)request;
- (void)addNotification:(NCNotificationRequest *)request;
- (void)removeNotification:(NCNotificationRequest *)request;
@end
