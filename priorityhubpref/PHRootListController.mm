#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>

@interface PHRootListController: PSListController
@end

@implementation PHRootListController

- (void)TFTwitterButtonTapped {
	UIApplication *app = [UIApplication sharedApplication];
	NSURL *tweetbot = [NSURL URLWithString:@"tweetbot:///user_profile/tomf64"];
	if ([app canOpenURL:tweetbot])
		[app openURL:tweetbot];
	else {
		NSURL *twitterapp = [NSURL URLWithString:@"twitter:///user?screen_name=tomf64"];
		if ([app canOpenURL:twitterapp])
			[app openURL:twitterapp];
		else {
			NSURL *twitterweb = [NSURL URLWithString:@"http://twitter.com/tomf64"];
			[app openURL:twitterweb];
		}
	}
}

- (void)JGTwitterButtonTapped {
	UIApplication *app = [UIApplication sharedApplication];
	NSURL *tweetbot = [NSURL URLWithString:@"tweetbot:///user_profile/JeremyGoulet"];
	if ([app canOpenURL:tweetbot])
		[app openURL:tweetbot];
	else {
		NSURL *twitterapp = [NSURL URLWithString:@"twitter:///user?screen_name=JeremyGoulet"];
		if ([app canOpenURL:twitterapp])
			[app openURL:twitterapp];
		else {
			NSURL *twitterweb = [NSURL URLWithString:@"http://twitter.com/JeremyGoulet"];
			[app openURL:twitterweb];
		}
	}
}

- (void)GithubButtonTapped {
	NSURL *githubURL = [NSURL URLWithString:@"https://github.com/thomasfinch/Priority-Hub"];
	[[UIApplication sharedApplication] openURL:githubURL];
}

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}
	return _specifiers;
}

@end
