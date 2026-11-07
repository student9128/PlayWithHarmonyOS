import { AdaptiveUtils } from '../breakpoint/AdaptiveUtils'

export class MNavigationBarItem {
  label: string
  icon: ResourceStr
  activeIcon: ResourceStr

  constructor(label: string, icon: ResourceStr, activeIcon?: ResourceStr) {
    this.label = label
    this.icon = icon
    this.activeIcon = activeIcon ?? icon
  }
}

/**
 * Material Design 3 风格底部导航栏（Navigation Bar）。
 *
 * 与 ATabBar / BTabBar 的相同点：整条 bar 只有一枚 indicator 实例，
 * 用 .position + .translate（渲染层变换）在各项之间滑动，再由 .animation 补间；
 * swipeProgress >= 0 时按浮点页索引逐帧跟手，跟手阶段关闭补间避免滞后。
 *
 * 不同点：
 * - 项数固定，用 Flex 等分铺满，不需要 Scroll，也不做「点击滚动到居中」；
 * - indicator 是图标后面的一枚药丸形 active indicator（M3 规范 64x32 全圆角）；
 * - 位置由 barWidth / itemCount 直接推算，不测量文字宽度，无测量误差累积。
 */
@ComponentV2
export struct MNavigationBar {
  @Require @Param items: MNavigationBarItem[]
  @Param index: number = 0
  @Param useOuterIndex: boolean = false
  /** -1 表示未在侧滑；>=0 为浮点页索引，由 Swiper.onContentDidScroll 逐帧驱动 */
  @Param swipeProgress: number = -1
  @Event onChange?: (index: number) => void

  // 尺寸
  @Param barHeight: number = 80
  @Param indicatorWidth: number = 64
  @Param indicatorHeight: number = 32
  @Param indicatorRadius: number = 16
  @Param indicatorTop: number = 12
  @Param iconSize: number = 24
  @Param labelFontSize: number = 12
  @Param labelSpacing: number = 4
  // 颜色
  @Param barBackgroundColor: ResourceColor = $r('app.color.app_surface_variant')
  @Param indicatorColor: ResourceColor = $r('app.color.app_primary_container')
  @Param iconColor: ResourceColor = $r('app.color.app_on_surface_variant')
  @Param activeIconColor: ResourceColor = $r('app.color.app_on_primary_container')
  @Param labelColor: ResourceColor = $r('app.color.app_on_surface')

  @Param labelFontWeight: number = 400
  @Param activeLabelFontWeight: number = 700
  @Param enableIndicatorAnimation: boolean = true
  @Param indicatorDuration: number = 250
  /**
   * 让 bar 背景延伸进底部系统安全区（手势条 / 三键导航栏）。
   * expandSafeArea 只扩展绘制区域、不改变布局尺寸，所以背景能盖住手势条那一块，
   * 而图标与文字仍停在安全区之上，不会被手势条压住。
   */
  @Param expandToSafeArea: boolean = true

  @Local currentSelectedIndex: number = 0
  @Local barWidth: number = 0
  @Local indicatorX: number = 0

  aboutToAppear(): void {
    this.currentSelectedIndex = this.index
    this.applyIndicator()
  }

  @Monitor('items')
  onItemsChanged(): void {
    this.applyIndicator()
  }

  @Monitor('index', 'currentSelectedIndex')
  onSelectedIndexChanged(): void {
    this.applyIndicator()
  }

  @Monitor('swipeProgress')
  onSwipeProgressChanged(): void {
    this.applyIndicator()
  }

  @Computed
  private get currentIndex(): number {
    const raw: number = this.useOuterIndex ? this.index : this.currentSelectedIndex
    return raw >= 0 && raw < this.items.length ? raw : 0
  }

  // 直接读 @Param / @Local，保证 ForEach 的 item builder 能跟踪选中态变化
  private isSelected(index: number): boolean {
    const raw: number = this.useOuterIndex ? this.index : this.currentSelectedIndex
    return raw === index
  }

