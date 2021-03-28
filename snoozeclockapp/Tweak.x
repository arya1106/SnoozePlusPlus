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
	[[self editSnoozeDurationButton] addTarget:self action:@selector(showSnoozePlusPlusEditView) forControlEvents:UIControlEventTouchUpInside];
	[[self editSnoozeDurationButton] addTarget:self action:@selector(highlightSnoozePlusPlusButton) forControlEvents:UIControlEventTouchDown];

	UILabel *buttonText = [[UILabel alloc] initWithFrame:CGRectMake(10,10,10,10)];
	[[self editSnoozeDurationButton] addSubview:buttonText];
	[buttonText setText:@"Edit Snooze"];
	[buttonText setTextAlignment:NSTextAlignmentCenter];
	[buttonText setFont:[UIFont systemFontOfSize:15]];
	[buttonText setTextColor:[[[UIApplication sharedApplication] keyWindow] tintColor]];
	[buttonText setTranslatesAutoresizingMaskIntoConstraints:NO];
		[NSLayoutConstraint activateConstraints:@[
		[buttonText.centerXAnchor constraintEqualToAnchor:[self editSnoozeDurationButton].centerXAnchor],
		[buttonText.centerYAnchor constraintEqualToAnchor:[self editSnoozeDurationButton].centerYAnchor],
		[buttonText.widthAnchor constraintEqualToAnchor: [self editSnoozeDurationButton].widthAnchor]
	]];
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
