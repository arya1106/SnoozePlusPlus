#import <UIKit/UIKit.h>

@interface MTUIDigitalClockLabel : UIView
@property (nonatomic, strong, readwrite) UIFont* font;
@property (nonatomic, strong, readwrite) UIFont* timeDesignatorFont;
-(void)forceSetHour:(NSInteger)arg1 minute:(NSInteger)arg2;
@end

@interface SNZPPAlarmTableViewCell : UITableViewCell
@property (nonatomic, strong, readwrite) MTUIDigitalClockLabel *label;
@end
