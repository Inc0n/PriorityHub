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
@property (nonatomic, retain) UIView *hintView;
@property (nonatomic, retain) PHContainerView *phContainer;
@property (nonatomic, retain) NSMutableDictionary *appHubs;
@property (nonatomic, assign, readonly) BOOL selected;
@property (assign) 	id <PHControllerDelegate> ncdelegate;
@property (nonatomic, copy) NSString* selectedAppID;
@property (nonatomic, copy, getter=currentNotifications) NSDictionary* currentNotifications;
@property (nonatomic, retain) NCNotificationListSection *section;

- (BOOL)containsNotification:(NCNotificationRequest *)request withAppId:(NSString *)identifier;
- (void)updateHubView;
- (void)updateSelectedView;
- (NSInteger)currentNotificationCount;
- (void)clearAllCurrentNotifications;
- (void)clearNotificationRequest:(NCNotificationRequest *)request;
- (void)addNotificationRequest:(NCNotificationRequest *)request;
- (void)removeNotificationRequest:(NCNotificationRequest *)request;
@end
