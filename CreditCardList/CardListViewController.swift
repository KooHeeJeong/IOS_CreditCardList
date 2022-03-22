//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by 구희정 on 2022/03/20.
//

import UIKit
import Kingfisher

class CardListViewController : UITableViewController {
    var creditCardList : [CreditCard] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UINib ?
        let nibName = UINib(nibName: "CardListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
    }
    
    //테이블 뷰의 개수를 지정해준다.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCardList.count
    }
    
    //커스텀셀과 그 지정된 셀에 데이터를 전달해줄 메소드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //셀이 있다는 가정하에 guard문으로 지정
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as? CardListCell else { return UITableViewCell() }
        
        cell.rankLabel.text = "\(creditCardList[indexPath.row].rank)위"
        cell.cardNameLabel.text = "\(creditCardList[indexPath.row].name)"
        cell.promotionLabel.text = "\(creditCardList[indexPath.row].promotiondetail.amount)만원 증정"
        
        //Kingfisher 라이브러리를 사용하여 이미지를 다운로드를 하여 가져온다.
        let imageURL = URL(string: creditCardList[indexPath.row].cardImageURL)
        cell.cardIamgeView.kf.setImage(with: imageURL)
        
        return cell
    }
    
    //셀을 커스텀 하기 위해 높이 80으로 지정하여 Return 해준다.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //어떤 셀을 텝 하였을 때, 제어를 해주고 싶을 때
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //상세화면 전달
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailViewController = storyboard.instantiateViewController(identifier: "CardDetailViewController") as? CardDetailViewController else { return }
        
        detailViewController.promotionDetail = creditCardList[indexPath.row].promotiondetail
        self.show(detailViewController, sender: nil)
    }
}
