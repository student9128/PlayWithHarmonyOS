import hilog from '@ohos.hilog'

export default class LogUtils {
  static printInfo(...args: ESObject[]) {
    hilog.info(0x0000, 'testTag', '%{public}s', args)
  }

  static printError(...args: ESObject[]) {
    hilog.error(0x0000, 'testTag', '%{public}s', args)
  }
}

export function  printInfo(...args: ESObject[]) {
  hilog.info(0x0000, 'testTag', '%{public}s', args)
}

export function printError(...args: ESObject[]) {
  hilog.error(0x0000, 'testTag', '%{public}s', args)
}