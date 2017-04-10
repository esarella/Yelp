# Project 2 - *Yelp*

**Yelp** is a Yelp search app using the [Yelp API](http://www.yelp.com/developers/documentation/v2/search_api).

Time spent: **19** hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] Search results page
    - [X] Table rows should be dynamic height according to the content height.
    - [X] Custom cells should have the proper Auto Layout constraints.
    - [X] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
- [X] Filter page. Unfortunately, not all the filters are supported in the Yelp API.
    - [X] The filters you should actually have are: category, sort (best match, distance, highest rated), distance, deals (on/off).
    - [X] The filters table should be organized into sections as in the mock.
    - [X] You can use the default UISwitch for on/off states.
    - [X] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
    - [X] Display some of the available Yelp categories (choose any 3-4 that you want).

The following **optional** features are implemented:

- [ ] Search results page
    - [X] Infinite scroll for restaurant results.
    - [ ] Implement map view of restaurant results.
- [ ] Filter page
    - [ ] Implement a custom switch instead of the default UISwitch.
    - [X] Distance filter should expand as in the real Yelp app
    - [X] Categories should show a subset of the full list with a "See All" row to expand. Category list is [here](http://www.yelp.com/developers/documentation/category_list).
- [ ] Implement the restaurant detail page.

The following **additional** features are implemented:

- [X] Pull to Refresh
- [X] Progress Indicator
- Custom button, and mapview were partially implemented

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1.  If a method has AnyObject as a return type  why does it force me to return all params as anyObject type
    static func distanceOptions() -> [String:AnyObject] {
        return ["name": "Auto" as AnyObject, "meters": maxDistance as AnyObject]
     }

     Why is name being forced to typecast as anyObject when it is a String, is it because it is Part of a dictionary?

2.  I wasted a lot of time on message passing between classes, conforming to the protocol and debugging for errors.
 It felt like I spent a lot of time on the plumbing rather than on the features I would have liked to finish.

  Even though I trust Crusty, I have the following questions

Is protocol oriented programming better than object oriented programming with respect to message passing?
Can we pass objects in a traditional Object orient way (like Java) without using protocols in swift, especially in iOS?

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/O33HzpN.gif' title='Yelp' width='' alt='Yelp' />
<img src='http://i.imgur.com/cmym9Ic.gif' title='Filters' width='' alt='Filters' />
<img src='http://i.imgur.com/iRoQUwH.gif' title='Auto Layout' width='' alt='Auto Layout' />
<img src='http://i.imgur.com/d4nuVgs.gif' title='Experimental incomplete features' width='' alt='Experimental incomplete features' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Passing AnyObject type object with delegate patterns caused a lot of errors. spent most of my time fixing and debugging those.
SevenButton was not easy to use or well documented. I tries to implement my own custom button which I was not able to finish.

## License

Copyright [2017] [Emmanuel Sarella]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
