//
//  ObjC_Mix.m
//  class4 hw
//
//  Created by Steven Shatz on 7/26/14.
//  Copyright (c) 2014 Steven Shatz. All rights reserved.
//

#include "ObjC_Mix.h"


float getPI () {
  return (float)M_PI;
}

@implementation SimpleObjC

-(UIColor *) getBackgroundColor {
  
  return [UIColor colorWithRed:0.7 green:0.7 blue:1.0 alpha:1.0];
}

-(void) dealloc {
  NSLog(@"SimpleObjC object with randomVal = %d deallocated",randomVal);
}

@end