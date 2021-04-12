#import <Foundation/Foundation.h>
#import "snoozeclockapp/MTAlarm.h"

%hook MTAlarm
-(void)setSnoozeFireDate:(id)fireDate{
	if(!fireDate) {
		%orig;
		return;
	}
	NSURL *prefsPlistURL = [NSURL fileURLWithPath:@"/var/mobile/Library/Preferences/com.arya06.snooze++prefs.plist"];
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfURL:prefsPlistURL error:nil];
	id snoozeTime = [settings valueForKey:[self identifier]];
	if(snoozeTime){
		%orig([[NSDate date] dateByAddingTimeInterval:[snoozeTime doubleValue]]);
	}
	else{
		id defaultGlobalSnoozeTime = [settings valueForKey:@"defaultGlobalSnooze"];
		if(defaultGlobalSnoozeTime) %orig([[NSDate date] dateByAddingTimeInterval:[defaultGlobalSnoozeTime doubleValue]]);
		else %orig([[NSDate date] dateByAddingTimeInterval:540]);
	}
}
%end