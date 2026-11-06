import { AdaptiveUtils } from '../breakpoint/AdaptiveUtils'

/**
 * indicator 形状：
 * - None        不绘制（等价于 showIndicator = false）
 * - TopLine     上划线
 * - BottomLine  下划线
 * - RoundedRect 圆角矩形背景
 * - Custom      完全交给 customIndicator 自行绘制
 */
export enum ATabBarIndicatorShape {
  None = 0,
  TopLine = 1,
  BottomLine = 2,
  RoundedRect = 3,
  Custom = 4
}

/**
 * 选中项滚动居中的基准宽度：
 * - Screen      以窗口 / 屏幕宽度居中（默认，与 KTabBar 一致）
 * - VisibleArea 以 tab 列表自身可见区域宽度居中（左右插槽 / 外层 padding 较宽时用）
 */
export enum ATabBarCenterMode {
  Screen = 0,
  VisibleArea = 1
}

@ComponentV2
export struct ATabBar {
  @Require @Param tabList: string[]
  @Param index: number = 0
  @Param useOuterIndex: boolean = false
  @Param uniformPadding: number = 16
  @Param tabSpacing: number = 8
  @Param tabHeight: number = 40
  @Param tabBackgroundColor: ResourceColor = Color.White
  @Param unselectedFontSize: number = 14
  @Param selectedFontSize: number = 14
  @Param unselectedFontWeight: number = 400
  @Param selectedFontWeight: number = 600
  @Param unselectedFontColor: ResourceColor = $r('app.color.tab_normal_color')
  @Param selectedFontColor: ResourceColor = $r('app.color.tab_active_color')

  // indicator 总开关：false 时任何形状都不绘制
  @Param showIndicator: boolean = true
  @Param indicatorShape: ATabBarIndicatorShape = ATabBarIndicatorShape.BottomLine
  @Param indicatorColor: ResourceColor = $r('app.color.primary_color')
  // 线形表示粗细，圆角矩形表示背景高度
  @Param indicatorHeight: number = 3
  // 0 = 与文字同宽；>0 = 固定宽度（会被限制在文字宽度内）
  @Param indicatorWidth: number = 0
  @Param indicatorRadius: number = 0
  // 线形 indicator 距上 / 下边缘的距离
  @Param indicatorSpacing: number = 4
  // 圆角矩形背景相对文字的左右内边距
  @Param indicatorHorizontalPadding: number = 12
  // indicator 是否滑动过渡到选中项，默认开启；false 为瞬间切换
  @Param enableIndicatorAnimation: boolean = true
  // 选中项滚动居中的基准，默认按屏幕居中
  @Param centerMode: ATabBarCenterMode = ATabBarCenterMode.Screen

  @BuilderParam leftBuilder?: () => void
  @BuilderParam rightBuilder?: () => void
  // 自定义 indicator：整条 TabBar 只有一个实例，随浮层一起滑动
  @BuilderParam customIndicator?: () => void
  @Event onChange: (index: number) => void

  @Local currentSelectedIndex: number = 0
  // 两态文字宽度取大：既是 tab 宽度基准，也是滚动居中 / indicator 定位的统一依据
  @Local scrollTitleWidths: number[] = []
  // 单一 indicator 浮层在内容坐标系里的位置与宽度
  @Local indicatorX: number = 0
  @Local indicatorW: number = 0
  @Local indicatorShown: boolean = false

  private scroller: Scroller = new Scroller()
  // 列表可视区域宽度：仅 VisibleArea 模式用作居中基准，或屏幕宽度未就绪时兜底
  private listWidth: number = 0

  aboutToAppear(): void {
    this.rebuildTitleWidths()
    this.currentSelectedIndex = this.index
    this.applyIndicator()
  }

  @Monitor('tabList')
  onTabListChanged(): void {
    this.rebuildTitleWidths()
    this.applyIndicator()
    this.scrollToCenter(this.currentIndex)
  }

  @Monitor('index', 'currentSelectedIndex')
  onSelectedIndexChanged(): void {
    this.applyIndicator()
    this.scrollToCenter(this.currentIndex)
  }

  @Monitor('centerMode')
  onCenterModeChanged(): void {
    this.scrollToCenter(this.currentIndex)
  }

