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

	UILabel *buttonText = [[UILabel alloc] initWithFrame:CGRectMake(10,10,10,10)];
	[[[self view] editSnoozeDurationButton] addSubview:buttonText];
	[buttonText setText:@"Clear Duration"];
	[buttonText setTextAlignment:NSTextAlignmentCenter];
	[buttonText setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
	[buttonText setTextColor:[[[UIApplication sharedApplication] keyWindow] tintColor]];
	[buttonText setTranslatesAutoresizingMaskIntoConstraints:NO];
		[NSLayoutConstraint activateConstraints:@[
		[buttonText.centerXAnchor constraintEqualToAnchor:[[self view] editSnoozeDurationButton].centerXAnchor],
		[buttonText.centerYAnchor constraintEqualToAnchor:[[self view] editSnoozeDurationButton].centerYAnchor],
		[buttonText.widthAnchor constraintEqualToAnchor: [[self view] editSnoozeDurationButton].widthAnchor]
	]];
	[buttonText sizeToFit];
	[[self view] updateLabels];
	[self setTitle:@"Snooze Duration"];
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(doneEditing)];
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEditing)];
	[[self navigationItem] setRightBarButtonItem:doneButton];
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/com.arya06.snooze++prefs.plist"]){
		NSURL *prefsPlistURL = [NSURL fileURLWithPath:@"/var/mobile/Library/Preferences/com.arya06.snooze++prefs.plist"];
		NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfURL:prefsPlistURL error:nil];
		id snoozeDuration = [plistDict valueForKey:[self alarmIdentifier]];
		if(snoozeDuration){
			[[self view] setDuration:[snoozeDuration floatValue]];
		}
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
		[prefsDict setObject:@([[self view] getDuration]) forKey:[self alarmIdentifier]];
		[prefsDict writeToURL:prefsPlistURL error:nil];
	}
	else {
		NSMutableDictionary *prefsDict = [[NSMutableDictionary alloc] init];
		[prefsDict setObject:@([[self view] getDuration]) forKey:[self alarmIdentifier]];
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
		[prefsDict removeObjectForKey:[self alarmIdentifier]];
		[prefsDict writeToURL:prefsPlistURL error:nil];
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end