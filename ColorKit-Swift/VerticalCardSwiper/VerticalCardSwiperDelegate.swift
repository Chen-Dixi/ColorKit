// MIT License
//
// Copyright (c) 2017 Joni Van Roost
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

/// This delegate is used for delegating `VerticalCardSwiper` actions.
@objc public protocol VerticalCardSwiperDelegate: class {
    
    /**
     Called when a CardCell has animated off screen.
     - parameter card: The CardCell that is being swiped away.
     - parameter index: The index of the card that is being removed.
     - parameter swipeDirection: The direction the card is swiped in. This can be Left, Right or None.
     */
    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: CellSwipeDirection)
    
    /**
     Called right before a CardCell animates off screen. At this point there's already no way back.
     - parameter card: The CardCell that is being swiped away.
     - parameter index: The index of the card that is being removed.
     - parameter swipeDirection: The direction the card is swiped in. This can be Left, Right or None.
     */
    @objc optional func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: CellSwipeDirection)
    
    /**
     Tells the delegate when the user scrolls through the cards.
     - parameter verticalCardSwiperView: The `VerticalCardSwiperView` that displays the cardcells.
    */
    @objc optional func didScroll(verticalCardSwiperView: VerticalCardSwiperView)
    
    /**
     Allows you to return the size as a CGSize for each card at their specified index.
     This function will be called for every card. You can customize each card to have a different size.
     
     Because this function uses the standard `sizeForItem` function of a `UICollectionView` internally,
     you should keep in mind that returning a very small cell size results in multiple columns (like a standard collectionview),
     which is not supported at the moment and very buggy.
     
     This function will also take the custom insets into account, in case (itemSize - insets) is negative,
     it will not take the insets into account.
     - parameter verticalCardSwiperView: The `VerticalCardSwiperView` that will display the `CardCell`.
     - parameter index: The index for which we return the specific CGSize.
     - returns: The size of each card for its respective index as a CGSize.
    */
    @objc optional func sizeForItem(verticalCardSwiperView: VerticalCardSwiperView, index: Int) -> CGSize
}
