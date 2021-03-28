#import <Foundation/Foundation.h>

@interface MTAlarm
-(void)setSnoozeFireDate:(id)fireDate;
-(id)identifier;
-(BOOL)isSnoozed;
@end

%hook MTAlarm
-(void)setSnoozeFireDate:(id)fireDate{
	if(!fireDate) {
		%orig;
		return;
	}
	NSURL *prefsPlistURL = [NSURL fileURLWithPath:@"/var/mobile/Library/Preferences/com.arya06.snooze++prefs.plist"];
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfURL:prefsPlistURL error:nil];
	id snoozeTime = [settings valueForKey:[self identifier]];
	NSLog(@"TESTING %i", [self isSnoozed]);
	if(snoozeTime){
		%orig([[NSDate date] dateByAddingTimeInterval:[snoozeTime doubleValue]]);
	}
	else{
		%orig([[NSDate date] dateByAddingTimeInterval:[[settings objectForKey:@"snoozeTime"] doubleValue]]);
	}
}
%end