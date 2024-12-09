import { CustomTitleBar } from '../../widgets/CustomTitleBar'
import { BusinessError, deviceInfo } from '@kit.BasicServicesKit';
import { deviceCertificate, safetyDetect } from '@kit.DeviceSecurityKit';
import { printError, printInfo } from '../../utils/LogUtils';
import json from '@ohos.util.json';
import { showToast } from '../../utils/ToastUtils';

@Entry
@Component
struct DeviceInfoPage {
  async aboutToAppear(): Promise<void> {
    try {
      deviceCertificate.getDeviceToken().then((token)=>{
        printInfo("token===="+token)
      })
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      printError(`token====${json.stringify(err)}`)
    }
    let req : safetyDetect.UrlCheckRequest = {
      urls : ['https://www.baidu.com/']
    };
    try {
    const data = await safetyDetect.checkUrlThreat(req)
      printInfo(`toekn=====check = ${json.stringify(data)}}`)
      showToast(`toekn=====check = ${json.stringify(data)}}`)

    } catch (e) {
      printError(`toekn=====check = ${json.stringify(e)}}`)
      showToast(`toekn=====check = ${json.stringify(e)}}`)
    }

  }

  build() {
    Column() {
      CustomTitleBar({ title: 'DeviceInfoPage' }) {
        Text(`设备信息:\n deviceType=${deviceInfo.deviceType},
        manufacture=${deviceInfo.manufacture},
        brand=${deviceInfo.brand},
        marketName=${deviceInfo.marketName},
        serial=${deviceInfo.serial},
        displayVersion=${deviceInfo.displayVersion},
        osFullName=${deviceInfo.osFullName},
        majorVersion=${deviceInfo.majorVersion},
        seniorVersion=${deviceInfo.seniorVersion},
        featureVersion=${deviceInfo.featureVersion},
        buildVersion=${deviceInfo.buildVersion},
        sdkApiVersion=${deviceInfo.sdkApiVersion},
        sdkApiVersion=${deviceInfo.firstApiVersion},
        versionId=${deviceInfo.versionId},
        udid=${deviceInfo.udid},
        ODID=${deviceInfo.ODID}
        `)
      }
    }
  }
}