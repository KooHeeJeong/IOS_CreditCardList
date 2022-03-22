//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by 구희정 on 2022/03/20.
//

import UIKit
import Kingfisher
import FirebaseDatabase

class CardListViewController : UITableViewController {
    var ref: DatabaseReference!         //FireBase Realtime Database
    
    var creditCardList : [CreditCard] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UINib ?
        let nibName = UINib(nibName: "CardListCell", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
        
        ref = Database.database().reference()
        
        //DB에서 스냅샷으로 데이터를 가져온다.
        ref.observe(.value) { snapshot in
            
            //스냅샷으로 데이터를 가져오지 못한다면, nil 을 리턴해서 가져온다.
            guard let value = snapshot.value as? [String : [String : Any ]] else { return }
            
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let cardData = try JSONDecoder().decode([String : CreditCard].self, from: jsonData)
                let cardList = Array(cardData.values)
                self.creditCardList = cardList.sorted{ $0.rank < $1.rank }
                
                
                //메인 스레드에서 UI뷰 재성
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch let error {
                print("Error JSON parsing \(error)")
            }
            
        }
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
        cell.promotionLabel.text = "\(creditCardList[indexPath.row].promotionDetail.amount)만원 증정"
        
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
        
        detailViewController.promotionDetail = creditCardList[indexPath.row].promotionDetail
        self.show(detailViewController, sender: nil)
    }
}
