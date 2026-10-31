import { AppStorageV2 } from '@kit.ArkUI'
import { BreakpointConstants } from './BreakpointConstants'
import { BreakpointObservedV2, WindowStatusObservedV2, WindowWidthObservedV2 } from './BreakpointType'

/**
 * 屏幕 / 窗口适配工具类
 *
 * 减少每个组件都要自己 connect 全局状态（断点 / 窗口模式 / 窗口宽度），
 *
 * ```ets
 * if (AdaptiveUtils.isExpandedLayout()) { ... }
 * const ratio = AdaptiveUtils.pick(0.4, 0.75)
 * ```
 *
 */
export class AdaptiveUtils {

  /**
   * 是否处于分屏 / 自由悬浮窗
   */
  static isSplitOrFloating(): boolean {
    const status: number = AdaptiveUtils.windowStatusValue()
    return BreakpointConstants.NON_FULLSCREEN_WINDOW_STATUS.indexOf(status) >= 0
  }

  /** 当前宽度断点（xs / sm / md / lg / xl）；尚未就绪时返回空串 */
  static currentBreakpoint(): string {
    return AdaptiveUtils.breakpointState()?.value ?? ''
  }

  /**
   * 当前**窗口**宽度 尚未就绪时返回 0，调用方按需兜底。
   *
   * 与 screenWidth 的区别：分屏时本值变小，screenWidth（物理显示屏宽）不变。
   * 需要按"可用宽度"算具体尺寸时用这个，不要用 screenWidth。
   */
  static windowWidth(): number {
    return AdaptiveUtils.windowWidthState()?.value ?? 0
  }

  /**
   * 是否窄屏断点（xs / sm）
   * 断点尚未就绪时保守按窄屏处理，避免首帧用大屏比例导致溢出。
   */
  static isNarrowBreakpoint(): boolean {
    const bp: string = AdaptiveUtils.currentBreakpoint()
    if (bp.length === 0) {
      return true
    }
    return BreakpointConstants.NARROW_BREAKPOINTS.indexOf(bp) >= 0
  }

  /**
   * 是否应展示"大页面"布局 = 非分屏/悬浮窗 且 非窄屏断点。
   *
   * 折叠屏展开 ~740vp 落在 md 断点，与分屏后的宽度重叠，
   * 所以"分屏"必须靠窗口模式区分，不能只比宽度。
   */
  static isExpandedLayout(): boolean {
    return !AdaptiveUtils.isSplitOrFloating() && !AdaptiveUtils.isNarrowBreakpoint()
  }

  /** 是否应展示"小页面"布局 */
  static isCompactLayout(): boolean {
    return !AdaptiveUtils.isExpandedLayout()
  }

  /** 大页面取 expanded，小页面取 compact */
  static pick<T>(expanded: T, compact: T): T {
    return AdaptiveUtils.isExpandedLayout() ? expanded : compact
  }

  private static breakpointState(): BreakpointObservedV2 | undefined {
    return AppStorageV2.connect(BreakpointObservedV2, BreakpointConstants.currentWidthBreakpoint,
      () => new BreakpointObservedV2())
  }

  private static windowStatusValue(): number {
    const state: WindowStatusObservedV2 | undefined =
      AppStorageV2.connect(WindowStatusObservedV2, BreakpointConstants.currentWindowStatus,
        () => new WindowStatusObservedV2())
    return state?.value ?? BreakpointConstants.WINDOW_STATUS_UNDEFINED
  }

  private static windowWidthState(): WindowWidthObservedV2 | undefined {
    return AppStorageV2.connect(WindowWidthObservedV2, BreakpointConstants.currentWindowWidthVp,
      () => new WindowWidthObservedV2())
  }
}
