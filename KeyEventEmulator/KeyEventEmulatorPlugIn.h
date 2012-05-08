//
//  KeyEventEmulatorPlugIn.h
//  KeyEventEmulator
//
//  Created by Brad Orego on 5/8/12.
//  Copyright (c) 2012 ZD Studios, Inc. All rights reserved.
//

#import <Quartz/Quartz.h>

@interface KeyEventEmulatorPlugIn : QCPlugIn{
    int previousASCII,currentASCII;
    int previousShift, currentShift;
    int previousFunction, currentFunction;
    int previousControl, currentControl;
    int previousOption, currentOption;
    int previousCommand, currentCommand;
}

// Declare here the properties to be used as input and output ports for the plug-in e.g.

@property(assign) NSString* inputCharacter;
@property(assign) NSString* inputShift;
@property(assign) NSString* inputFunction;
@property(assign) NSString* inputControl;
@property(assign) NSString* inputOption;
@property(assign) NSString* inputCommand;
@property(assign) NSString* outputText;

@end