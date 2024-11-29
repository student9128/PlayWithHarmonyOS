import { display } from "@kit.ArkUI"
import assertContain from "@ohos/hypium/src/main/module/assert/assertContain"
import assertLarger from "@ohos/hypium/src/main/module/assert/assertLarger"
import assertPosUnlimited from "@ohos/hypium/src/main/module/assert/assertPosUnlimited"
import assertDeepEquals from "@ohos/hypium/src/main/module/assert/deepEquals/assertDeepEquals"

export class ScreenUtils {
  static defaultWidth: number = 1080;
  static defaultHeight: number = 1920;
  static screenWidth = 0;
  static screenHeight = 0;
  static uiWidth = this.defaultWidth;
  static uiHeight = this.defaultHeight;
  static scaleWidth = this.screenWidth / this.uiWidth;
  static scaleHeight = this.screenHeight / this.uiHeight;
  static scaledDensity = 1
  static densityPixels=1
  static orientation=0

  /**
   * init
   * @param width ui design width
   * @param height ui design height
   */
  public static init = (width: number = this.defaultWidth, height: number = this.defaultHeight) => {
    assertLarger(width, 0)
    assertLarger(height, 0)
    display.getAllDisplays((error, data) => {
      this.screenWidth = data[0].width;
      this.screenHeight = data[0].height;
      this.scaledDensity = data[0].scaledDensity
      this.densityPixels=data[0].densityPixels
      this.orientation = data[0].orientation
      this.uiWidth = width;
      this.uiHeight = height;
      this.scaleWidth = this.screenWidth / this.uiWidth;
      this.scaleHeight = this.screenHeight / this.uiHeight;
      console.log(`scaleWidth=${this.scaleWidth},scaleHeight=${this.scaleHeight}`)
    });
    console.log(`scaleWidth=${this.scaleWidth},scaleHeight=${this.scaleHeight}`)
  }
}

/**
 * horizontal size
 * @param num
 * @param userAdaptSize
 * @returns
 */
export function wSize(num: number, userAdaptSize: boolean = true) {
  if (userAdaptSize) {
    assertLarger(ScreenUtils.scaleWidth, 0)
    return num * ScreenUtils.scaleWidth
  } else {
    return num
  }
}
/**
 * vertical size
 * @param num
 * @param userAdaptSize
 * @returns
 */
export function hSize(num: number, userAdaptSize: boolean = true) {
  if (userAdaptSize) {
    assertLarger(ScreenUtils.screenHeight, 0)
    return num * ScreenUtils.screenHeight
  } else {
    return num
  }
}
export function fontSize(num:number){
  return num
}

export const scaleDensity = () => ScreenUtils.scaledDensity
export const densityPixels = () => ScreenUtils.densityPixels
export const orientation = () => ScreenUtils.orientation

export function aSize(num: number, type: string = 'vp') {
  if (type != 'vp'&&type != 'px' && type != 'lpx') {
    throw Error("the type is not supported")
  }
  return `${num}${type}`
}
