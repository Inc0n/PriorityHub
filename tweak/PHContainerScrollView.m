#import "PHContainerScrollView.h"
// #import "substrate.h"
#import "Variables.h"
#import <Constant.h>

@implementation PHContainerScrollView {

}

- (id)init {
	if (self = [super init]) {
		self.directionalLockEnabled = YES;
		self.clipsToBounds = NO;

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
	//Layout all app hub views
	CGSize appViewSizeVar = appViewSize();
	CGFloat totalWidth = _controller.appHubs.count * appViewSizeVar.width;
	self.contentSize = CGSizeMake(totalWidth, appViewSizeVar.height);
	CGFloat startX = (CGRectGetWidth(self.frame) - totalWidth)/2;
	if (startX < 0)
		startX = 0;

	for (NSString *key in _controller.appHubs) {
		PHAppView *appView = _controller.appHubs[key];
		// [appView update];
		
		appView.frame = (CGRect){{startX, 0}, appViewSizeVar};
		startX += appViewSizeVar.width;
	}

	_selectedView.layer.cornerRadius = appViewSize().width / 5; // Just in case settings have changed
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	UIView *hitView = [super hitTest:point withEvent:event];
	if (hitView == self) return nil;
	return hitView;
}
@end
