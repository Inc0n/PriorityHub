#line 1 "tweak/PHAppView.x"
#import "PHAppView.h"
#import "PHContainerView.h"
#import "colorbadges_api.h"
#import <dlfcn.h>
#import <objc/runtime.h>
#import "Variables.h"

@implementation PHAppView

- (PHAppView*)initWithIcon:(UIImage*)icon identifier:(NSString*)appID {
	if (self = [super init]) {
		self.identifier = appID;
		numberStyle = [prefs() integerForKey:@"ncNumberStyle"];
		NSInteger style = numberStyle;
		
		CGSize size = appViewSize();
		self.frame = (CGRect){CGPointZero, size};
		
		CGFloat viewSize = size.width;
		CGFloat padding = viewSize * 0.12;
		CGFloat appViewSize = round(viewSize - 2 * padding);
		CGFloat fontSize = (numberStyle == 2) ? round(viewSize / 5) : round(viewSize / 3.25); 
		CGFloat badgeViewSize = (style == 2) ? round(appViewSize / 2.5) : round(appViewSize / 1.75); 
		
		appIconView = [[UIImageView alloc] initWithImage:icon];
		appIconView.frame = CGRectMake(padding, padding, appViewSize, appViewSize);
		[self addSubview:appIconView];
		
		numberLabel = [UILabel new];
		numberLabel.textAlignment = NSTextAlignmentCenter;
		numberLabel.textColor = [UIColor blackColor];
		numberLabel.font = [UIFont systemFontOfSize:fontSize];

		
		if (style == 1) { 
			badgeView = [UIView new];
			badgeView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
			badgeView.frame = CGRectMake(round(CGRectGetMidX(appIconView.frame) - badgeViewSize / 2), round((CGRectGetMaxY(appIconView.frame) + self.bounds.size.height) / 2 - badgeViewSize / 2), badgeViewSize, badgeViewSize);
			badgeView.layer.cornerRadius = badgeViewSize / 2.0;
			badgeView.layer.masksToBounds = YES;
			[badgeView addSubview:numberLabel];
			[self addSubview:badgeView];

			numberLabel.frame = badgeView.bounds;
			numberLabel.textColor = [UIColor colorWithWhite:0 alpha:0.7];
		}
		else if (style == 2) { 
			badgeView = [UIView new];
			badgeView.backgroundColor = [UIColor redColor];
			badgeView.layer.cornerRadius = badgeViewSize / 2;
			badgeView.layer.masksToBounds = YES;
			[badgeView addSubview:numberLabel];
			[self addSubview:badgeView];

			CGFloat badgeViewPadding = padding / 2;
			badgeView.frame = CGRectMake(viewSize - badgeViewSize - badgeViewPadding, badgeViewPadding, badgeViewSize, badgeViewSize);
			numberLabel.frame = badgeView.bounds;
			numberLabel.textColor = [UIColor whiteColor];
			
			
			dlopen("/Library/MobileSubstrate/DynamicLibraries/ColorBadges.dylib", RTLD_LAZY);
			Class cb = objc_getClass("ColorBadges");
			if (cb && [cb isEnabled]) {
				int badgeColor = [[cb sharedInstance] colorForImage:appIconView.image];
				badgeView.backgroundColor = UIColorFromRGB(badgeColor);
				BOOL isDark = [cb isDarkColor:badgeColor];
				if ([cb areBordersEnabled])
					badgeView.layer.borderWidth = 1.0;
				
				if (isDark) {
					badgeView.layer.borderColor = [UIColor whiteColor].CGColor;
					numberLabel.textColor = [UIColor whiteColor];
				}
				else {
					badgeView.layer.borderColor = [UIColor blackColor].CGColor;
					numberLabel.textColor = [UIColor blackColor];
				}
			}
		}
		
		
	}
	return self;
}

- (void)update {
	
}
- (void)updateBagdeStyle {
	
	
	
	
}
- (void)updateIconView {

	
	
	
	
	
}	

- (void)setNumNotifications:(NSInteger)numNotifications {
	numberLabel.text = [NSString stringWithFormat:@"%ld", (long)numNotifications];
}

- (void)animateBadge:(BOOL)selected duration:(NSTimeInterval)animationDuration {
	if (numberStyle == 2) 
		return;

	
	
	
	
	
	
	
	
	
	
	
	
}

@end
