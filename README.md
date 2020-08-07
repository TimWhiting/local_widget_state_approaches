
![Flutter Web](https://github.com/TimWhiting/local_widget_state_approaches/workflows/Flutter%20Web/badge.svg)
Demo Link: https://timwhiting.github.io/local_widget_state_approaches/#/
# Widget UI State Logic encaspulation approaches
This project intends to illustrate via several case studies what is difficult when reusing state logic. (Not state) among multiple stateful widgets.

Note that I'm doing this in my spare time, and therefore I can not gurantee timeliness as far as incorporating all different approaches for all examples.

Also, I'm not sure the best name for the respository, so I did my best. I think the header of the Readme might be more instructive as to what these examples will try to demonstrate. Open an issue if you'd like to discuss that. Or we can create a Wiki page about that.

## Getting access
Please request access and respect the other contributors. Make sure you resolve merge conflicts properly, and keep the repository organized. Otherwise, just fork and submit pull request like usual open-source practice. (I'm not sure how many people are wanting to contribute).

## Current Progress
### Approaches
* Stateful - Nothing to add
* Builders - Nothing to add
* LateProperty - Adds registration of callbacks via mixin see this: https://github.com/flutter/flutter/issues/51752#issuecomment-667737471
* Hooks - Using `flutter_hooks` package

### Examples

* Counter Example
  * Hooks: Done
  * Stateful: Done
  * LateProperty: Not Started
  * Builders: Not Started

## Future Work
I intend to keep the examples small like Remi suggests, they should not be full blown apps unless absolutely needed. 

Instead they should be small examples that illustrate a point in reusability of state logics.

(TODO: determine scope and what would make an illustrative examples)
* Setup 404 unimplemented page
* Better navigation
* Highlight navigation for unimplemented pages in a different color
* Animation heavy page 
* Form page
* Use some of Remi's potential examples: https://github.com/flutter/flutter/issues/51752#issuecomment-669626522
* Also this: https://github.com/flutter/flutter/issues/51752#issuecomment-670263627
* Would love to see the code along with the app like flutter gallery's code samples.
