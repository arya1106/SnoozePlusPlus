#import <UIKit/UIKit.h>

@interface MTATimerIntervalPickerView : UIView
-(void)_updateLabels:(BOOL)arg1;
-(CGFloat)selectedDuration;
-(void)setDuration:(CGFloat)duration;
@end

@interface SNZPPEditView : UIView
@property (nonatomic, strong, readwrite) MTATimerIntervalPickerView *picker;
@property (nonatomic, strong, readwrite) UIButton *clearSnoozeDurationButton;
@property (nonatomic, strong, readwrite) UIButton *bedtimeAlarmsButton;
-(void)updateLabels;
-(CGFloat)getDuration;
-(void)setDuration:(CGFloat)duration;
@end
