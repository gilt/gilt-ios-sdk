Gilt API SDK for iOS
====================

This SDK provides wraps the Gilt Groupe public developer API. Our goal is to abstract the low level API details and nuances so that you can concentrate on creating awesome apps with our data!

The API Token
-------------
* * *
### Obtaining An Token ###
A free API token is required to use the API. Register for one at (https://dev.gilt.com/user/register)

Installation
------------
* * *
### Prerequisites ###
 - Xcode 4 (http://developer.apple.com/devcenter/ios/index.action)
 - Git (http://git-scm.com/)
 - Mac OSX Snow Leopard newer
 - The SDK
   - Grab the source with `git clone git@github.com:gilt/gilt-ios-sdk.git`
   - Just the static library [here](https://github.com/gilt/gilt-ios-sdk/downloads)

### Setting Up Your Project
Open Xcode and create a new project using one of the iOS application project templates.

In other to use the SDK, you will need to add it to your project. This can be easily accomplished in a few different ways:
  - Drag the `gilt-ios-sdk/ApiLib/ApiLib` folder into your project (this will compile the entire library)
  - Create a new workspace. Add your project and the XCode project under gilt-ios-sdk/ApiLib
  - Drag the two precompiled static libraries into the `frameworks` folder of your project and add them to the `Linked Libraries` setting of your build target

### Storing Your Token ###
Integrating an API token can be done in three ways:

 - Info.plist - Add the token as a `string` value with the key name `GiltApiKey` to your project's `Info.plist` file.
 - GiltApi.plist - Add the token to a new property list file named `GiltApi.plist` in your project's main bundle.
 - Programatically - Set the API token at runtime like this `[GiltApi sharedInstance].apiKey = @"YOUR KEY";` before using the GiltApi methods.

### Modifying The Application Delegate ###
 1. Import the SDK classes<br/>
    Add the following line to the top of your application delegate source file (MyAppDelegate.m)


	\#import "GiltApi.h"

 2. Retrieve a list of sales<br/>


	NSError *error = nil;
	NSArray *sales = [GiltSalesClient fetchSynchronousForStore:GiltEveryStore upcomingSales:YES timeout:30.0 error:&error];
	if (!error) {
		for (GiltSale *sale in sales) {
			NSLog("Got sale [%@] with %d products.", sale.name, [sale.products count]);
		}
	}
	else {
		NSLog("An error has occurred %@", error);
	}
	
 3. Check out the demo app for comprehensive examples!
 
 4. Create something really cool

 5. Tell us about your project

Demo App
--------
* * *
The SDK source includes a comprehensive iOS demo application that emulates a complete shopping experience. This app is demonstrates how to obtain and display a display a list of sales grouped by store, display products in a specific sale, and display product details including "view on Gilt" referral links. Copying from this project is encouraged in the hope that it may take some tedious work off your plate.

### Running The Demo ###
 - Add your API token to `~/gilt-ios-sdk/KitchenSink/KitchenSink/GiltApi.plist`.
 - Open the project `open ~/gilt-ios-sdk/KitchenSink/KitchenSink.xcodeproj`.
 - Choose "Kitchen Sink \[Debug\] iPhone Simator" from the build scheme list. 
 - Press Command+R to build & run the project.

Gilt API Details & Developer Program
------------------------------------
* * *
Additional details about the Gilt API, Developer Program and other SDKs can be found at the [Gilt Groupe Developer Center](https://dev.gilt.com/).

Be sure to check out Gilt Groupe's [other great public projects](https://github.com/gilt/) on GitHub.

Contributing
------------
See a bug? Think you can do this better than us? Show us! Your contributions and feed back are always welcome.
 1. [Fork this repository](http://help.github.com/fork-a-repo/)
 2. Make changes to your repository. Be sure to add/edit the tests if you change the ApiLib.
 3. [Send us a pull request](http://help.github.com/send-pull-requests/) when you're satisfied with your changes
 4. Follow us [Adam Kaplan](https://github.com/users/follow?target=adamkaplan) and [Louis Vera](https://github.com/users/follow?target=louoso)

Feedback
--------
There are several ways to get in touch with us. If you've found a bug, please [open an issue](https://github.com/gilt/gilt-ios-sdk/issues). It'd also be nice if you fixed the issue too, if you can. Alternatively, you can contact [@GiltTech on Twitter](http://www.twitter.com/gilttech).

License
--------
Except as otherwise noted, the Gilt iOS SDK is licensed under the Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0.html)