#import <UIKit/UIKit.h>
#import "MTAlarm.h"

@interface MTAlarmCache
@property (nonatomic, strong, readwrite) NSMutableArray *sleepAlarms;
@property (nonatomic, strong, readwrite) MTAlarm *sleepAlarm;
@end

@interface MTAlarmManager
@property (nonatomic, strong, readwrite) MTAlarmCache* cache;
@end

@interface SNZPPBedtimeAlarmsTableViewController : UITableViewController
@property(nonatomic, strong, readwrite) NSArray *sleepAlarms;
@end

#import "SNZPPAlarmTableViewCell.h"
#import "SNZPPBedtimeAlarmsTableViewController.h"
#import "SNZPPEditViewController.h"
#import "MTAlarm.h"

