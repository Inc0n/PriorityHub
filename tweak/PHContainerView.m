#import "PHContainerView.h"
// #import "substrate.h"
#import "Variables.h"


@implementation PHContainerView {

}

- (id)init {
	if (self = [super init]) {
		self.directionalLockEnabled = YES;

		//Create the selected view
		_selectedView = [UIView new];
		_selectedView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
		
		_selectedView.layer.masksToBounds = YES;
		[self addSubview:_selectedView];

		//Initialize other instance variables
		defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.kunderscore.priorityhub"];
		
		self.userInteractionEnabled = YES;
	}
	return self;
}

- (void)layoutSubviews {
	// NSLog(@"PHContainerView %@", NSStringFromSelector(_cmd));
	//Layout all app views
	CGSize appViewSizeVar = appViewSize();
	CGFloat totalWidth = _controller.appHubs.count * appViewSizeVar.width;
	self.contentSize = CGSizeMake(totalWidth, appViewSizeVar.height);
	CGFloat startX = (CGRectGetWidth(self.frame) - totalWidth)/2;
	if (startX < 0)
		startX = 0;

	for (NSString *key in _controller.appHubs) {
		PHAppView *appView = _controller.appHubs[key];
		appView.frame = CGRectMake(startX, 0, appViewSizeVar.width, appViewSizeVar.height);
		startX += appViewSizeVar.width;
	}

	_selectedView.layer.cornerRadius = appViewSize().width / 5; // Just in case settings have changed
}

// - (void)updateNotificationView {
// 	[_ncdelegate.collectionView.collectionViewLayout invalidateLayout];
// 	[_ncdelegate.collectionView reloadData];
// 	// TODO: update scroll view height

// 	// Hide pull to clear view if no app is selected
// 	// PHContainerView *ncPhContainerView = ncPhContainerView;
// 	// UIView *pullToClearView = ncPullToClearView;
// 	// (pullToClearView).hidden = !self.selectedAppID;
// }
@end
