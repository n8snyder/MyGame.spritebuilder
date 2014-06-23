//
//  LevelSelect.m
//  MyGame
//
//  Created by Nate Snyder on 4/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelSelect.h"
#import "GameState.h"

@implementation LevelSelect{
    int _selectedLevel;
    NSArray *_levels;
}
-(void) level1{
    [[GameState sharedInstance] setCurrentLevel:@"Levels/Level1"];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}
-(void) level2{
    [[GameState sharedInstance] setCurrentLevel:@"Levels/Level2"];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}
-(void) level3{
    [[GameState sharedInstance] setCurrentLevel:@"Levels/Level3"];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}
-(void) level4{
    [[GameState sharedInstance] setCurrentLevel:@"Levels/Level4"];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}
-(void) level5{
    [[GameState sharedInstance] setCurrentLevel:@"Levels/Level5"];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}
-(void) level6{
    [[GameState sharedInstance] setCurrentLevel:@"Levels/Level6"];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}
-(void) instructions{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Instructions1"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}
-(void) title{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}


@end
