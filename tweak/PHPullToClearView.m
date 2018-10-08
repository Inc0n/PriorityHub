#import "PHPullToClearView.h"
#import <Constant.h>
#import "Headers.h"

@implementation PHPullToClearView {
	CGFloat beginOffset, beginLabelCenterY;
	BOOL beganDrag;
	
}

- (id)init {
	if (self = [super init]) {

		self.userInteractionEnabled = NO;
		self.backgroundColor = [UIColor clearColor];
		self.frame = (CGRect){CGPointZero, {kScreenWidth, pullToClearThreshold}};

		_progressContainerView = [UIView new];
		_progressContainerView.hidden = YES;
		_progressContainerView.backgroundColor = UIColor.clearColor;
		[self addSubview:_progressContainerView];
		
		[self setupLabel];
		[self setupLoadingIndicator];
		[self setupCircularProgressBar];
	}
	return self;
}
- (void)setupLabel {
	_label = [UILabel.alloc init];
	self.label.text = @"release to clear";
	self.label.hidden = YES;
	self.label.textColor = UIColor.whiteColor;
	[self.label sizeToFit];
	self.label.center = self.center;
	[self addSubview:self.label];
}

- (void)setupLoadingIndicator {
	_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[self addSubview:self.spinner];
}

- (void)setupCircularProgressBar {
    //// Color Declarations
	// const CGFloat gray = 0.666;
    // UIColor* color = [UIColor colorWithRed: gray green: gray blue: gray alpha: 1];
    UIColor* color2 = [UIColor colorWithRed: 0 green: 0.65 blue: 0.438 alpha: 1];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = UIColor.clearColor.CGColor;
    shapeLayer.strokeColor = UIColor.lightGrayColor.CGColor;
    shapeLayer.lineWidth = 3;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.path = [self generateHollowCirclePath:1.0].CGPath;

    [_progressContainerView.layer addSublayer:shapeLayer];
    
    //// progress Drawing
    progressLayer = [CAShapeLayer layer];
    progressLayer.lineWidth = 4;
    progressLayer.fillColor = UIColor.clearColor.CGColor;
    progressLayer.strokeColor = color2.CGColor;
    progressLayer.lineCap = kCALineCapRound;

    [self updateProgress:0.0];
    [_progressContainerView.layer addSublayer:progressLayer];
}

const CGFloat width = 30;

- (UIBezierPath *)generateHollowCirclePath:(CGFloat)progress {
    CGRect oval2Rect = CGRectMake(0, 0, width, width);
    // CGRect oval2Rect = CGRectMake(0, 0, 50, 50);
    
    UIBezierPath* progressPath = [UIBezierPath bezierPath];
    CGFloat constant = M_PI * 0.5;
    CGFloat endangle = M_PI * 2 * progress - constant;
    
    [progressPath addArcWithCenter: CGPointMake(CGRectGetMidX(oval2Rect), CGRectGetMidY(oval2Rect)) radius: width / 2 startAngle: -constant endAngle: endangle clockwise: YES];

    progressPath.lineCapStyle = kCGLineCapRound;
    return progressPath;
}

- (void)updateProgress:(CGFloat)progress {
    if (progress > 1) progress = 1;
    if (progress < 0) progress = 0;
    
    progressLayer.strokeStart = 0;
    progressLayer.strokeEnd = progress;

    progressLayer.path = [self generateHollowCirclePath:progress].CGPath;
    
}

- (void)hideAllHidable {
	self.progressContainerView.hidden = YES;
	self.label.hidden = YES;
}

- (void)setCenterForSubviewsByY:(CGFloat)y {
	CGPoint center = _label.center;
	center.y = y - 10; // currentLength;
	_label.center = center;
	_spinner.center = center;
	center.x -= width / 2;
	center.y -= width / 2 - 5;
	_progressContainerView.center = center;
}
@end
