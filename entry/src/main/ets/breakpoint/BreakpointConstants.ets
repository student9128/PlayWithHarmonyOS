export class BreakpointConstants {
  static readonly currentWidthBreakpoint: string = 'currentWidthBreakpoint'
  static readonly currentHeightBreakpoint: string = 'currentHeightBreakpoint'
  static readonly currentWindowStatus: string = 'currentWindowStatus'
  /**
   * 当前窗口宽度（vp）
   * 注意与 screenWidth（物理显示屏宽度）区分：分屏时本值会变小，screenWidth 不变。
   */
  static readonly currentWindowWidthVp: string = 'currentWindowWidthVp'

  /**
   * Extra small device types (windowWidthVp < 320)。
   */
  static readonly XS: string = 'xs';
  /**
   * Breakpoints that represent small device types.
   */
  static readonly SM: string = 'sm';
  /**
   * Breakpoints that represent middle device types.
   */
  static readonly MD: string = 'md';
  /**
   * Breakpoints that represent large device types.
   */
  static readonly LG: string = 'lg';
  /**
   * Extra large device types (windowWidthVp >= 1440).
   */
  static readonly XL: string = 'xl';
  /**
   *
   * 单一来源，要调断点只改这里
   */
  static readonly BP_XS_MAX: number = 320;    // < 320                    → xs
  static readonly BP_SM_MAX: number = 600;    // 320 ~ 600                → sm
  static readonly BP_MD_MAX: number = 840;    // 600 ~ 840                → md
  static readonly BP_LG_MAX: number = 1440;   // 840 ~ 1440 → lg；≥ 1440  → xl
  /**
   * 窄屏断点：xs / sm 这些断点下按 小屏 处理。
   *
   * 用于区分：
   * - 大屏 / 折叠屏展开（md / lg / xl）→ 走大屏布局
   * - 小屏 / 折叠屏未展开（xs / sm）  → 走小屏布局
   */
  static readonly NARROW_BREAKPOINTS: string[] = [
    BreakpointConstants.XS,
    BreakpointConstants.SM
  ];

  /**
   * 窗口模式：未定义（WindowStatusType.UNDEFINED）。
   */
  static readonly WINDOW_STATUS_UNDEFINED: number = 0;
  /**
   * 窗口模式：全屏（WindowStatusType.FULL_SCREEN）。
   */
  static readonly WINDOW_STATUS_FULL_SCREEN: number = 1;
  /**
   * 窗口模式：最大化（WindowStatusType.MAXIMIZE），PC/2in1 上铺满屏幕且有 dock 栏。
   */
  static readonly WINDOW_STATUS_MAXIMIZE: number = 2;
  /**
   * 窗口模式：最小化（WindowStatusType.MINIMIZE）。
   */
  static readonly WINDOW_STATUS_MINIMIZE: number = 3;
  /**
   * 窗口模式：自由悬浮窗（WindowStatusType.FLOATING）。
   */
  static readonly WINDOW_STATUS_FLOATING: number = 4;
  /**
   * 窗口模式：分屏（WindowStatusType.SPLIT_SCREEN）。
   */
  static readonly WINDOW_STATUS_SPLIT_SCREEN: number = 5;
  /**
   * 需要按"非独占整屏"处理的窗口模式：分屏与自由悬浮窗。
   * 这些模式下窗口可能仍很宽（如 2560 平板分屏成 1280），但语义上不是全屏。
   */
  static readonly NON_FULLSCREEN_WINDOW_STATUS: number[] = [
    BreakpointConstants.WINDOW_STATUS_FLOATING,
    BreakpointConstants.WINDOW_STATUS_SPLIT_SCREEN
  ];


  static getWindowStatusName(status: number): string {
    switch (status) {
      case BreakpointConstants.WINDOW_STATUS_UNDEFINED:
        return 'UNDEFINED';
      case BreakpointConstants.WINDOW_STATUS_FULL_SCREEN:
        return 'FULL_SCREEN';
      case BreakpointConstants.WINDOW_STATUS_MAXIMIZE:
        return 'MAXIMIZE';
      case BreakpointConstants.WINDOW_STATUS_MINIMIZE:
        return 'MINIMIZE';
      case BreakpointConstants.WINDOW_STATUS_FLOATING:
        return 'FLOATING';
      case BreakpointConstants.WINDOW_STATUS_SPLIT_SCREEN:
        return 'SPLIT_SCREEN';
      default:
        return `UNKNOWN(${status})`;
    }
  }
}