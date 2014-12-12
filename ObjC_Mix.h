//
//  ObjC_Mix.h
//  class4 hw
//
//  Created by Steven Shatz on 7/26/14.
//  Copyright (c) 2014 Steven Shatz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//---- Global C function ----

float getPI();


//----- Objective-C custom class ---

@interface SimpleObjC : NSObject {
  int randomVal;
}

-(UIColor *) getBackgroundColor;

@end