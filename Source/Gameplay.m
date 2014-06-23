//
//  Gameplay.m
//  MyGame
//
//  Created by Nate Snyder on 3/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "GameState.h"
static const float MIN_SPEED = 5.f;
@implementation Gameplay {
    CCPhysicsNode *_physicsNode;
    CCNode *_spawnPoint;
    CCNode *_mouseJointNode;
    CCPhysicsJoint *_mouseJoint;
    CCNode *_extraGravityNode;
    CCPhysicsJoint *_extraGravity;
    CCNode *_contentNode;
    CCNode *penguin;
    CGPoint startLocation;
    int numFlaps;
    Boolean applyExtraGravity;
    CCNode *_levelNode;
    Boolean facingRight;
    Boolean isIdle;
    int fishNeededToWin;
    int fishFound;
}


// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // visualize physics bodies & joints
    //_physicsNode.debugDraw = TRUE;
    
    //loads the correct level
    NSString *whichLevel = [[GameState sharedInstance] currentLevel];
    CCScene *level = [CCBReader loadAsScene:whichLevel];
    [_levelNode addChild:level];
    
    numFlaps = 0;
    applyExtraGravity = false;
    facingRight = true;
    isIdle = true;
    if([whichLevel  isEqual: @"Levels/Level1"]){
        fishNeededToWin = 1;
    }
    else if ([whichLevel  isEqual: @"Levels/Level2"]){
        fishNeededToWin = 2;
    }
    else if ([whichLevel  isEqual: @"Levels/Level3"]){
        fishNeededToWin = 3;
    }
    else if ([whichLevel  isEqual: @"Levels/Level4"]){
        fishNeededToWin = 4;
    }
    else if ([whichLevel  isEqual: @"Levels/Level5"]){
        fishNeededToWin = 3;
    }
    else if ([whichLevel  isEqual: @"Levels/Level6"]){
        fishNeededToWin = 4;
    }
    
    fishFound = 0;
    
    
    _physicsNode.collisionDelegate = self;
    
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    // loads the Penguin.ccb we have set up in Spritebuilder
    penguin = [CCBReader load:@"Penguin"];
    penguin.position = ccpAdd(_spawnPoint.position, ccp(100, 100));
    [_physicsNode addChild:penguin];
    
    
    //mouseJointNode will ignore physics
    _mouseJointNode.physicsBody.collisionMask = @[];
    //mouseJointNode will ignore physics
    _extraGravityNode.physicsBody.collisionMask = @[];
    
    // ensure followed object is in visible are when starting
    self.position = ccp(0, 0);
    CCActionFollow *follow = [CCActionFollow actionWithTarget:penguin worldBoundary:self.boundingBox];
    [_contentNode runAction:follow];

}
-(void) back{
    CCScene *menu = [CCBReader loadAsScene:@"LevelSelect"];
    [[CCDirector sharedDirector] replaceScene:menu];
}
- (void)update:(CCTime)delta
{
    // if speed is below minimum speed, assume this attempt is over
    if (ccpLength(penguin.physicsBody.velocity) < MIN_SPEED && numFlaps>0){
        numFlaps = 0;
        return;
    }
    if ((ccpLength(penguin.physicsBody.velocity) < MIN_SPEED) && !isIdle & facingRight){
        CCBAnimationManager* animationManager = penguin.userObject;
        [animationManager runAnimationsForSequenceNamed:@"IdleRight"];
        isIdle = true;
    }
    if ((ccpLength(penguin.physicsBody.velocity) < MIN_SPEED) && !isIdle & !facingRight){
        CCBAnimationManager* animationManager = penguin.userObject;
        [animationManager runAnimationsForSequenceNamed:@"IdleLeft"];
        isIdle = true;
    }
    _extraGravityNode.position = CGPointMake(penguin.position.x, penguin.position.y -50);
    
}
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    startLocation = [touch locationInNode:_contentNode];
    if(numFlaps<3){
        [self releaseExtraGravity];
        _mouseJointNode.position = penguin.position;
        //NSLog(@"touchLocation x: %f", touchLocation.x);
        //NSLog(@"touchLocation y: %f", touchLocation.y);
        _mouseJoint = [CCPhysicsJoint connectedSpringJointWithBodyA:_mouseJointNode.physicsBody bodyB:penguin.physicsBody anchorA:ccp(0,0) anchorB: ccp(0,0) restLength:0.f stiffness:1200.f damping:150.f];
        [self performSelector:@selector(releasePenguin) withObject:nil afterDelay:.3];
    }
}
- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(numFlaps<3){
        CGPoint touchLocation = [touch locationInNode:_contentNode];
        //NSLog(@"%f + %f - %f = %f", _mouseJointNode.position.x, touchLocation.x, startLocation.x, _mouseJointNode.position.x + touchLocation.x - startLocation.x);
    
        float bound=30;
        double dx = (touchLocation.x-startLocation.x);
        double dy = (touchLocation.y-startLocation.y);
        double dist = sqrt(dx*dx + dy*dy);
        if(dist<bound){
            _mouseJointNode.position = CGPointMake(_mouseJointNode.position.x + dx,
                                               _mouseJointNode.position.y + dy);
        }
        if(dist>=bound){
            NSLog(@"too far");
            _mouseJointNode.position = CGPointMake(_mouseJointNode.position.x + (bound)*dx/dist,
                                               _mouseJointNode.position.y + (bound)*dy/dist);
        }
        //NSLog(@"%f and %f",penguin.position.x,touchLocation.x);
        if(penguin.position.x>_mouseJointNode.position.x) //This is when the penguin will be moving to the left
        {
            if(facingRight || isIdle){
                CCBAnimationManager* animationManager = penguin.userObject;
                [animationManager runAnimationsForSequenceNamed:@"FlyingLeft"];
                facingRight=false;
                isIdle = false;
            }
        }
        else //This is when the penguin will be moving to the right
        {
            if(!facingRight || isIdle){
                CCBAnimationManager* animationManager = penguin.userObject;
                [animationManager runAnimationsForSequenceNamed:@"FlyingRight"];
                facingRight=true;
                isIdle = false;
            }
        }
        startLocation = touchLocation;
    }
    
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if(numFlaps<3){
        [self releasePenguin];
    }
}
-(void) releasePenguin{
    if(applyExtraGravity==false){
        applyExtraGravity = true;
        _extraGravity = [CCPhysicsJoint connectedSpringJointWithBodyA:_extraGravityNode.physicsBody bodyB:penguin.physicsBody anchorA:ccp(0,0) anchorB: ccp(0,0) restLength:0.f stiffness:200.f damping:150.f];
        [self performSelector:@selector(releaseExtraGravity) withObject:nil afterDelay:.6];
    }
    
    if (_mouseJoint != nil)
    {
        [_mouseJoint invalidate];
        _mouseJoint = nil;
        numFlaps=numFlaps+1;
    }
}
-(void) releaseExtraGravity{
    
    if (_extraGravity != nil && applyExtraGravity==true)
    {
        NSLog(@"release");
        [_extraGravity invalidate];
        _extraGravity = nil;
        applyExtraGravity = false;
    }
}
-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
     [self releaseExtraGravity];
}
-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair fish:(CCNode *)nodeA wildcard:(CCNode *)nodeB
{
    float energy = [pair totalKineticEnergy];
    
    if (energy > 50.f)
    {
        // load particle effect
        CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"FishExplosion"];
        // make the particle effect clean itself up, once it is completed
        explosion.autoRemoveOnFinish = TRUE;
        // place the particle effect on the fish position
        explosion.position = nodeA.position;
        // add the particle effect to the same node the fish is on
        [nodeA.parent addChild:explosion];
        
        // finally, remove the destroyed seal
        [nodeA removeFromParent];
        fishFound = fishFound +1;
        if(fishFound==fishNeededToWin){
            [self performSelector:@selector(winning) withObject:nil afterDelay:.6];
        }
    }
}
-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair seaUrchin:(CCNode *)nodeA wildcard:(CCNode *)nodeB{
    float energy = [pair totalKineticEnergy];
    
    if (energy > 50.f)
    {
        // load particle effect
        CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"PenguinExplosion"];
        // make the particle effect clean itself up, once it is completed
        explosion.autoRemoveOnFinish = TRUE;
        // place the particle effect on the fish position
        explosion.position = nodeB.position;
        // add the particle effect to the penguin
        [nodeB.parent addChild:explosion];
        numFlaps = 5;
        penguin.physicsBody.collisionMask = @[];
        [self performSelector:@selector(losing) withObject:nil afterDelay:1];
    }
}
-(void) winning{
    NSLog(@"#WINNING");
    float rNumber = (arc4random() % 2000) / 1000.f;
    int randomNumber = (int)rNumber;
    NSLog(@"%i",randomNumber);
    if(randomNumber==0){
        CCScene *winningScene = [CCBReader loadAsScene:@"Winning"];
        [[CCDirector sharedDirector] replaceScene:winningScene];
    }
    else if (randomNumber==1){
        CCScene *winningScene = [CCBReader loadAsScene:@"Winning2"];
        [[CCDirector sharedDirector] replaceScene:winningScene];

    }
    
}
-(void) losing{
    NSLog(@"#LOSING");
    CCScene *menu = [CCBReader loadAsScene:@"LevelSelect"];
    [[CCDirector sharedDirector] replaceScene:menu];
}
@end
