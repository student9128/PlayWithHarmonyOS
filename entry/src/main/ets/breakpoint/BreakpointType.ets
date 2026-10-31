import { BreakpointConstants } from "./BreakpointConstants";

@ObservedV2
export class BreakpointObservedV2{
  @Trace value:string=''
}

/**
 * 窗口模式，全局共享。由 EntryAbility 通过 windowStatusChange 监听维护。
 *
 * 取值请使用 BreakpointConstants 中定义的语义常量（WINDOW_STATUS_*），
 * 不要直接写 0~5 裸数字：
 *   WINDOW_STATUS_UNDEFINED / FULL_SCREEN / MAXIMIZE / MINIMIZE / FLOATING / SPLIT_SCREEN
 *
 * 与断点互补：断点反映"窗口有多宽"，本值反映"窗口处于什么模式"。
 * 分屏但宽度仍很大时（如 2560 平板分屏成 1280），断点仍是 lg，
 * 只有窗口模式能识别出这是分屏。
 */
@ObservedV2
export class WindowStatusObservedV2{
  @Trace value: number = BreakpointConstants.WINDOW_STATUS_UNDEFINED
}

/**
 * 当前窗口宽度（vp），全局共享。由 EntryAbility 在 updateWidthBp 中维护，
 * 分屏 / 悬浮窗 / 折叠展开 / 旋转时随 windowSizeChange 自动更新。
 *
 * 与 screenWidth 的区别（重要）：
 * - `screenWidth` 来自 display.getAllDisplays()，是**物理显示屏**宽度，分屏时不变。
 * - 本值是**应用窗口**宽度，分屏后会变小。
 *
 * 组件若需按"实际可用宽度"做布局（而非屏幕宽度），应使用本值，
 * 避免分屏时元素超出窗口。
 */
@ObservedV2
export class WindowWidthObservedV2{
  @Trace value: number = 0
}