#import <UIKit/UIKit.h>
#import "SNZPPEditView.h"
#import "SNZPPBedtimeAlarmsTableViewController.h"
#import "SNZPPAlarmTableViewCell.h"

@interface UIView (private)
-(void)updateLabels;
-(CGFloat)getDuration;
-(void)setDuration:(CGFloat)duration;
@property (nonatomic, strong, readwrite) UIButton *clearSnoozeDurationButton;
@property (nonatomic, strong, readwrite) MTATimerIntervalPickerView *picker;
@property (nonatomic, strong, readwrite) UIButton *bedtimeAlarmsButton;
@end

@interface SNZPPEditViewController : UIViewController
@property (nonatomic, strong, readwrite) NSString *alarmIdentifier;
@end