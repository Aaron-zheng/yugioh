//
//  PackTableViewController.swift
//  yugioh
//
//  Created by Aaron on 30/1/2017.
//  Copyright © 2017 sightcorner. All rights reserved.
//

import Foundation
import UIKit


class PackTableViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: PackTableViewControllerDelegate!
    
 
    fileprivate let packs = ["所有卡包", "15AX", "15AY", "301", "302", "303", "304", "305", "306", "307", "308", "309", "ABPF(607)", "ABYR(802)", "ANPR(605)", "AT01", "AT02", "AT03", "AT04", "AT05", "AT06", "AT07", "AT09", "BE01", "BE02", "BE1", "BOSH(907)", "BP01", "BP03", "Booster Chronicle", "Booster R1", "Booster R2", "Booster R3", "Booster01", "Booster02", "Booster03", "Booster04", "Booster05", "Booster06", "Booster07", "CA", "CBLZ(803)", "CDIP(502)", "CORE(905)", "CPD1", "CPF1", "CPL1", "CPZ1", "CRMS(603)", "CROS(904)", "CRV(405)", "CSOC(602)", "CT08", "CT12", "DB12", "DBLE", "DC01", "DCE", "DD02", "DDY01", "DDY02", "DDY03", "DE01", "DE02", "DE03", "DE04", "DF16", "DL01", "DL02", "DL03", "DL04", "DL05", "DOCS(906)", "DP01", "DP02", "DP03", "DP04", "DP05", "DP06", "DP07", "DP08", "DP09", "DP10", "DP11", "DP12", "DP13", "DP14", "DP15", "DP16", "DPBC", "DPEX", "DPK", "DPKB", "DPYG", "DREV(701)", "DRLG", "DS13", "DS14", "DT01", "DT02", "DT03", "DT04", "DT05", "DT06", "DT07", "DT08", "DT09", "DT10", "DT11", "DT12", "DT13", "DT14", "DTP01", "DUEA(901)", "EE01", "EE02", "EE03", "EE04", "EEN(406)", "EOJ(408)", "EONK", "EP12", "EP13", "EP14", "EP15", "EP16", "EX-R(EX)", "EXP01", "EXP02", "EXP03", "EXP04", "EXVC(704)", "FET(403)", "FOTB(504)", "G4", "GAOV(708)", "GENF(705)", "GLAS(506)", "GLD01", "GLD02", "GLD03", "GLD04", "GS01", "GS02", "GS03", "GS04", "GS05", "GS06", "GX01", "GX02", "GX03", "GX04", "GX05", "GX06", "HA01", "HA02", "HA03", "HA04", "HA05", "HA06", "HD13", "HSRD", "JF07", "JF08", "JF09", "JF10", "JF11", "JF12", "JF13", "JF14", "JF15", "JOTL(805)", "JUMP", "JY", "KA", "LB", "LC01", "LC02", "LC03", "LC04", "LCGX", "LE01", "LE02", "LE03", "LE04", "LE05", "LE06", "LE07", "LE08", "LE09", "LE10", "LE11", "LE12", "LE13", "LE14", "LE15", "LE16", "LE17", "LN", "LODT(508)", "LTGY(804)", "LVAL(807)", "MA", "MB01", "ME", "MFC01", "MFC02", "MFC03", "MG03", "MG04", "MP01", "MR", "MVPC", "NECH(902)", "NUMH", "OG01", "OG02", "OG03", "ORCS(707)", "PC1", "PE", "PG", "PGL3", "PH", "PHSW(706)", "POTD(501)", "PP01", "PP02", "PP03", "PP04", "PP05", "PP06", "PP07", "PP08", "PP09", "PP10", "PP11", "PP12", "PP13", "PP14", "PP15", "PP16", "PP17", "PP18", "PR03", "PR04", "PR05", "PRC1", "PRIO(808)", "PRTX", "PS", "PTDN(507)", "RB", "RB01", "RDS(402)", "REDU(801)", "RGBT(604)", "SC", "SD01", "SD02", "SD03", "SD04", "SD05", "SD06", "SD07", "SD08", "SD09", "SD10", "SD11", "SD12", "SD13", "SD14", "SD15", "SD16", "SD17", "SD18", "SD19", "SD20", "SD21", "SD22", "SD23", "SD24", "SD25", "SD26", "SD27", "SD28", "SD29", "SD30", "SDKS", "SDLI", "SDM", "SDMY", "SDWA", "SECE(903)", "SHSP(806)", "SHVI(908)", "SHVI（908）", "SJ2", "SJMP", "SK2", "SM", "SOD(401)", "SOI(407)", "SOVR(606)", "SPHR", "SPRG", "SPTR", "SPWR", "SR01", "SR02", "SR03", "ST12", "ST13", "ST14", "STBL(702)", "STON(503)", "STOR(703)", "SY2", "Starter Box", "TAEV(505)", "TB", "TB ", "TDGS(601)", "TF04", "TF05", "TF06", "TFSP", "TLM(404)", "TP01", "TP02", "TP03", "TP04", "TP05", "TP06", "TP07", "TP08", "TP09", "TP10", "TP11", "TP12", "TP13", "TP14", "TP15", "TP16", "TP17", "TP18", "TP19", "TP20", "TP21", "TP22", "TP23", "TSHD(608)", "TU01", "TU02", "TU03", "TU04", "TU05", "TU06", "TU07", "VB01", "VB02", "VB03", "VB04", "VB05", "VB06", "VB07", "VB08", "VB09", "VB10", "VB11", "VB12", "VB13", "VB14", "VB15", "VB16", "VB17", "VB18", "VE01", "VE02", "VE03", "VE04", "VE05", "VE06", "VE07", "VE08", "VE09", "VE10", "VE11", "VF11", "VF12", "VF13", "VF14", "VF15", "VJ", "VJC", "VJCF", "VJCP", "VJMP", "VOL01", "VOL02", "VOL03", "VOL04", "VOL05", "VOL06", "VOL07", "VP14", "VP15", "VS15", "WB01", "WC07", "WC08", "WC09", "WC10", "WC11", "WCP2011", "WCP2012", "WCP2013", "WCP2014", "WCPS2006", "WCPS2007", "WCPS2008", "WCPS2009", "WCPS2010", "WCS2003", "WCS2004", "WCS2005", "WJ", "WJC", "WJMP", "WSUP", "YAP01", "YCSW", "YDT01", "YF01", "YF02", "YF03", "YF04", "YF05", "YF06", "YF07", "YF08", "YF09", "YG09", "YGLD", "YGOPR", "YMP01", "YSD01", "YSD02", "YSD03", "YSD04", "YSD05", "YSD06", "YU", "YZ01", "YZ02", "YZ03", "YZ04", "YZ05", "YZ06", "YZ07", "YZ08", "YZ09", "ZDC1", "ZTIN", "其他"]
    
    
    override func viewDidLoad() {
        self.tableView.backgroundColor = greyColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.delegate = CardVariables.packTableViewControllerDelegate
    }
    
    
}



extension PackTableViewController: UITableViewDelegate {
    
}

extension PackTableViewController: UITableViewDataSource {
    
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packs.count
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PackTableViewCell", for: indexPath) as! PackTableViewCell
        cell.titleLabel.text = packs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        _ = self.navigationController?.popViewController(animated: true)
        self.delegate.didFinish(selectedPack: packs[indexPath.row])
        
    }

}


protocol PackTableViewControllerDelegate {
    func didFinish(selectedPack: String?)
}
