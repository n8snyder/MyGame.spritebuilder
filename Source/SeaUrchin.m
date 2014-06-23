//
//  SeaUrchin.m
//  MyGame
//
//  Created by Nate Snyder on 5/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SeaUrchin.h"

@implementation SeaUrchin

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"seaUrchin";
}
@end