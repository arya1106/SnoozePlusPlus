#import "SNZPPBedtimeAlarmsTableViewController.h"


@implementation SNZPPBedtimeAlarmsTableViewController

-(void)viewDidLoad{
	[super viewDidLoad];
	MTAlarmManager *manager = [[UIApplication sharedApplication] valueForKey:@"_alarmManager"];
	[self setSleepAlarms: [[manager cache] sleepAlarms]];
	[[self navigationItem] setTitle:@"Bedtime Alarms"];
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEditing)];
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(cancelEditing)];
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	[[self navigationItem] setRightBarButtonItem:doneButton];
	[[self tableView] registerClass:[SNZPPAlarmTableViewCell class] forCellReuseIdentifier:@"alarmCell"];
	[[self tableView] setDataSource:self];
	[[self tableView] setDelegate:self];
	[[self tableView] setRowHeight:100];
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
	return [[self sleepAlarms] count];
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath{
	SNZPPAlarmTableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:@"alarmCell" forIndexPath:indexPath];
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
