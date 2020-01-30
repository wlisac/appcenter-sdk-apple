// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

import UIKit
import AppCenterDistribute

class MSDistributeViewController: UITableViewController, AppCenterProtocol {

  @IBOutlet weak var enabled: UISwitch!
  @IBOutlet weak var customized: UISwitch!
  @IBOutlet weak var distributeFlagField: UITextField!
  @IBOutlet weak var distributeFlagSwitch: UISwitch!
  var appCenter: AppCenterDelegate!

  enum DistributeFlags: String, CaseIterable {
        case None = "None"
        case DisableCheckForUpdate = "Disable automatic check for update"
        case DisableAutoAuth = "Disable automatic authentication"

        /*var state: MSDistributeFlags {
            switch self {
            case .None: return .none
            case .DisableCheckForUpdate: return .mSDistributeFlagsDisableAutomaticCheckForUpdateivate
            case .DisableAutoAuth: return .mSDistributeFlagsDisableAutomaticAuthentication
            }
        }

        static func getSelf(by flags: MSDistributeFlags) -> DistributeFlags {
            switch flags {
            case .none: return .None
            case .mSDistributeFlagsDisableAutomaticCheckForUpdateivate: return .DisableCheckForUpdate
            case .mSDistributeFlagsDisableAutomaticCheckForUpdateivate: return .DisableCheckForUpdate
            }
        }*/
  }

  private var distributeFlagsPicker: MSEnumPicker<DistributeFlags>?

  private var distributeFlags = DistributeFlags.None {
      didSet {
        distributeFlagField.text = self.distributeFlags.rawValue
      }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.customized.isOn = UserDefaults.init().bool(forKey: kSASCustomizedUpdateAlertKey)

    if let flag = UserDefaults.standard.value(forKey: kMSDistributeFlagBeforeStartValue) {
        //self.distributeFlags = DistributeFlags.getSelf(by: MSDistributeFlags(rawValue: flag));
    }
  }

  func preparePicker() {
    self.distributeFlagsPicker = MSEnumPicker<DistributeFlags>(
        textField: self.distributeFlagField,
        allValues: DistributeFlags.allCases,
        onChange: { index in
            let pickedValue = DistributeFlags.allCases[index]
            if self.distributeFlagSwitch.isOn {
               // UserDefaults.standard.set(pickedValue.state.rawValue, forKey: kMSDistributeFlagBeforeStartValue)
            } else {
                //MSDistribute.configure(pickedValue.state)
                self.distributeFlags = pickedValue
            }
    })
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.enabled.isOn = appCenter.isDistributeEnabled()
    
    // Make sure the UITabBarController does not cut off the last cell.
    self.edgesForExtendedLayout = []
  }
  
  @IBAction func enabledSwitchUpdated(_ sender: UISwitch) {
    appCenter.setDistributeEnabled(sender.isOn)
    sender.isOn = appCenter.isDistributeEnabled()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch (indexPath.section) {
      
    // Section with alerts.
    case 1:
      switch (indexPath.row) {
      case 0:
        if (!customized.isOn) {
          appCenter.showConfirmationAlert()
        } else {
          appCenter.showCustomConfirmationAlert()
        }
      case 1:
        appCenter.showDistributeDisabledAlert()
      default: ()
      }
    default: ()
    }
  }

  @IBAction func customizedSwitchUpdated(_ sender: UISwitch) {
    UserDefaults.init().set(sender.isOn ? true : false, forKey: kSASCustomizedUpdateAlertKey)
  }

  @IBAction func changeDistributeFlagBeforeSdkUpdated(_ sender: UISwitch) {
    //UserDefaults.standard.set(sender.isOn ? distributeFlags.state.rawValue : nil, forKey: kMSDistributeFlagBeforeStartValue)
  }
}