  @Monitor('showIndicator', 'indicatorShape')
  onIndicatorStyleChanged(): void {
    this.applyIndicator()
  }

  @Computed
  private get currentIndex(): number {
    const raw: number = this.useOuterIndex ? this.index : this.currentSelectedIndex
    return raw >= 0 && raw < this.tabList.length ? raw : 0
  }

  // 直接读 @Param / @Local，保证 ForEach 的 item builder 能跟踪选中态变化
  private isSelected(index: number): boolean {
    const raw: number = this.useOuterIndex ? this.index : this.currentSelectedIndex
    return raw === index
  }

  private isRoundedRect(): boolean {
    return this.showIndicator && this.indicatorShape === ATabBarIndicatorShape.RoundedRect
  }

  private innerPadding(): number {
    return this.isRoundedRect() ? this.indicatorHorizontalPadding : 0
  }

  private rebuildTitleWidths(): void {
    const scroll: number[] = []
    this.tabList.forEach((title: string) => {
      const selectedWidth: number =
        this.getUIContext().px2vp(this.getUIContext().getMeasureUtils().measureText({
          textContent: title,
          fontSize: this.selectedFontSize,
          fontWeight: this.selectedFontWeight
        }))
      const unselectedWidth: number =
        this.getUIContext().px2vp(this.getUIContext().getMeasureUtils().measureText({
          textContent: title,
          fontSize: this.unselectedFontSize,
          fontWeight: this.unselectedFontWeight
        }))
      scroll.push(Math.max(selectedWidth, unselectedWidth))
    })
    this.scrollTitleWidths = scroll
  }

