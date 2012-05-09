//
//  KeyEventEmulatorPlugIn.h
//  KeyEventEmulator
//
//  Created by Brad Orego on 5/8/12.
//  Copyright (c) 2012 ZD Studios, Inc. All rights reserved.
//

#import <Quartz/Quartz.h>

@interface KeyEventEmulatorPlugIn : QCPlugIn{}

// Declare here the properties to be used as input and output ports for the plug-in e.g.

@property(assign) NSString* inputCharacter;
@property(assign) BOOL inputShift;
@property(assign) BOOL inputFunction;
@property(assign) BOOL inputControl;
@property(assign) BOOL inputOption;
@property(assign) BOOL inputCommand;
@property(assign) BOOL inputTrigger;

@end