  private itemWidth(): number {
    const count: number = this.items.length
    if (count <= 0) {
      return 0
    }
    const width: number = this.barWidth > 0 ? this.barWidth : AdaptiveUtils.windowWidth()
    return width / count
  }

  /** 整数页 index 对应的 indicator 左边界（bar 内容坐标系）。 */
  private indicatorXAt(index: number): number {
    const width: number = this.itemWidth()
    return index * width + (width - this.indicatorWidth) / 2
  }

  /** 跟手时在相邻两页之间线性插值；否则落在整数页，由 .animation 补间。 */
  private applyIndicator(): void {
    const last: number = this.items.length - 1
    if (last < 0) {
      return
    }
    const progress: number = this.swipeProgress
    if (progress >= 0 && progress <= last) {
      const from: number = Math.floor(progress)
      const to: number = Math.min(from + 1, last)
      const fraction: number = progress - from
      const xFrom: number = this.indicatorXAt(from)
      this.indicatorX = xFrom + (this.indicatorXAt(to) - xFrom) * fraction
    } else {
      this.indicatorX = this.indicatorXAt(this.currentIndex)
    }
  }

  private indicatorDurationMs(): number {
    if (this.swipeProgress >= 0) {
      return 0
    }
    return this.enableIndicatorAnimation ? this.indicatorDuration : 0
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 唯一的 indicator：位于下层，不遮挡图标、不拦截点击
      if (this.items.length > 0) {
        Column() {}
          .width(this.indicatorWidth)
          .height(this.indicatorHeight)
          .borderRadius(this.indicatorRadius)
          .backgroundColor(this.indicatorColor)
          .position({ x: 0, y: this.indicatorTop })
          .translate({ x: this.indicatorX })
          .animation({ duration: this.indicatorDurationMs(), curve: Curve.EaseInOut })
          .hitTestBehavior(HitTestMode.Transparent)
      }

      // 固定项数、Flex 等分：不需要 Scroll，也不做居中滚动
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceEvenly,
        alignItems: ItemAlign.Center }) {
        ForEach(this.items, (item: MNavigationBarItem, index: number) => {
          this.navItem(item, index)
        }, (item: MNavigationBarItem, index: number) => `${index}_${item.label}`)
      }
      .width('100%')
      .height(this.barHeight)
    }
    .width('100%')
    .height(this.barHeight)
    .backgroundColor(this.barBackgroundColor)
    // 背景铺进底部安全区，避免 bar 下面露出页面底色（视觉上「没挡住」）
    .expandSafeArea([SafeAreaType.SYSTEM], this.expandToSafeArea ? [SafeAreaEdge.BOTTOM] : [])
    .onAreaChange((_oldValue: Area, newValue: Area) => {
      const width: number = Number(newValue.width)
      if (width > 0 && width !== this.barWidth) {
        this.barWidth = width
        this.applyIndicator()
      }
    })
  }

  @Builder
  navItem(item: MNavigationBarItem, index: number) {
    Column() {
      Column() {
        Image(this.isSelected(index) ? item.activeIcon : item.icon)
          .width(this.iconSize)
          .height(this.iconSize)
          .fillColor(this.isSelected(index) ? this.activeIconColor : this.iconColor)
      }
      .width(this.indicatorWidth)
      .height(this.indicatorHeight)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      Text(item.label)
        .fontSize(this.labelFontSize)
        .fontWeight(this.isSelected(index) ? this.activeLabelFontWeight : this.labelFontWeight)
        .fontColor(this.labelColor)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Center)
        .width('100%')
        .margin({ top: this.labelSpacing })
    }
    .width(`${100 / this.items.length}%`)
    .height(this.barHeight)
    .padding({ top: this.indicatorTop })
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      if (index === this.currentIndex) {
        return
      }
      if (!this.useOuterIndex) {
        this.currentSelectedIndex = index
      }
      this.onChange?.(index)
    })
  }
}
