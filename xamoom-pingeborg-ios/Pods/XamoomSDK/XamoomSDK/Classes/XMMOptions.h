//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#ifndef XMMOptions_h
#define XMMOptions_h

/**
 * XMMContent special options.
 */
typedef NS_OPTIONS(NSUInteger, XMMContentOptions) {
  /**
   * No options.
   */
  XMMContentOptionsNone = 0 << 0,
  /**
   * Will not save statistics.
   */
  XMMContentOptionsPreview = 1 << 0,
  /**
   * Wont return ContentBlocks with "Hide Online" flag.
   */
  XMMContentOptionsPrivate = 1 << 1,
};

/**
 * XMMSpot special options.
 */
typedef NS_OPTIONS(NSUInteger, XMMSpotOptions) {
  /**
   * No options.
   */
  XMMSpotOptionsNone = 0 << 0,
  /**
   * Will include contentID to spots.
   */
  XMMSpotOptionsIncludeContent = 1 << 0,
  /**
   * Will include markers to spots
   */
  XMMSpotOptionsIncludeMarker = 1 << 1,
  /**
   * Will only return spots with a location.
   */
  XMMSpotOptionsWithLocation = 1 << 2,
};

/**
 * XMMContent sorting options.
 */
typedef NS_OPTIONS(NSUInteger, XMMContentSortOptions) {
  /**
   * No sorting.
   */
  XMMContentSortOptionsNone = 0 << 0,
  /**
   * Sort by name ascending.
   */
  XMMContentSortOptionsTitle = 1 << 0,
  /**
   * Sort by name descending.
   */
  XMMContentSortOptionsNameDesc = 1 << 1,
};

/**
 * XMMSpot sorting options.
 */
typedef NS_OPTIONS(NSUInteger, XMMSpotSortOptions) {
  /**
   * No sorting.
   */
  XMMSpotSortOptionsNone = 0 << 0,
  /**
   * Sort by name ascending.
   */
  XMMSpotSortOptionsName = 1 << 0,
  /**
   * Sort by name descending.
   */
  XMMSpotSortOptionsNameDesc = 1 << 1,
  /**
   * Sort by distance ascending.
   */
  XMMSpotSortOptionsDistance = 1 << 2,
  /**
   * Sort by distance descending.
   */
  XMMSpotSortOptionsDistanceDesc = 1 << 3,
};

#endif /* XMMOptions_h */
