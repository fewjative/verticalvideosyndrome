#define kBundlePath @"/Library/MobileSubstrate/DynamicLibraries/VVS.bundle"

static BOOL isVert = YES;
static BOOL isVideo = NO;
static BOOL isCapturing = NO;
static BOOL displayed = NO;

%hook PLCameraView

- (BOOL )_isVideoMode:(long long)arg1{

int type = [[UIDevice currentDevice] orientation];
    if (type == 1) {
        //NSLog(@"portrait default");
	isVert = YES;
    }else if(type ==2){
       //NSLog(@"portrait upside");
	isVert = YES;
    }else if(type ==3){
        //NSLog(@"Landscape right");
		isVert = NO;
    }else if(type ==4){
       //NSLog(@"Landscape left");
		isVert = NO;
    }

BOOL r = %orig; 
isVideo = r;
return isVideo; 
}


- (BOOL )isTallScreen { 



int type = [[UIDevice currentDevice] orientation];
    if (type == 1) {
        //NSLog(@"portrait default");
	isVert = YES;
    }else if(type ==2){
        //NSLog(@"portrait upside");
	isVert = YES;
    }else if(type ==3){
        //NSLog(@"Landscape right");
		isVert = NO;
    }else if(type ==4){
        //NSLog(@"Landscape left");
		isVert = NO;
    }

BOOL  r = %orig; 
return r; 
}


- (void)_layoutTopBarForOrientation:(long long)arg1{

%orig;
int type = [[UIDevice currentDevice] orientation];
    if (type == 1) {
        //NSLog(@"portrait default");
	isVert = YES;
    }else if(type ==2){
        //NSLog(@"portrait upside");
	isVert = YES;
    }else if(type ==3){
        //NSLog(@"Landscape right");
		isVert = NO;
    }else if(type ==4){
        //NSLog(@"Landscape left");
		isVert = NO;
    }


   	if(isVert && isVideo && !isCapturing && !displayed)
	{
		NSLog(@"Attach");
		UIView *previewContainerView = MSHookIvar<UIView *>(self, "_previewContainerView");
		 NSLog(@"My view's frame is: %@", NSStringFromCGRect(previewContainerView .frame));

	   	CGRect screenRect = [[UIScreen mainScreen] bounds];
		CGFloat screenWidth = screenRect.size.width;
	   	
	   	NSBundle *bundle = [[[NSBundle alloc] initWithPath:kBundlePath] autorelease];
		NSString *imagePath = [bundle pathForResource:@"Warning" ofType:@"png"];
		UIImage *image = [UIImage imageWithContentsOfFile:imagePath];

		UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
		[imageView setFrame:CGRectMake((screenWidth/2)-(image.size.width/2), 50, imageView.frame.size.width, imageView.frame.size.height)];
		imageView.tag = 818620;
		[previewContainerView addSubview:imageView];
		displayed = YES;
	}
	else
	{
		NSLog(@"Should be removed!");
		displayed = NO;
		UIView *previewContainerView2 = [MSHookIvar<UIView *>(self, "_previewContainerView") viewWithTag:818620];
		if(previewContainerView2 !=nil)
			[previewContainerView2 removeFromSuperview];
	}
    

}


- (BOOL )_isCapturing { 

	BOOL r = %orig; 
	isCapturing = r;

	if(isCapturing)
	{
		NSLog(@"Should be removed!_isCapturing");
		displayed = NO;
		UIView *previewContainerView2 = [MSHookIvar<UIView *>(self, "_previewContainerView") viewWithTag:818620];
		if(previewContainerView2 !=nil)
			[previewContainerView2 removeFromSuperview];
	}
	else
	if(isVert && isVideo && !displayed)
	{
		NSLog(@"Attach");
		UIView *previewContainerView = MSHookIvar<UIView *>(self, "_previewContainerView");
		 NSLog(@"My view's frame is: %@", NSStringFromCGRect(previewContainerView .frame));

	   	
	   	NSBundle *bundle = [[[NSBundle alloc] initWithPath:kBundlePath] autorelease];
		NSString *imagePath = [bundle pathForResource:@"Warning" ofType:@"png"];
		UIImage *image = [UIImage imageWithContentsOfFile:imagePath];

		CGRect screenRect = [[UIScreen mainScreen] bounds];
		CGFloat screenWidth = screenRect.size.width;

		UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
		[imageView setFrame:CGRectMake((screenWidth/2)-(image.size.width/2), 50, imageView.frame.size.width, imageView.frame.size.height)];
		imageView.tag = 818620;
		[previewContainerView addSubview:imageView];
		displayed = YES;
	}


	return isCapturing;
 }

%end


