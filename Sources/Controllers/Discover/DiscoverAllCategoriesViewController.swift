//
//  DiscoverAllCategoriesViewController.swift
//  Ello
//
//  Created by Colin Gray on 6/17/2016.
//  Copyright (c) 2016 Ello. All rights reserved.
//

public class DiscoverAllCategoriesViewController: StreamableViewController {
    var screen: DiscoverMoreCategoriesScreen!

    required public init() {
        super.init(nibName: nil, bundle: nil)

        title = InterfaceString.Discover.AllCategories
        elloNavigationItem.title = title

        let leftItem = UIBarButtonItem.backChevronWithTarget(self, action: #selector(backTapped(_:)))
        elloNavigationItem.leftBarButtonItems = [leftItem]
        elloNavigationItem.fixNavBarItemPadding()

        streamViewController.streamKind = .AllCategories
        streamViewController.customStreamCellItems = { jsonables, defaultItems in
            var items: [StreamCellItem] = []
            if let categories = jsonables as? [Category] {
                let sortedCategories = categories
                    .sort { $0.order < $1.order }
                for category in sortedCategories {
                    items.append(StreamCellItem(jsonable: category, type: .CategoryCard))
                }
            }
            return items
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView() {
        self.screen = DiscoverMoreCategoriesScreen(navigationItem: elloNavigationItem)
        self.view = screen
        viewContainer = screen.streamContainer
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        scrollLogic.prevOffset = streamViewController.collectionView.contentOffset
        ElloHUD.showLoadingHudInView(streamViewController.view)
        streamViewController.loadInitialPage()
    }

    private func updateInsets() {
        updateInsets(navBar: screen.navigationBar, streamController: streamViewController)
    }

    override public func showNavBars(scrollToBottom: Bool) {
        super.showNavBars(scrollToBottom)
        positionNavBar(screen.navigationBar, visible: true, withConstraint: screen.navigationBarTopConstraint)
        updateInsets()

        if scrollToBottom {
            self.scrollToBottom(streamViewController)
        }
    }

    override public func hideNavBars() {
        super.hideNavBars()
        positionNavBar(screen.navigationBar, visible: false, withConstraint: screen.navigationBarTopConstraint)
        updateInsets()
    }

}