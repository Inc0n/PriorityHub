
#import "Variables.h"

BOOL getBoolWithKey(NSString *key) {
	return [prefs() boolForKey:key];
}
BOOL getEnabled(BOOL lockScreen) {
	return getBoolWithKey(lockScreen ? @"lsEnabled" : @"ncEnabled");
}