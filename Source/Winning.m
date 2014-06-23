//
//  Winning.m
//  MyGame
//
//  Created by Nate Snyder on 4/19/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Winning.h"

@implementation Winning
- (void)didLoadFromCCB{
    self.userInteractionEnabled = TRUE;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CCScene *menu = [CCBReader loadAsScene:@"LevelSelect"];
    [[CCDirector sharedDirector] replaceScene:menu];
}
@end