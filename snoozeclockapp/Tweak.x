#import <UIKit/UIKit.h>
#import "SNZPPEditViewController.h"

@interface MTAAlarmEditViewController : UIViewController
@property (nonatomic, strong, readwrite) MTAlarm *editedAlarm;
@property (nonatomic, strong, readwrite) UIButton *editSnoozeDurationButton;
@property (nonatomic, strong, readwrite) UIDatePicker *timePicker;
@end

@interface SNZPPClockTimePickerView : UIPickerView
@end

@interface MTAAlarmTableViewController : UIViewController
@property (nonatomic, strong, readwrite) UIButton *globalSettingsButton;
@end

@interface NSLocale (private)
-(BOOL)mtIsIn24HourTime;
@end

BOOL isiOS14, hasAlarmGroups;

%hook MTAAlarmEditViewController

%property (nonatomic, strong) UIButton *editSnoozeDurationButton;

-(void)viewDidLoad{
	%orig;

	self.editSnoozeDurationButton =  [UIButton buttonWithType:UIButtonTypeSystem];
	[[self view] addSubview:[self editSnoozeDurationButton]];
	[[self editSnoozeDurationButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
	if(!isiOS14){
		[NSLayoutConstraint activateConstraints:@[
			[[self editSnoozeDurationButton].trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
			[[self editSnoozeDurationButton].topAnchor constraintEqualToAnchor:self.view.topAnchor constant:93],
			[[self editSnoozeDurationButton].widthAnchor constraintEqualToConstant:100],
			[[self editSnoozeDurationButton].heightAnchor constraintEqualToConstant:30],
		]];
	} 
	else if ([[[self timePicker] locale] mtIsIn24HourTime]){
		[NSLayoutConstraint activateConstraints:@[
			[[self editSnoozeDurationButton].trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-102],
			[[self editSnoozeDurationButton].topAnchor constraintEqualToAnchor:self.view.topAnchor constant:48.33],
			[[self editSnoozeDurationButton].widthAnchor constraintEqualToConstant:100],
			[[self editSnoozeDurationButton].heightAnchor constraintEqualToConstant:36.33],
		]];
	}
	else{
		[NSLayoutConstraint activateConstraints:@[
			[[self editSnoozeDurationButton].trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
			[[self editSnoozeDurationButton].topAnchor constraintEqualToAnchor:self.view.topAnchor constant:94],
			[[self editSnoozeDurationButton].widthAnchor constraintEqualToConstant:100],
			[[self editSnoozeDurationButton].heightAnchor constraintEqualToConstant:30],
		]];
	}
	[[self editSnoozeDurationButton] setBackgroundColor:[UIColor tertiarySystemBackgroundColor]];
	[[[self editSnoozeDurationButton] layer] setCornerRadius: 8];
	[[[self editSnoozeDurationButton] layer] setCornerCurve: kCACornerCurveContinuous];
	[[self editSnoozeDurationButton] setTitle:@"Edit Snooze" forState:UIControlStateNormal];
	[[self editSnoozeDurationButton] setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
	[[[self editSnoozeDurationButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
	[[self editSnoozeDurationButton] setTitleColor:[[[UIApplication sharedApplication] keyWindow] tintColor] forState:UIControlStateNormal];
	[[[self editSnoozeDurationButton] titleLabel] setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]];
	[[self editSnoozeDurationButton] addTarget:self action:@selector(showSnoozePlusPlusEditView) forControlEvents:UIControlEventTouchUpInside];
}

%new
-(void)showSnoozePlusPlusEditView{
	[[self editSnoozeDurationButton] setAlpha:1];
	SNZPPEditViewController *editVC = [[SNZPPEditViewController alloc] init];
	UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:editVC];
	[editVC setAlarmIdentifier:[[self editedAlarm] identifier]];
	[self presentViewController:navigationVC animated:YES completion:nil];
}
%end

%hook MTAAlarmTableViewController

-(void)dataSourceDidReload:(id)dataSource{
	%orig;
	if(isiOS14) return;
	if([[[self navigationItem] leftBarButtonItems] count] > 1) return;
	NSMutableArray *leftButtons = [[[self navigationItem] leftBarButtonItems] mutableCopy];
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Set Snooze" style:UIBarButtonItemStylePlain target:self action:@selector(showSnoozePlusPlusEditView)];
	[leftButtons addObject:cancelButton];
	[[self navigationItem] setLeftBarButtonItems:[leftButtons copy]];
}

%property (nonatomic, strong) UIButton *globalSettingsButton;

-(id)tableView:(id)arg1 viewForHeaderInSection:(NSInteger)arg2{
	UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView*) %orig;
	if(!isiOS14) return headerView;
	if(hasAlarmGroups){	
		if(arg2 == 2){
			self.globalSettingsButton = [UIButton buttonWithType:UIButtonTypeSystem];
			[[self globalSettingsButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
			[[headerView contentView] addSubview:[self globalSettingsButton]];
			[[[self globalSettingsButton] layer] setCornerRadius:15];
			[[self globalSettingsButton] setBackgroundColor:[UIColor secondarySystemBackgroundColor]];
			[NSLayoutConstraint activateConstraints:@[
				[[self globalSettingsButton].trailingAnchor constraintEqualToAnchor:headerView.trailingAnchor constant:-8],
				[[self globalSettingsButton].centerYAnchor constraintEqualToAnchor:headerView.centerYAnchor],
				[[self globalSettingsButton].widthAnchor constraintEqualToConstant:100],
				[[self globalSettingsButton].heightAnchor constraintEqualToConstant:30],
			]];
			[[self globalSettingsButton] setTitle:@"Set Snooze" forState:UIControlStateNormal];
			[[self globalSettingsButton] setTitleColor:[[[UIApplication sharedApplication] keyWindow] tintColor] forState:UIControlStateNormal];
			[[[self globalSettingsButton] titleLabel] setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightBold]];
			[[self globalSettingsButton] addTarget:self action:@selector(showSnoozePlusPlusEditView) forControlEvents:UIControlEventTouchUpInside];
			return headerView;
		}
		else return headerView;
	}
	else {
		if(arg2 == 1){
			self.globalSettingsButton = [UIButton buttonWithType:UIButtonTypeSystem];
			[[self globalSettingsButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
			[[headerView contentView] addSubview:[self globalSettingsButton]];
			[[[self globalSettingsButton] layer] setCornerRadius:15];
			[[self globalSettingsButton] setBackgroundColor:[UIColor secondarySystemBackgroundColor]];
			[NSLayoutConstraint activateConstraints:@[
				[[self globalSettingsButton].trailingAnchor constraintEqualToAnchor:headerView.trailingAnchor constant:-8],
				[[self globalSettingsButton].centerYAnchor constraintEqualToAnchor:headerView.centerYAnchor],
				[[self globalSettingsButton].widthAnchor constraintEqualToConstant:100],
				[[self globalSettingsButton].heightAnchor constraintEqualToConstant:30],
			]];
			[[self globalSettingsButton] setTitle:@"Set Snooze" forState:UIControlStateNormal];
			[[self globalSettingsButton] setTitleColor:[[[UIApplication sharedApplication] keyWindow] tintColor] forState:UIControlStateNormal];
			[[[self globalSettingsButton] titleLabel] setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightBold]];
			[[self globalSettingsButton] addTarget:self action:@selector(showSnoozePlusPlusEditView) forControlEvents:UIControlEventTouchUpInside];
			return headerView;
		}
		else return headerView;
	}
}

%new
-(void)showSnoozePlusPlusEditView{
	[[self globalSettingsButton] setAlpha:1];
	SNZPPEditViewController *editVC = [[SNZPPEditViewController alloc] init];
	UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:editVC];
	[self presentViewController:navigationVC animated:YES completion:nil];
}
%end

%ctor {
	isiOS14 = [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){.majorVersion = 14, .minorVersion = 0, .patchVersion = 0}];
	hasAlarmGroups = [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/AlarmGroups.dylib"];
}