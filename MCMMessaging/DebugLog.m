//
//  DebugLog.m
//  LasaLara
//
//  Created by Madis Nõmme on 11/4/10.
//  Copyright 2010 Tarkvaraprojekt. All rights reserved.
//

void _DebugLog(BOOL detailedOutput, const char *file, int lineNumber, const char *funcName, NSString *format,...) {
	va_list ap;
	
	va_start (ap, format);
	if (![format hasSuffix: @"\n"]) {
		format = [format stringByAppendingString: @"\n"];
	}
	NSString *body =  [[NSString alloc] initWithFormat: format arguments: ap];
	va_end (ap);
	NSString *fileName=[[NSString stringWithUTF8String:file] lastPathComponent];
	if (detailedOutput == YES) {
		const char *threadName = [[[NSThread currentThread] name] UTF8String];
		if (threadName) {
			fprintf(stderr,"%s/%s (%s:%d) %s",threadName,funcName,[fileName UTF8String],lineNumber,[body UTF8String]);
		} else {
			fprintf(stderr,"%p/%s (%s:%d) %s",[NSThread currentThread],funcName,[fileName UTF8String],lineNumber,[body UTF8String]);
		}
	} else {
		fprintf(stderr,"(%s:%d) %s",[fileName UTF8String],lineNumber,[body UTF8String]);
	}

	
	
	
	[body release];	
}
