#import "PHAppView.h"

extern UIImage* iconForIdentifier(NSString* identifier);

@class NCNotificationRequest, NCNotificationListSection, PHViewController;

@interface PHContainerScrollView : UIScrollView {
	NSUserDefaults *defaults;
}

@property (nonatomic, retain) UIView *selectedView;
// @property (nonatomic, retain) NSMutableDictionary *appHubs;
@property (nonatomic, retain) PHViewController *controller;
@property (nonatomic, copy) NSString* selectedAppID;
// @property (nonatomic, copy, getter=currentNotifications) NSDictionary* currentNotifications;
// @property (nonatomic) NCNotificationListSection *section;
- (id)init;
// - (void)updateSubviews;
@end