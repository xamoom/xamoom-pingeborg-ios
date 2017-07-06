//
//  NavigationCoordinator.swift
//  pingeb.org
//
//  Created by Raphael Seher on 06/07/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

import UIKit

@objc
class NavigationCoordinator : NSObject {

  let navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func openArtistDetail(contentId: String) {
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let artistDetailVC =
      storyBoard.instantiateViewController(withIdentifier: "ArtistDetailView")
        as! ArtistDetailViewController
    
    artistDetailVC.contentId = contentId
    self.navigationController.pushViewController(artistDetailVC, animated: true)
  }
}
