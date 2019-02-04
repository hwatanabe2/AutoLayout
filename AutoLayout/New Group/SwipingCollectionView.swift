//
//  SwipingCollectionView.swift
//  AutoLayout
//
//  Created by Hikaru Watanabe on 12/29/18.
//  Copyright © 2018 Hikaru Watanabe. All rights reserved.
//

import UIKit

class SwipingCollectionView: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //MARK:- Parameters
    private var pages = [Page]()
    private var bottomStackView: UIStackView!
    
    private let prevButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Prev", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(prevButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(UIColor.red.withAlphaComponent(0.80), for: .normal)
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 4
        pc.currentPageIndicatorTintColor = UIColor.red.withAlphaComponent(0.80)
        pc.pageIndicatorTintColor = UIColor.red.withAlphaComponent(0.45)
        pc.isUserInteractionEnabled = false
        return pc
    }()
    
    //MARK:- UIViewController
    override func viewDidLoad(){
        super.viewDidLoad()
        loadPages()
        setBottomStackView()
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "PageCell")
        collectionView?.backgroundColor = .white
        collectionView?.isPagingEnabled = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let index = pageControl.currentPage
        
        coordinator.animate(alongsideTransition: { _ in
            self.collectionViewLayout.invalidateLayout()
            //There is a bug where setting index to 0 cause cell to not align with view's center.
            if(index == 0){
                self.collectionView?.contentOffset = .zero
            }else{
                self.changePage(to: index)
            }
        }) { _ in
            
        }
    }
    
    private func loadPages(){
        pages.append(Page(image: #imageLiteral(resourceName: "iOS_Logo"), titleText: "This is the first page!", detailText: "This is the first page of this swiping collection view. The icon represents iOS."))
        pages.append(Page(image: #imageLiteral(resourceName: "pig"), titleText: "This is the second page!", detailText: "This is the second page of this swiping collection view. Pigs cry bubu in Japan!"))
        pages.append(Page(image: #imageLiteral(resourceName: "horse"), titleText: "This is the third page!", detailText: "This is the third page of this swiping collection view. Horses run faster than pigs D:"))
        pages.append(Page(image: #imageLiteral(resourceName: "panda"), titleText: "This is the fourth page!", detailText: "This is the fourth page of this swiping collection view. Pandas are so cute. Gianto babies"))
    }

    //MARK:- UICollectionViewController
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCell", for: indexPath) as! PageCell
        cell.page = pages[indexPath.item]
        return cell
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let index = Int(x / view.frame.size.width)
        changePage(to: index)
    }
    
    //MARK:- UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //MARK:- Swipe control
    private func setBottomStackView(){
        bottomStackView = UIStackView(arrangedSubviews: [prevButton, pageControl, nextButton])
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.distribution = .fillEqually
        self.view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            bottomStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            bottomStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            bottomStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            bottomStackView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1)
            ])
    }
    
    @objc func nextButtonPressed(){
        changePage(to: pageControl.currentPage + 1)
    }
    
    @objc func prevButtonPressed(){
        changePage(to: pageControl.currentPage - 1)
    }
    
    private func changePage(to index:Int){
        guard pages.count > index || index - 1 >= 0 else {
            return
        }
        let indexPath = IndexPath(item: index, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = index
    }
    
}
