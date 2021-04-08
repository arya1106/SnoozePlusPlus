#import "SNZPPEditViewController.h"

@implementation SNZPPEditViewController

-(void)loadView{
	SNZPPEditView *myView = [[SNZPPEditView alloc] initWithFrame:CGRectMake(10,10,200,200)];
	[self setView:myView];
}

-(void)viewDidLoad{
	[super viewDidLoad];
	[[self view] setBackgroundColor: [UIColor systemBackgroundColor]];
	[self view].picker = [[NSClassFromString(@"MTATimerIntervalPickerView") alloc] initWithFrame:CGRectMake(0,0,0,0)];
	[[self view] addSubview: [[self view] picker]];
	[[[self view] picker] setTranslatesAutoresizingMaskIntoConstraints:NO];
	[NSLayoutConstraint activateConstraints:@[
		[self.view.picker.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
		[self.view.picker.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:75],
		[self.view.picker.widthAnchor constraintEqualToConstant:320],
		[self.view.picker.heightAnchor constraintEqualToConstant:216],
	]];

	[self view].clearSnoozeDurationButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[[self view] addSubview:[[self view] clearSnoozeDurationButton]];
	[[[self view] clearSnoozeDurationButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
	[NSLayoutConstraint activateConstraints:@[
		[self.view.clearSnoozeDurationButton.centerXAnchor constraintEqualToAnchor:[self view].centerXAnchor],
		[self.view.clearSnoozeDurationButton.centerYAnchor constraintEqualToAnchor:[self view].centerYAnchor],
		[self.view.clearSnoozeDurationButton.widthAnchor constraintEqualToConstant:200],
		[self.view.clearSnoozeDurationButton.heightAnchor constraintEqualToConstant:50],
	]]; 
	[[[self view] clearSnoozeDurationButton] setBackgroundColor:[UIColor tertiarySystemBackgroundColor]];
	[[[[self view] clearSnoozeDurationButton] layer] setCornerRadius: 13];
	[[[[self view] clearSnoozeDurationButton] layer] setCornerCurve: kCACornerCurveContinuous];
	[[[self view] clearSnoozeDurationButton] addTarget:self action:@selector(clearDuration) forControlEvents:UIControlEventTouchUpInside];
	[[[self view] clearSnoozeDurationButton] setTitle:@"Clear Snooze" forState:UIControlStateNormal];
	[[[self view] clearSnoozeDurationButton] setTitleColor:[[[UIApplication sharedApplication] keyWindow] tintColor] forState:UIControlStateNormal];
	[[[[self view] clearSnoozeDurationButton] titleLabel] setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];

	if(![self alarmIdentifier]){
		[self view].bedtimeAlarmsButton = [UIButton buttonWithType:UIButtonTypeSystem];
		[[self view] addSubview:[[self view] bedtimeAlarmsButton]];
		[[[self view] bedtimeAlarmsButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
		[NSLayoutConstraint activateConstraints:@[
			[self.view.bedtimeAlarmsButton.centerXAnchor constraintEqualToAnchor:[self view].centerXAnchor],
			[self.view.bedtimeAlarmsButton.centerYAnchor constraintEqualToAnchor:[self view].centerYAnchor constant:75],
			[self.view.bedtimeAlarmsButton.widthAnchor constraintEqualToConstant:200],
			[self.view.bedtimeAlarmsButton.heightAnchor constraintEqualToConstant:50],
		]];
		[[[self view] bedtimeAlarmsButton] setBackgroundColor:[UIColor tertiarySystemBackgroundColor]];
		[[[[self view] bedtimeAlarmsButton] layer] setCornerRadius: 13];
		[[[[self view] bedtimeAlarmsButton] layer] setCornerCurve: kCACornerCurveContinuous];
		if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){.majorVersion = 14, .minorVersion = 0, .patchVersion = 0}] && [[[[[UIApplication sharedApplication] valueForKey:@"_alarmManager"] cache] sleepAlarms] count] > 1 ) {
			[[[self view] bedtimeAlarmsButton] setTitle:@"Bedtime Alarms" forState:UIControlStateNormal];
			[[[self view] bedtimeAlarmsButton] addTarget:self action:@selector(presentBedtimeAlarmViewController) forControlEvents:UIControlEventTouchUpInside];
		}
		else {
			[[[self view] bedtimeAlarmsButton] setTitle:@"Bedtime Alarm" forState:UIControlStateNormal];
			[[[self view] bedtimeAlarmsButton] addTarget:self action:@selector(presentEditViewController) forControlEvents:UIControlEventTouchUpInside];
		};
		[[[self view] bedtimeAlarmsButton] setTitleColor:[[[UIApplication sharedApplication] keyWindow] tintColor] forState:UIControlStateNormal];
		[[[[self view] bedtimeAlarmsButton] titleLabel] setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
	}	

	[[self view] updateLabels];
	if([self alarmIdentifier]) [self setTitle:@"Snooze Duration"];
	else [self setTitle:@"Default Snooze Duration"];
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(doneEditing)];
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEditing)];
	[[self navigationItem] setRightBarButtonItem:doneButton];
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/com.arya06.snooze++prefs.plist"]){
		NSURL *prefsPlistURL = [NSURL fileURLWithPath:@"/var/mobile/Library/Preferences/com.arya06.snooze++prefs.plist"];
		NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfURL:prefsPlistURL error:nil];
		if([self alarmIdentifier]){
			id snoozeDuration = [plistDict valueForKey:[self alarmIdentifier]];
			if(snoozeDuration){
				[[self view] setDuration:[snoozeDuration floatValue]];
			}
		}
		else{
			id snoozeDuration = [plistDict valueForKey:@"defaultGlobalSnooze"];
			[[self view] setDuration:[snoozeDuration floatValue]];
		}
	}
	else{
		if(![self alarmIdentifier]) [[self view] setDuration:540];
	}
}


