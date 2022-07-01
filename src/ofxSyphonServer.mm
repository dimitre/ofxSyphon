/*
 *  ofxSyphonServer.cpp
 *  syphonTest
 *
 *  Created by astellato,vade,bangnoise on 11/6/10.
 *
 *  http://syphon.v002.info/license.php
 */

#include "ofxSyphonServer.h"
#import <Syphon/Syphon.h>

ofxSyphonServer::ofxSyphonServer()
{
	mSyphon = nil;
}

ofxSyphonServer::~ofxSyphonServer()
{
//    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	@autoreleasepool {
		[(__bridge SyphonOpenGLServer *)mSyphon stop];
//		[mSyphon stop];
//		[(SyphonOpenGLServer *)mSyphon release];
	}
//    [pool drain];
}


void ofxSyphonServer::setName(const std::string &n)
{
//    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	@autoreleasepool {
		NSString *title = [NSString stringWithCString:n.c_str()
										 encoding:[NSString defaultCStringEncoding]];
	
		if (!mSyphon)
		{
			mSyphon = (__bridge void*)[[SyphonOpenGLServer alloc] initWithName:title context:CGLGetCurrentContext() options:nil];
		}
		else
		{
			[(__bridge SyphonOpenGLServer *)mSyphon setName:title];
		}
	}
//    [pool drain];
}

std::string ofxSyphonServer::getName()
{
	std::string name;
	if (mSyphon)
	{
		
		@autoreleasepool {
			//		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        
			name = [[(__bridge SyphonOpenGLServer *)mSyphon name] cStringUsingEncoding:[NSString defaultCStringEncoding]];
		}
//		[pool drain];
	}
	else
	{
		name = "Untitled";
	}
	return name;
}

void ofxSyphonServer::publishScreen()
{
	int w = ofGetWidth();
	int h = ofGetHeight();
	
	ofTexture tex;
	tex.allocate(w, h, GL_RGBA);
	
	tex.loadScreenData(0, 0, w, h);
    
	this->publishTexture(&tex);
	
	tex.clear();
}


void ofxSyphonServer::publishTexture(ofTexture* inputTexture)
{
    // If we are setup, and our input texture
	NSLog (@"before isallocated");
	if(inputTexture->isAllocated())
    {
//        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		NSLog (@"isallocated");
		@autoreleasepool {
			ofTextureData texData = inputTexture->getTextureData();
			
			if (!mSyphon)
			{
				mSyphon = (__bridge void*)[[SyphonOpenGLServer alloc] initWithName:@"Untitled" context:CGLGetCurrentContext() options:nil];
			}
			
			[(__bridge SyphonOpenGLServer *)mSyphon publishFrameTexture:texData.textureID textureTarget:texData.textureTarget imageRegion:NSMakeRect(0, 0, texData.width, texData.height) textureDimensions:NSMakeSize(texData.width, texData.height) flipped:!texData.bFlipTexture];
		}
//        [pool drain];
    }
    else
    {
		cout<<"ofxSyphonServer texture is not properly backed.  Cannot draw.\n";
	}
}

void ofxSyphonServer::publishTexture(GLuint id, GLenum target, GLsizei width, GLsizei height, bool isFlipped)
{
	
	//    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	@autoreleasepool {
    
		if (!mSyphon)
		{
			mSyphon = (__bridge void *)[[SyphonOpenGLServer alloc] initWithName:@"Untitled" context:CGLGetCurrentContext() options:nil];
		}
		
		[(__bridge SyphonOpenGLServer *)mSyphon publishFrameTexture:id textureTarget:target imageRegion:NSMakeRect(0, 0, width, height) textureDimensions:NSMakeSize(width, height) flipped:!isFlipped];
	}
//    [pool drain];
    
}
