#import "SNZPPAlarmTableViewCell.h"

@implementation SNZPPAlarmTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	self.label = [[NSClassFromString(@"MTUIDigitalClockLabel") alloc] initWithFrame:CGRectMake(10,10,10,10)];
	[[self contentView] addSubview:[self label]];
	[[self label] setTranslatesAutoresizingMaskIntoConstraints:NO];
	[NSLayoutConstraint activateConstraints:@[
		[self.label.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
		[self.label.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
		[self.label.heightAnchor constraintEqualToConstant:72],
	]];
	[[self label] setFont:[UIFont systemFontOfSize:60 weight:UIFontWeightThin]];
	[[self label] setTimeDesignatorFont:[UIFont systemFontOfSize:37 weight:UIFontWeightLight]];
	return self;
}
@end