-(void)doneEditing{
	if([[self view] getDuration] == 0){
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invalid Snooze Duration" message:@"Please select a snooze duration of at least one second. If you'd like to clear the snooze duration, pleasae use the delete button below." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
		[alert addAction:defaultAction];
		[self presentViewController:alert animated:YES completion:nil];
		return;
	}
	[self dismissViewControllerAnimated:YES completion:nil];
	NSURL *prefsPlistURL = [NSURL fileURLWithPath:@"/var/mobile/Library/Preferences/com.arya06.snooze++prefs.plist"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/com.arya06.snooze++prefs.plist"]){
		NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfURL:prefsPlistURL error:nil];
		NSMutableDictionary *prefsDict = [NSMutableDictionary dictionaryWithDictionary:plistDict];
		if(![self alarmIdentifier]) [prefsDict setObject:@([[self view] getDuration]) forKey:@"defaultGlobalSnooze"];
		else [prefsDict setObject:@([[self view] getDuration]) forKey:[self alarmIdentifier]];
		[prefsDict writeToURL:prefsPlistURL error:nil];
	}
	else {
		NSMutableDictionary *prefsDict = [[NSMutableDictionary alloc] init];
		if(![self alarmIdentifier]) [prefsDict setObject:@([[self view] getDuration]) forKey:@"defaultGlobalSnooze"];
		else [prefsDict setObject:@([[self view] getDuration]) forKey:[self alarmIdentifier]];
		[prefsDict writeToURL:prefsPlistURL error:nil];
	}
}

-(void)cancelEditing{
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clearDuration{
	[[[self view] clearSnoozeDurationButton] setAlpha:0.5];
	NSURL *prefsPlistURL = [NSURL fileURLWithPath:@"/var/mobile/Library/Preferences/com.arya06.snooze++prefs.plist"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/com.arya06.snooze++prefs.plist"]){
		NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfURL:prefsPlistURL error:nil];
		NSMutableDictionary *prefsDict = [NSMutableDictionary dictionaryWithDictionary:plistDict];
		if([self alarmIdentifier]) [prefsDict removeObjectForKey:[self alarmIdentifier]];
		else [prefsDict removeObjectForKey:@"defaultGlobalSnooze"];
		[prefsDict writeToURL:prefsPlistURL error:nil];
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)presentBedtimeAlarmViewController{
	[[[self view] bedtimeAlarmsButton] setAlpha:1];
	SNZPPBedtimeAlarmsTableViewController *bedtimeTableVC = [[SNZPPBedtimeAlarmsTableViewController alloc] init];
	UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:bedtimeTableVC];
	[self presentViewController:navigationVC animated:YES completion:nil];

}

-(void)presentEditViewController{
	SNZPPEditViewController *editVC = [[SNZPPEditViewController alloc] init];
	UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:editVC];
	if([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){.majorVersion = 14, .minorVersion = 0, .patchVersion = 0}]){
		[editVC setAlarmIdentifier:[[[[[[UIApplication sharedApplication] valueForKey:@"_alarmManager"] cache] sleepAlarms] objectAtIndex:0] identifier]];
	}
	else{
		[editVC setAlarmIdentifier:[[[[[UIApplication sharedApplication] valueForKey:@"_alarmManager"] cache] sleepAlarm] identifier]];
	}
	[self presentViewController:navigationVC animated:YES completion:nil];
}
@end