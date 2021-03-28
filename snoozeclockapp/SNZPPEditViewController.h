#import <UIKit/UIKit.h>
#import "SNZPPEditView.h"

@interface UIView (private)
-(void)updateLabels;
-(CGFloat)getDuration;
-(void)setDuration:(CGFloat)duration;
@property (nonatomic, strong, readwrite) MTACircleButton *deleteButton;
@property (nonatomic, strong, readwrite) UIButton *editSnoozeDurationButton;
@property (nonatomic, strong, readwrite) MTATimerIntervalPickerView *picker;
@end

@interface SNZPPEditViewController : UIViewController
@property (nonatomic, strong, readwrite) NSString *alarmIdentifier;
@end