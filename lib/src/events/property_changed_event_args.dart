// Copyright (c) 2012, John Evans
// https://github.com/prujohn/DartNet-Event-Model
// See LICENSE file for Apache 2.0 licensing information.

/**
* Defines event information for property changing event types.
*
* ## See Also
* * [FrameworkPropertyBase]
* * [FrameworkProperty]
* * [AttachedFrameworkProperty]
*/
class PropertyChangingEventArgs extends EventArgs
{
   /// holds the previous value of the [FrameworkPropertyBase].
   final Dynamic oldValue;
   /// Holds the new value of the [FrameworkPropertyBase].
   final Dynamic newValue;

   PropertyChangingEventArgs(this.oldValue, this.newValue);
}