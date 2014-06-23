//
//  Instructions1.m
//  MyGame
//
//  Created by Nate Snyder on 5/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Instructions2.h"

@implementation Instructions2

- (void)didLoadFromCCB{
    NSLog(@"loaded page2");
    self.userInteractionEnabled = TRUE;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CCScene *nextPage = [CCBReader loadAsScene:@"LevelSelect"];
    [[CCDirector sharedDirector] replaceScene:nextPage];
}
@end