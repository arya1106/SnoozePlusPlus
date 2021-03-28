#import <UIKit/UIKit.h>

@interface MTATimerIntervalPickerView : UIView
-(void)_updateLabels:(BOOL)arg1;
-(CGFloat)selectedDuration;
-(void)setDuration:(CGFloat)duration;
@end

@interface MTACircleButton : UIButton
@property (nonatomic, assign, readwrite) NSUInteger buttonCircleSize;
@end

@interface SNZPPEditView : UIView
@property (nonatomic, strong, readwrite) MTATimerIntervalPickerView *picker;
@property (nonatomic, strong, readwrite) MTACircleButton *deleteButton;
@property (nonatomic, strong, readwrite) UIButton *editSnoozeDurationButton;
-(void)updateLabels;
-(CGFloat)getDuration;
-(void)setDuration:(CGFloat)duration;
@end
