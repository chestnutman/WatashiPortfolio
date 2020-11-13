//
//  TermsViewController.swift
//  OriginalApp
//
//  Created by 鈴木賀子 on 14/08/2020.
//  Copyright © 2020 Yoshiko. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
    
}

class TermsViewController: UIViewController, UIScrollViewDelegate {
    
    /// 利用規約ボタンUI
        @IBOutlet weak var consentButton1: UIButton!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 改行を可能にする
        let  newLine:String = "New\nLine"
        print(newLine)
            
        let scrollView = UIScrollView()
            scrollView.backgroundColor = UIColor.gray
        
            // 表示窓のサイズと位置を設定
            //scrollView.frame.size = CGSize(width: 354, height: 594)
            //scrollView.center = self.view.center
        
            // 中身の大きさを設定
            //scrollView.contentSize = CGSize(width: 354, height: 3000)
        
            // スクロールの跳ね返り
            scrollView.bounces = true
        
            // スクロールバーの見た目と余白
            scrollView.indicatorStyle = .black
            scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
            // Delegate を設定
            scrollView.delegate = self
                
            // ScrollViewの中身を作る
                let textView = UITextView()
                textView.text = "この規約は、お客様が、「BRWN」（以下「本サービス」）をご利用頂く際の取扱いにつき定めるものです。本規約に同意した上で本サービスをご利用ください。\n 第１条（定義）\n 本規約上で使用する用語の定義は、次に掲げるとおりとします。\n （1）本サービス\n 当社が運営するサービス及び関連するサービス\n （2）本サイト\n 本サービスのコンテンツが掲載されたウェブサイト\n （3）本コンテンツ\n 本サービス上で提供される文字、音、静止画、動画、ソフトウェアプログラム、コード等の総称（投稿情報を含む）\n （4）利用者\n 本サービスを利用する全ての方\n （5）登録利用者\n 本サイトの利用者登録が完了した方\n （6）ＩＤ\n 本サービスの利用のために登録利用者が固有に持つ文字列\n （7）パスワード\n ＩＤに対応して登録利用者が固有に設定する暗号\n （8）個人情報\n 住所、氏名、職業、電話番号等個人を特定することのできる情報の総称\n （9）登録情報\n 録利用者が本サイトにて登録した情報の総称（投稿情報は除く）\n （10）知的財産\n 発明、考案、植物の新品種、意匠、著作物その他の人間の創造的活動により生み出されるもの（発見または解明がされた自然の法則または現象であって、産業上の利用可能性があるものを含む）、商標、商号その他事業活動に用いられる商品または役務を表示するもの及び営業秘密その他の事業活動に有用な技術上または営業上の情報\n （11）知的財産権\n 特許権、実用新案権、育成者権、意匠権、著作権、商標権その他の知的財産に関して法令により定められた権利または法律上保護される利益に係る権利\n \n 第２条（本規約への同意）\n １　利用者は、本利用規約に同意頂いた上で、本サービスを利用できるものとします。\n ２　利用者が、本サービスをスマートフォンその他の情報端末にダウンロードし、本規約への同意手続を行った時点で、利用者と当社との間で、本規約の諸規定に従った利用契約が成立するものとします。\n ３　利用者が未成年者である場合には、親権者その他の法定代理人の同意を得たうえで、本サービスをご利用ください。\n ４　未成年者の利用者が、法定代理人の同意がないにもかかわらず同意があると偽りまたは年齢について成年と偽って本サービスを利用した場合、その他行為能力者であることを信じさせるために詐術を用いた場合、本サービスに関する一切の法律行為を取り消すことは出来ません。\n　５　本規約の同意時に未成年であった利用者が成年に達した後に本サービスを利用した場合、当該利用者は本サービスに関する一切の法律行為を追認したものとみなされます。\n　\n　第３条（規約の変更）\n　１　当社は、利用者の承諾を得ることなく、いつでも、本規約の内容を改定することができるものとし、利用者はこれを異議なく承諾するものとします。\n　２　当社は、本規約を改定するときは、その内容について当社所定の方法により利用者に通知します。\n　３　前本規約の改定の効力は、当社が前項により通知を行った時点から生じるものとします。\n　４　利用者は、本規約変更後、本サービスを利用した時点で、変更後の本利用規約に異議なく同意したものとみなされます。\n　\n　第４条（会員の入会手続）\n　１　本サービスへの入会を希望する方（以下「登録希望者」）は、本規約に同意した上で、所定の方法で入会の申込を行ってください。\n　２　入会の申込をした方は、弊社がその申込を承諾し、ＩＤ登録が完了した時点から登録ユーザとなります。\n　３　弊社は、登録ユーザ向けにメールで連絡事項の告知や広告その他の情報提供を行います。あらかじめご了承ください。\n　４　弊社は、登録希望者が次の各号のいずれか一つに該当する場合は、弊社の判断により入会申込を承諾しないことがあります。\n　一　登録希望者が、弊社の定める方法によらず入会の申込を行った場合\n　二　登録希望者が、過去に本規約または弊社の定めるその他の利用規約等に違反したことを理由として退会処分を受けた者である場合\n　三　登録希望者が、不正な手段をもって登録を行っていると弊社が判断した場合\n　四　登録希望者が、本人以外の情報を登録している場合\n　五　その他弊社が不適切と判断した場合　\n　\n　第５条（アカウントの管理）\n　１　利用者は、利用に際して登録した情報（以下、「登録情報」といいます。メールアドレスやID・パスワード等を含みます）について、自己の責任の下、任意に登録、管理するものとします。利用者は、これを第三者に利用させ、または貸与、譲渡、名義変更、売買などをしてはならないものとします。\n　２　当社は、登録情報によって本サービスの利用があった場合、利用登録をおこなった本人が利用したものと扱うことができ、当該利用によって生じた結果ならびにそれに伴う一切の責任については、利用登録を行った本人に帰属するものとします。\n　３　利用者は、登録情報の不正使用によって当社または第三者に損害が生じた場合、当社および第三者に対して、当該損害を賠償するものとします。\n　４　登録情報の管理は、利用者が自己の責任の下で行うものとし、登録情報が不正確または虚偽であったために利用者が被った一切の不利益および損害に関して、当社は責任を負わないものとします。\n　５　登録情報が盗用されまたは第三者に利用されていることが判明した場合、利用者は直ちにその旨を当社に通知するとともに、当社からの指示に従うものとします。\n　\n　第６条（個人情報等の取り扱い）\n　個人情報及び利用者情報については、当社が別途定める「BRWNプライバシーポリシー」に則り、適正に取り扱うこととします。\n　\n　第７条（禁止行為）\n　本サービスの利用に際し、当社は、利用者に対し、次に掲げる行為を禁止します。当社において、利用者が禁止事項に違反したと認めた場合、利用者用の一時停止、退会処分その他当社が必要と判断した措置を取ることができます。\n　（１）当社または第三者の知的財産権を侵害する行為\n　（２）当社または第三者の名誉・信用を毀損または不当に差別もしくは誹謗中傷する行為\n　（３）当社または第三者の財産を侵害する行為、または侵害する恐れのある行為\n　（４）当社または第三者に経済的損害を与える行為\n　（５）当社または第三者に対する脅迫的な行為\n　（６）コンピューターウィルス、有害なプログラムを仕様またはそれを誘発する行為\n　（７）本サービス用インフラ設備に対して過度な負担となるストレスをかける行為\n　（８）当サイトのサーバーやシステム、セキュリティへの攻撃\n　（９）当社提供のインターフェース以外の方法で当社サービスにアクセスを試みる行為\n（１０）一人の利用者が、複数の利用者IDを取得する行為\n　（１１）上記の他、当社が不適切と判断する行為\n　\n　第８条（免責）\n　１　当社は、本サービスの内容変更、中断、終了によって生じたいかなる損害についても、一切責任を負いません。\n　２　当社は、利用者の本サービスの利用環境について一切関与せず、また一切の責任を負いません。\n　３　当社は、本サービスが利用者の特定の目的に適合すること、期待する機能・商品的価値・正確性・有用性を有すること、利用者による本サービスの利用が利用者に適用のある法令または業界団体の内部規則等に適合すること、および不具合が生じないことについて、何ら保証するものではありません。\n　４　当社は、本サービスが全ての情報端末に対応していることを保証するものではなく、本サービスの利用に供する情報端末のＯＳのバージョンアップ等に伴い、本サービスの動作に不具合が生じる可能性があることにつき、利用者はあらかじめ了承するものとします。当社は、かかる不具合が生じた場合に当社が行うプログラムの修正等により、当該不具合が解消されることを保証するものではありません。\n　５　利用者は、AppStore、GooglePlay等のサービスストアの利用規約および運用方針の変更等に伴い、本サービスの一部又は全部の利用が制限される可能性があることをあらかじめ了承するものとします。\n　６　当社は、本サービスを利用したことにより直接的または間接的に利用者に発生した損害について、一切賠償責任を負いません。\n　７　当社は、利用者その他の第三者に発生した機会逸失、業務の中断その他いかなる損害（間接損害や逸失利益を含みます）に対して、当社が係る損害の可能性を事前に通知されていたとしても、一切の責任を負いません。\n　８　第１項乃至前項の規定は、当社に故意または重過失が存する場合又は契約書が消費者契約法上の消費者に該当する場合には適用しません。\n　９　前項が適用される場合であっても、当社は、過失（重過失を除きます。）による行為によって利用者に生じた損害のうち、特別な事情から生じた損害については、一切賠償する責任を負わないものとします。\n　１０　本サービスの利用に関し当社が損害賠償責任を負う場合、当該損害が発生した月に利用者から受領した利用額を限度として賠償責任を負うものとします。\n　１１　利用者と他の利用者との間の紛争及びトラブルについて、当社は一切責任を負わないものとします。利用者と他の利用者でトラブルになった場合でも、両者同士の責任で解決するものとし、当社には一切の請求をしないものとします。\n　１２　利用者は、本サービスの利用に関連し、他の利用者に損害を与えた場合または第三者との間に紛争を生じた場合、自己の費用と責任において、かかる損害を賠償またはかかる紛争を解決するものとし、当社には一切の迷惑や損害を与えないものとします。\n　１３　利用者の行為により、第三者から当社が損害賠償等の請求をされた場合には、利用者の費用（弁護士費用）と責任で、これを解決するものとします。当社が、当該第三者に対して、損害賠償金を支払った場合には、利用者は、当社に対して当該損害賠償金を含む一切の費用（弁護士費用及び逸失利益を含む）を支払うものとします。\n　１４　利用者が本サービスの利用に関連して当社に損害を与えた場合、利用者の費用と責任において当社に対して損害を賠償（訴訟費用及び弁護士費用を含む）するものとします。\n　\n　第９条（広告の掲載について）\n　利用者は、本サービス上にあらゆる広告が含まれる場合があること、当社またはその提携先があらゆる広告を掲載する場合があることを理解しこれを承諾したものとみなします。本サービス上の広告の形態や範囲は、当社によって随時変更されます。\n　\n　第１０条（権利譲渡の禁止）\n　１　利用者は、予め当社の書面による承諾がない限り、本規約上の地位および本規約に基づく権利または義務の全部または一部を第三者に譲渡してはならないものとします。\n　２　当社は、本サービスの全部または一部を当社の裁量により第三者に譲渡することができ、その場合、譲渡された権利の範囲内で利用者のアカウントを含む、本サービスに係る利用者の一切の権利が譲渡先に移転するものとします。\n　\n　第１１条（分離可能性）\n　本規約のいずれかの条項又はその一部が、消費者契約法その他の法令等により無効又は執行不能と判断された場合であっても、本規約の残りの規定及び一部が無効又は執行不能と判断された規定の残りの部分は、継続して完全に効力を有するものとします。\n　\n　第１２条（当社への連絡方法）\n　本サービスに関する利用者の当社へのご連絡・お問い合わせは、本サービスまたは当社が運営するwebサイト内の適宜の場所に設置するお問い合わせフォームからの送信または当社が別途指定する方法により行うものとします。\n　\n　第１３条（準拠法、管轄裁判所）\n　１　本規約の有効性，解釈及び履行については，日本法に準拠し，日本法に従って解釈されるものとする。\n　２　当社と利用者等との間での論議・訴訟その他一切の紛争については、訴額に応じて、東京簡易裁判所又は東京地方裁判所を専属的合意管轄裁判所とします｡\n　２０２０年８月１４日　施行"
        
        
                textView.sizeToFit()
                // textViewHeightConstraint.constant = textView.frame.height
                textView.backgroundColor = UIColor.white
                //textView.center = CGPoint(x: 100 * i, y: 60 * i)
                scrollView.addSubview(textView)
                
            self.view.addSubview(scrollView)
        
        // ボタンの装飾
        consentButton1.center = self.view.center
               
        consentButton1.backgroundColor = #colorLiteral(red: 0.251144737, green: 0.1601424813, blue: 0.1088011637, alpha: 1) // 3
        consentButton1.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        
        //consentButton1.layer.borderWidth = 4
        //consentButton1.layer.borderColor = #colorLiteral(red: 0.930855453, green: 0.8780241609, blue: 0.8337224126, alpha: 1)
        
        consentButton1.layer.cornerRadius = 25
        
 /*       consentButton1.layer.shadowOffset = CGSize(width: 3, height: 3 )  // 8
        consentButton1.layer.shadowOpacity = 0.5  // 9
        consentButton1.layer.shadowRadius = 10  // 10
        consentButton1.layer.shadowColor = UIColor.gray.cgColor  // 11
 */
    }
   
    /* 以下は UITextFieldDelegate のメソッド */
     
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // スクロール中の処理
        print("didScroll")
    }
     
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // ドラッグ開始時の処理
        print("beginDragging")
    }
    
    @IBAction func agreeTerm () {
    self.performSegue(withIdentifier: "toPrivacy", sender: nil)
        
    }
}
