#import "PHAppView.h"

extern CGSize appViewSize();
extern UIImage* iconForIdentifier(NSString* identifier);

@class NCNotificationRequest, NCNotificationListSection, PHViewController;

@interface PHContainerView : UIScrollView {
	NSUserDefaults *defaults;
}

@property UIView *selectedView;
@property NSMutableDictionary *appHubs;
@property (nonatomic) PHViewController *controller;
@property (nonatomic, copy) NSString* selectedAppID;
// @property (nonatomic, copy, getter=currentNotifications) NSDictionary* currentNotifications;
// @property (nonatomic) NCNotificationListSection *section;
- (id)init;
// - (void)updateView;
@end