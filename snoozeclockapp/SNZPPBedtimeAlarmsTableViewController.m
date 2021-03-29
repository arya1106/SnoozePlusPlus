#import "SNZPPBedtimeAlarmsTableViewController.h"
#import "SNZPPEditViewController.h"
#import "MTAlarm.h"

@interface MTAlarmCache
@property (nonatomic, strong, readwrite) NSMutableArray *sleepAlarms;
@end

@interface MTAlarmManager
@property (nonatomic, strong, readwrite) MTAlarmCache* cache;
@end

@interface MTUIDigitalClockLabel : UIView
@property (nonatomic, strong, readwrite) UIFont* font;
@property (nonatomic, strong, readwrite) UIFont* timeDesignatorFont;
-(void)forceSetHour:(NSInteger)arg1 minute:(NSInteger)arg2;
@end

@interface MyCell : UITableViewCell
@property (nonatomic, strong, readwrite) MTUIDigitalClockLabel *label;
@end

@implementation MyCell
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

#import "SNZPPBedtimeAlarmsTableViewController.h"

@implementation SNZPPBedtimeAlarmsTableViewController

-(void)viewDidLoad{
	[super viewDidLoad];
	MTAlarmManager *manager = [[UIApplication sharedApplication] valueForKey:@"_alarmManager"];
	[self setSleepAlarms: [[manager cache] sleepAlarms]];
	[[self navigationItem] setTitle:@"Bedtime Alarms"];
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEditing)];
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	[[self tableView] registerClass:NSClassFromString(@"MyCell") forCellReuseIdentifier:@"myCell"];
	[[self tableView] setDataSource:self];
	[[self tableView] setDelegate:self];
	[[self tableView] setRowHeight:100];
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
	return [[self sleepAlarms] count];
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath{
	MyCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
	MTAlarm *alarm = [[self sleepAlarms] objectAtIndex:[indexPath row]];
	[[cell label] forceSetHour:[alarm hour] minute:[alarm minute]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString* alarmIdentifier = [[[self sleepAlarms] objectAtIndex:[indexPath row]] identifier];
	SNZPPEditViewController *editVC = [[SNZPPEditViewController alloc] init];
	UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:editVC];
	[editVC setAlarmIdentifier:alarmIdentifier];
	[self presentViewController:navigationVC animated:YES completion:nil];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)cancelEditing{
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
