# ServerChanger
A utility class that enables changing BaseURL of app at runtime.
Can be used for other additional runtime purposes as well.

## Introduction
Leave the old time-consuming ways of building and archiving iPA files just for a simple URL change in the app.
Switch to a better, time-efficient way by using ServerChanger and change the urls at runtime  getting away from the hassles of building and archiving.

## Installation
Drag and drop the file into your project folder.
Make sure **Copy Files** is checked and file is added to target.

## About

### Properties
- restartRequired - Boolean property that presents a restart popup when serverChange event occurs. Default is true.
Can be changed from storyboard. Property is IBInspectable.
- hiddenOnProduction - Boolean property that enables visibility of ServerChanger on Production App. By default ServerChanger is only visible on Debug Mode and hidden during Production.
Can be changed from storyboard. Property is IBInspectable.
- selectedURL - Returns the selectedURL from serverChanger. Use it where you want to access the latestURL selected.
Value is optional and may return nil. Try using with nil coalescing operator. See [Usage](#Usage) for example

### ServerChangerEnum
Parent enum of your BaseURL Enum. Must inherit from this enum for ServerChanger to work

    eg. enum MyAppBaseURL: ServerURLString, ServerChangerEnum {
            case production         = "http://prod.com"
            case developmnet        = "http://develop.com"
            case qa                 = "http://qa.com"
            case localhost          = "http://192.168.1.1"
        }

### Methods
- add(title: String, url: ServerURLString) - Adds a single url and urlTitle

```
      eg. serverChanger.add(title: "Local", url: "http://www.local.com")
          serverChanger.add(title: "QA", url: "http://www.qa.com")
```


- add(urls: [...]) - Makes all the url in your enum visible to ServerChanger. Inherit from ServerChangerEnum is mandatory for this method to work

```
      eg.  serverChanger.add(urls: MyAppBaseURL.allURLs)
```

### Observer/Listener
- onServerChange - Observer/Listener fired whenever a server(url) is changed. Can be used to perform any extra operations required.

```
      eg. serverChanger.onServerChange = { urlString in
             //Your custom code
          }
```

## Usage

### Using Storyboard
Drag an UIView to your ViewController.
Change the class of UIView to **ServerChanger** in Identity inspector.
Create **@IBOultet** and access properties and methods.

```
@IBOutlet weak var serverChanger: ServerChanger!
```
In viewDidLoad or any other function, pass urls to ServerChanger
```
serverChanger.add(urls: MyAppBaseURL.allURLs)
```
Access the saved url as
```
let baseURL = ServerChanger.selectedURL ?? "http://www.localhost.com:8080"
```

### Using code
```
let frame = CGRect(x: 0, y:0, width: 175.0, height: 50.0)
let serverChanger = ServerChanger(frame: frame)
serverChanger.add(urls: MyAppBaseURL.allURLs)
```

Access the saved url as
```
let baseURL = ServerChanger.selectedURL ?? "http://www.localhost.com:8080"
```

## Demo

### Restart enabled
![](withRestart.gif)

### Restart Disabled
![](withoutRestart.gif)

## Thank You!