  build() {
    Row() {
      if (this.leftBuilder) {
        this.leftBuilder()
      }
      Scroll(this.scroller) {
        Row() {
          // indicator 声明在 tab 之前：位于下层，不遮挡文字、不拦截点击
          this.indicatorLayer()
          ForEach(this.tabList, (item: string, index: number) => {
            this.tabItem(item, index)
          }, (item: string, index: number) => `${index}_${item}`)
        }
        .width(this.totalWidth())
        .height(this.tabHeight)
      }
      .layoutWeight(1)
      .height(this.tabHeight)
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.None)
      .onAreaChange((_oldValue: Area, newValue: Area) => {
        const width: number = Number(newValue.width)
        if (width <= 0 || width === this.listWidth) {
          return
        }
        this.listWidth = width
        // 宽度变化（分屏 / 横竖屏 / 左右插槽出现）也重新居中，同样带动画
        this.scrollToCenter(this.currentIndex)
      })

      if (this.rightBuilder) {
        this.rightBuilder()
      }
    }
    .width('100%')
    .height(this.tabHeight)
    .backgroundColor(this.tabBackgroundColor)
  }

  @Builder
  tabItem(title: string, index: number) {
    // 宽度显式固定为 itemWidth(index)，因此内容坐标可由 itemWidth 精确累加，
    // 不需要 onAreaChange 采集位置，也不会有测量误差累积或布局抖动打断动画。
    Column() {
      Text(title)
        .fontSize(this.isSelected(index) ? this.selectedFontSize : this.unselectedFontSize)
        .fontWeight(this.isSelected(index) ? this.selectedFontWeight : this.unselectedFontWeight)
        .fontColor(this.isSelected(index) ? this.selectedFontColor : this.unselectedFontColor)
        .maxLines(1)
    }
    .width(this.itemWidth(index))
    .height(this.tabHeight)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      if (this.isSelected(index)) {
        return
      }
      if (!this.useOuterIndex) {
        this.currentSelectedIndex = index
      }
      this.onChange(index)
    })
  }

  // 整条 TabBar 唯一的 indicator 实例：
  // 布局位置固定在内容原点，位移交给 .translate（渲染层变换，不触发布局重排），
  // 再用 .animation() 属性动画补间 —— 与官方 Tabs indicator 的滑动机制一致。
  // 因为它仍在 Scroll 的内容坐标系内，滚动时天然与 tab 同步，无需监听滚动偏移。
  @Builder
  indicatorLayer() {
    if (this.indicatorShown) {
      if (this.indicatorShape === ATabBarIndicatorShape.Custom) {
        Column() {
          if (this.customIndicator) {
            this.customIndicator()
          }
        }
        .width(this.indicatorW)
        .height(this.tabHeight)
        .justifyContent(FlexAlign.End)
        .alignItems(HorizontalAlign.Center)
        .position({ x: 0, y: 0 })
        .translate({ x: this.indicatorX, y: 0 })
        .animation({ duration: this.indicatorDuration(), curve: Curve.EaseInOut })
        .hitTestBehavior(HitTestMode.Transparent)
      } else {
        Column() {}
          .width(this.indicatorW)
          .height(this.indicatorHeight)
          .borderRadius(this.indicatorRadius)
          .backgroundColor(this.indicatorColor)
          .position({ x: 0, y: 0 })
          .translate({ x: this.indicatorX, y: this.indicatorY() })
          .animation({ duration: this.indicatorDuration(), curve: Curve.EaseInOut })
          .hitTestBehavior(HitTestMode.Transparent)
      }
    }
  }

  private indicatorDuration(): number {
    return this.enableIndicatorAnimation ? 250 : 0
  }

  private indicatorY(): number {
    if (this.indicatorShape === ATabBarIndicatorShape.RoundedRect) {
      return (this.tabHeight - this.indicatorHeight) / 2
    }
    return this.indicatorShape === ATabBarIndicatorShape.TopLine ?
      this.indicatorSpacing : this.tabHeight - this.indicatorHeight - this.indicatorSpacing
  }

  /** 计算选中项的 indicator 位置；x / 宽度由 .animation() 自动补间到新值。 */
  private applyIndicator(): void {
    const index: number = this.currentIndex
    if (!this.showIndicator || this.indicatorShape === ATabBarIndicatorShape.None ||
      index < 0 || index >= this.scrollTitleWidths.length) {
      this.indicatorShown = false
      return
    }
    let itemX: number = 0
    for (let i = 0; i < index; i++) {
      itemX += this.itemWidth(i)
    }
    const itemW: number = this.itemWidth(index)
    let x: number = itemX
    let w: number = itemW
    if (this.indicatorShape === ATabBarIndicatorShape.TopLine ||
      this.indicatorShape === ATabBarIndicatorShape.BottomLine) {
      const textW: number = this.scrollTitleWidths[index]
      w = this.indicatorWidth > 0 ? Math.min(this.indicatorWidth, textW) : textW
      x = itemX + (itemW - w) / 2
    }
    this.indicatorX = x
    this.indicatorW = w
    this.indicatorShown = true
  }

  // 所有来源（点击 / 外部 index / tabList / 宽度变化）统一走带动画的同一条路径，
  // 避免无动画的 scrollTo 打断正在进行的滚动动画，造成"跳一下"的生硬感。
  private scrollToCenter(index: number): void {
    if (this.scrollTitleWidths.length === 0 ||
      index < 0 || index >= this.scrollTitleWidths.length) {
      return
    }
    const centerWidth: number = this.centerWidth()
    if (centerWidth <= 0) {
      return
    }
    let offset: number = 0
    for (let i = 0; i < index; i++) {
      offset += this.itemWidth(i)
    }
    const itemCenter: number = offset + this.itemWidth(index) / 2
    this.scroller.scrollTo({
      xOffset: Math.max(itemCenter - centerWidth / 2, 0),
      yOffset: 0,
      animation: true
    })
  }

  private centerWidth(): number {
    if (this.centerMode === ATabBarCenterMode.VisibleArea && this.listWidth > 0) {
      return this.listWidth
    }
    const windowWidth: number = AdaptiveUtils.windowWidth()
    // 窗口宽度尚未就绪时（首帧）退回列表实测宽度兜底
    return windowWidth > 0 ? windowWidth : this.listWidth
  }

  private totalWidth(): number {
    let total: number = 0
    for (let i = 0; i < this.scrollTitleWidths.length; i++) {
      total += this.itemWidth(i)
    }
    return total
  }

  private itemWidth(index: number): number {
    return this.itemLeftPadding(index) + this.contentWidth(index) + this.itemRightPadding(index)
  }

  private contentWidth(index: number): number {
    return this.scrollTitleWidths[index] + this.innerPadding() * 2
  }

  private itemLeftPadding(index: number): number {
    return index === 0 ? this.uniformPadding : this.tabSpacing
  }

  private itemRightPadding(index: number): number {
    return index === this.tabList.length - 1 ? this.uniformPadding : this.tabSpacing
  }
}
