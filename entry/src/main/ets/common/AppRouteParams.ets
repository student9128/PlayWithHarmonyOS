import { CustomType } from './RouteConstants'

/**
 * 页面跳转参数的轻量中转。
 * NavDestination 的 @Builder 不是组件、无法持有状态，也不方便透传 param；
 * 这里用 push 前写入 / Builder 与页面读取的方式，避免引入 V1/V2 状态耦合。
 */
export class AppRouteParams {
  static groupTitle: string = ''
  static groupData: CustomType[] = []
}

/** 把 RouteConstants 里的页面路径转成系统路由表里的 name（取最后一段） */
export function toRouteName(page: string): string {
  const parts: string[] = page.split('/')
  return parts[parts.length - 1]
}
