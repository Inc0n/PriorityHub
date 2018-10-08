#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define pullToClearSize  30
#define pullToClearThreshold  100

@interface PHPullToClearView : UIView {
    CAShapeLayer *progressLayer;
}

@property (nonatomic, copy) void (^clearBlock)();
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIView *progressContainerView;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;

- (void)updateProgress:(CGFloat)progress;

- (void)hideAllHidable;
- (void)setCenterForSubviewsByY:(CGFloat)y;

// - (void)didScroll:(UIScrollView*)scrollView;
// - (void)didEndDragging:(UIScrollView*)scrollView;
// - (void)didBeginDragging:(UIScrollView*)scrollView;

@end
