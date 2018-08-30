#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define pullToClearSize  30
#define pullToClearThreshold  35

@interface PHPullToClearView : UIView {
    CAShapeLayer *circleLayer, *xLayer;
}

@property BOOL xVisible;  
@property (nonatomic, copy) void (^clearBlock)();

- (void)didScroll:(UIScrollView*)scrollView;
- (void)didEndDragging:(UIScrollView*)scrollView;

@end
