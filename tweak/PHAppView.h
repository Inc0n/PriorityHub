#import <UIKit/UIKit.h>

@interface PHAppView : UIControl {
	UIImageView *appIconView;
	UILabel *numberLabel;
	UIView *badgeView;
	int numberStyle;
}

@property (copy) NSString *identifier;

- (PHAppView*)initWithIcon:(UIImage*)icon identifier:(NSString*)appID;
- (void)setNumNotifications:(NSInteger)numNotifications;
- (void)animateBadge:(BOOL)selected duration:(NSTimeInterval)animationDuration;
- (void)update;
@end
