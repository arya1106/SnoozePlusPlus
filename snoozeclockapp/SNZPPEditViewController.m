#import "SNZPPEditViewController.h"

@implementation SNZPPEditViewController

-(void)loadView{
	SNZPPEditView *myView = [[SNZPPEditView alloc] initWithFrame:CGRectMake(10,10,200,200)];
	[self setView:myView];
}

-(void)viewDidLoad{
	[super viewDidLoad];
	[[self view] setBackgroundColor: [UIColor systemBackgroundColor]];
	[self view].deleteButton = [[NSClassFromString(@"MTACircleButton") alloc] initWithFrame:CGRectMake(0,0,0,0)];
	[self view].picker = [[NSClassFromString(@"MTATimerIntervalPickerView") alloc] initWithFrame:CGRectMake(0,0,0,0)];
	[[self view] addSubview: [[self view] picker]];
	[[[self view] picker] setTranslatesAutoresizingMaskIntoConstraints:NO];
	[NSLayoutConstraint activateConstraints:@[
		[self.view.picker.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
		[self.view.picker.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:75],
		[self.view.picker.widthAnchor constraintEqualToConstant:320],
		[self.view.picker.heightAnchor constraintEqualToConstant:216],
	]];

	[self view].editSnoozeDurationButton = [[UIButton alloc] initWithFrame:CGRectMake(10,10,10,10)];
	[[self view] addSubview:[[self view] editSnoozeDurationButton]];
	[[[self view] editSnoozeDurationButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
	[NSLayoutConstraint activateConstraints:@[
		[self.view.editSnoozeDurationButton.centerXAnchor constraintEqualToAnchor:[self view].centerXAnchor],
		[self.view.editSnoozeDurationButton.centerYAnchor constraintEqualToAnchor:[self view].centerYAnchor],
		[self.view.editSnoozeDurationButton.widthAnchor constraintEqualToConstant:200],
		[self.view.editSnoozeDurationButton.heightAnchor constraintEqualToConstant:50],
	]]; 
	[[[self view] editSnoozeDurationButton] setBackgroundColor:[UIColor tertiarySystemBackgroundColor]];
	[[[[self view] editSnoozeDurationButton] layer] setCornerRadius: 13];
	[[[[self view] editSnoozeDurationButton] layer] setCornerCurve: kCACornerCurveContinuous];
	[[[self view] editSnoozeDurationButton] addTarget:self action:@selector(clearDuration) forControlEvents:UIControlEventTouchUpInside];
	[[[self view] editSnoozeDurationButton] addTarget:self action:@selector(highlightSnoozePlusPlusButton) forControlEvents:UIControlEventTouchDown];
	[[[self view] editSnoozeDurationButton] setTitle:@"Clear Snooze" forState:UIControlStateNormal];
	[[[self view] editSnoozeDurationButton] setTitleColor:[[[UIApplication sharedApplication] keyWindow] tintColor] forState:UIControlStateNormal];
	[[[[self view] editSnoozeDurationButton] titleLabel] setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];

	[[self view] updateLabels];
	if([self alarmIdentifier]) [self setTitle:@"Snooze Duration"];
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(doneEditing)];
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

-(void)highlightSnoozePlusPlusButton{
	[[[self view] editSnoozeDurationButton] setAlpha:0.5];
}

-(void)clearDuration{
	[[[self view] editSnoozeDurationButton] setAlpha:0.5];
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
@end