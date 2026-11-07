import { AppStorageV2 } from '@kit.ArkUI'

/**
 * 全局常量：provider / consumer 的 key、标题栏对齐方式、圆角与尺寸。
 * 颜色统一放在 resources/base/element/color.json（含 dark 变体），此处只放与布局相关的常量。
 */

/** 标题栏文字对齐方式 */
export enum AppTitleAlign {
  Start = 0,
  Center = 1
}

export class Constants {
  /** NavPathStack 在 @Provider / @Consumer 之间共享的 key */
  static readonly pageNavStack: string = 'pageNavStack'
  /** 全局「标题居左 / 居中」设置项的 AppStorage key */
  static readonly titleAlignKey: string = 'app_title_align'
  /** -1 表示跟随全局设置，页面可显式传 0/1 覆盖 */
  static readonly followGlobalTitleAlign: number = -1

  /**
   * 全局唯一的导航栈。
   * Index 的 @Provider 和各组件 @Consumer 的默认值都指向它：
   * 即使 @Consumer 因 V1/V2 混合组件树没匹配到 @Provider，也不会退化成孤立空栈导致返回失效。
   */
  static readonly navStack: NavPathStack = new NavPathStack()
}

export class AppRadius {
  /** 列表 item / 卡片 */
  static readonly item: number = 6
  /** 常见弹窗 / popup */
  static readonly dialog: number = 6
  /** 屏幕级弹窗 / 半模态 bindSheet */
  static readonly screenSheet: number = 6
}

/**
 * 全局「标题居左 / 居中」设置。V2 没有 @StorageProp，
 * 改用 AppStorageV2 + @ObservedV2/@Trace：读写同一实例，字段变化自动刷新所有订阅组件。
 */
@ObservedV2
export class TitleAlignState {
  @Trace align: number = AppTitleAlign.Center
}

export function appTitleAlign(): TitleAlignState {
  const state: TitleAlignState | undefined =
    AppStorageV2.connect(TitleAlignState, Constants.titleAlignKey, () => new TitleAlignState())
  return state ?? new TitleAlignState()
}

export class AppSize {
  static readonly titleBarHeight: number = 56
  static readonly backHitSize: number = 40
  static readonly backIconSize: number = 25
  static readonly titleBarPadding: number = 16
  static readonly titleFontSize: number = 18
}
