# Project 2 - *Flix*

**Flix** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **15** hours spent in total

## User Stories

The following **required** functionality is complete:

- [ X ] User can view a list of movies currently playing in theaters from The Movie Database.
- [ X ] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [ X ] User sees a loading state while waiting for the movies API.
- [ X ] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [ X ] User sees an error message when there's a networking error.
- [ X ] Movies are displayed using a CollectionView instead of a TableView.
- [ X ] User can search for a movie.
- [ X ] All images fade in as they are loading.
- [ X ] User can view the large movie poster by tapping on a cell.
- [ ] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [ ] Customize the selection effect of the cell.
- [ ] Customize the navigation bar.
- [ X ] Customize the UI.

The following **additional** features are implemented:

- [ X ] Added a Trailer View so that a Youtube video modal loads when the user clicks the movie poster thumbnail in the Detail View
- [ X ] Placeholder image displayed while images load on home screen
- [ X ] Scrolling description in Detail View for when a movie's overview overflows its UITextBox container

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. What customizations for the UI people thought of
2. Abstracting away large chunks of code that didn't really change between view controllers (e.g. the repetitive network requests)

## Video Walkthrough

<img src='http://imgur.com/download/21hMpd9' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Spent a lot of time trying to get the official Youtube iOS Cocoapod to work, managed to get xCOde to recognize the YTPlayer class by adding a Bridging file, but couldn't get the video to load in the actual UIView element.

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library

## License

Copyright 2017 Michael Wornow

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
