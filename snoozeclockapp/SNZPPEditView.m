#import "SNZPPEditView.h"

@implementation SNZPPEditView
-(void)updateLabels{
	[[self picker] _updateLabels:YES];
}

-(CGFloat)getDuration{
	return [[self picker] selectedDuration];
}

-(void)setDuration:(CGFloat)duration{
	[[self picker] setDuration:duration];
}


@end