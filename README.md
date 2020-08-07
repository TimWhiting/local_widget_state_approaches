# Widget UI State Logic encaspulation approaches
This project intends to illustrate via several case studies what is difficult when reusing state logic. (Not state) among multiple stateful widgets.

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
I intend to keep the examples small like Remi suggests, they should not be full blown apps. 

Instead they should be small examples that illuustrate a point in reusability of state logics.

(TODO: determine scope and what would make an illustrative examples)
* Animation heavy page 
* Form page
* Use some of Remi's potential examples: https://github.com/flutter/flutter/issues/51752#issuecomment-669626522
* Also this: https://github.com/flutter/flutter/issues/51752#issuecomment-670263627
