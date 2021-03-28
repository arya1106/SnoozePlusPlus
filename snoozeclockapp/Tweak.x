#import <UIKit/UIKit.h>
#import "SNZPPEditViewController.h"

@interface MTAlarm
-(NSString*)identifier;
@end

@interface MTAAlarmEditViewController : UIViewController
@property (nonatomic, strong, readwrite) MTAlarm *editedAlarm;
@property (nonatomic, strong, readwrite) UIButton *editSnoozeDurationButton;
@end

@interface SNZPPClockTimePickerView : UIPickerView
@end

@interface MTAAlarmTableViewController : UIViewController
@property (nonatomic, strong, readwrite) UIButton *globalSettingsButton;
@end

%hook MTAAlarmEditViewController

%property (nonatomic, strong) UIButton *editSnoozeDurationButton;

-(void)viewDidLoad{
	%orig;

	self.editSnoozeDurationButton = [[UIButton alloc] initWithFrame:CGRectMake(10,10,10,10)];
	[[self view] addSubview:[self editSnoozeDurationButton]];
	[[self editSnoozeDurationButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
	[NSLayoutConstraint activateConstraints:@[
		[[self editSnoozeDurationButton].trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
		[[self editSnoozeDurationButton].topAnchor constraintEqualToAnchor:self.view.topAnchor constant:94],
		[[self editSnoozeDurationButton].widthAnchor constraintEqualToConstant:100],
		[[self editSnoozeDurationButton].heightAnchor constraintEqualToConstant:30],
	]]; 
	[[self editSnoozeDurationButton] setBackgroundColor:[UIColor tertiarySystemBackgroundColor]];
	[[[self editSnoozeDurationButton] layer] setCornerRadius: 8];
	[[[self editSnoozeDurationButton] layer] setCornerCurve: kCACornerCurveContinuous];
	[[self editSnoozeDurationButton] setTitle:@"Edit Snooze" forState:UIControlStateNormal];
	[[self editSnoozeDurationButton] setTitleColor:[[[UIApplication sharedApplication] keyWindow] tintColor] forState:UIControlStateNormal];
	[[[self editSnoozeDurationButton] titleLabel] setFont:[UIFont systemFontOfSize:15]];
	[[self editSnoozeDurationButton] addTarget:self action:@selector(showSnoozePlusPlusEditView) forControlEvents:UIControlEventTouchUpInside];
	[[self editSnoozeDurationButton] addTarget:self action:@selector(highlightSnoozePlusPlusButton) forControlEvents:UIControlEventTouchDown];
}

%new
-(void)highlightSnoozePlusPlusButton{
	[[self editSnoozeDurationButton] setAlpha:0.5];
}

%new
-(void)showSnoozePlusPlusEditView{
	[[self editSnoozeDurationButton] setAlpha:1];
	SNZPPEditViewController *myVC = [[SNZPPEditViewController alloc] init];
	UINavigationController *myNC = [[UINavigationController alloc] initWithRootViewController:myVC];
	[myVC setAlarmIdentifier:[[self editedAlarm] identifier]];
	[self presentViewController:myNC animated:YES completion:nil];
}
%end

%hook MTAAlarmTableViewController

%property (nonatomic, strong) UIButton *globalSettingsButton;

-(id)tableView:(id)arg1 viewForHeaderInSection:(NSInteger)arg2{
	UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView*) %orig;
	if(arg1 == 0){
		return nil;
	}
	NSLog(@"TESTING %ld", arg2);
	if(arg2 == 1){
		self.globalSettingsButton = [[UIButton alloc] initWithFrame:CGRectMake(10,10,10,10)];
		[[self globalSettingsButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
		[[headerView contentView] addSubview:[self globalSettingsButton]];
		[[[self globalSettingsButton] layer] setCornerRadius:15];
		[[self globalSettingsButton] setBackgroundColor:[UIColor secondarySystemBackgroundColor]];
		[NSLayoutConstraint activateConstraints:@[
			[[self globalSettingsButton].leadingAnchor constraintEqualToAnchor:headerView.leadingAnchor constant:80],
			[[self globalSettingsButton].centerYAnchor constraintEqualToAnchor:headerView.centerYAnchor],
			[[self globalSettingsButton].widthAnchor constraintEqualToConstant:100],
			[[self globalSettingsButton].heightAnchor constraintEqualToConstant:30],
		]];
		[[self globalSettingsButton] setTitle:@"thing" forState:UIControlStateNormal];
		[[self globalSettingsButton] setTitleColor:[[[UIApplication sharedApplication] keyWindow] tintColor] forState:UIControlStateNormal];
		[[[self globalSettingsButton] titleLabel] setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightBold]];
		[[self globalSettingsButton] addTarget:self action:@selector(showSnoozePlusPlusEditView) forControlEvents:UIControlEventTouchUpInside];
		[[self globalSettingsButton] addTarget:self action:@selector(highlightSnoozePlusPlusButton) forControlEvents:UIControlEventTouchDown];
		return headerView;
	}
	else return headerView;
}

%new
-(void)highlightSnoozePlusPlusButton{
	[[self globalSettingsButton] setAlpha:0.5];
}

%new
-(void)showSnoozePlusPlusEditView{
	[[self globalSettingsButton] setAlpha:1];
	SNZPPEditViewController *myVC = [[SNZPPEditViewController alloc] init];
	UINavigationController *myNC = [[UINavigationController alloc] initWithRootViewController:myVC];
	[self presentViewController:myNC animated:YES completion:nil];
}
%end