//
//  Fish.m
//  MyGame
//
//  Created by Nate Snyder on 4/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Fish.h"

@implementation Fish
- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"fish";
}
@end