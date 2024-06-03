import hilog from '@ohos.hilog'

export default class LogUtils {
  static printInfo(...args: any[]) {
    hilog.info(0x0000, 'testTag', '%{public}s', args)
  }

  static printError(...args: any[]) {
    hilog.error(0x0000, 'testTag', '%{public}s', args)
  }
}