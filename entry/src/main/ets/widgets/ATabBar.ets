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
  // 0 = 与文字同宽；>0 = 固定宽度（会被限制在文字宽度内，避免撑大 tab）
  @Param indicatorWidth: number = 0
  @Param indicatorRadius: number = 0
  // 线形 indicator 距上 / 下边缘的距离
  @Param indicatorSpacing: number = 4
  // 圆角矩形背景相对文字的左右内边距
  @Param indicatorHorizontalPadding: number = 12
  // 选中项滚动居中的基准，默认按屏幕居中
  @Param centerMode: ATabBarCenterMode = ATabBarCenterMode.Screen

  @BuilderParam leftBuilder?: () => void
  @BuilderParam rightBuilder?: () => void
  // 自定义 indicator 绘制：只在选中 tab 下渲染，随选中项移动；不传基本类型参数（V2 下按值传递不会刷新）
  @BuilderParam customIndicator?: () => void
  @Event onChange: (index: number) => void

  @Local currentSelectedIndex: number = 0
  // 选中态文字宽度：决定 indicator 默认宽度
  @Local selectedTitleWidths: number[] = []
  // 两态文字宽度取大：滚动居中用，避免未选中字号更大时算错
  @Local scrollTitleWidths: number[] = []
  private scroller: Scroller = new Scroller()
  // List 实测宽度：仅 VisibleArea 模式用作居中基准，或屏幕宽度未就绪时兜底
  private listWidth: number = 0

  aboutToAppear(): void {
    this.rebuildTitleWidths()
    this.currentSelectedIndex = this.index
  }

  @Monitor('tabList')
  onTabListChanged(): void {
    this.rebuildTitleWidths()
    this.scrollToCenter(this.currentIndex)
  }

  @Monitor('index', 'currentSelectedIndex')
  onSelectedIndexChanged(): void {
    this.scrollToCenter(this.currentIndex)
  }

  @Monitor('centerMode')
  onCenterModeChanged(): void {
    this.scrollToCenter(this.currentIndex)
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
    const selected: number[] = []
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
      selected.push(selectedWidth)
      scroll.push(Math.max(selectedWidth, unselectedWidth))
    })
    this.selectedTitleWidths = selected
    this.scrollTitleWidths = scroll
  }

  private indicatorWidthAt(index: number): number {
    const textWidth: number = index >= 0 && index < this.selectedTitleWidths.length ?
      this.selectedTitleWidths[index] : 0
    if (this.indicatorWidth <= 0) {
      return textWidth
    }
    return textWidth > 0 ? Math.min(this.indicatorWidth, textWidth) : this.indicatorWidth
  }

  build() {
    Row() {
      if (this.leftBuilder) {
        this.leftBuilder()
      }
      List({ scroller: this.scroller }) {
        ForEach(this.tabList, (item: string, index: number) => {
          ListItem() {
            this.tabItem(item, index)
          }
          .padding({
            left: index === 0 ? this.uniformPadding : this.tabSpacing,
            right: index === this.tabList.length - 1 ? this.uniformPadding : this.tabSpacing
          })
          .onClick(() => {
            if (this.isSelected(index)) {
              return
            }
            if (!this.useOuterIndex) {
              this.currentSelectedIndex = index
            }
            this.onChange(index)
          })
        }, (item: string, index: number) => `${index}_${item}`)
      }
      .layoutWeight(1)
      .height(this.tabHeight)
      .listDirection(Axis.Horizontal)
      .alignListItem(ListItemAlign.Center)
      .edgeEffect(EdgeEffect.None)
      .scrollBar(BarState.Off)
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
    Stack({ alignContent: Alignment.Center }) {
      Text(title)
        .fontSize(this.isSelected(index) ? this.selectedFontSize : this.unselectedFontSize)
        .fontWeight(this.isSelected(index) ? this.selectedFontWeight : this.unselectedFontWeight)
        .fontColor(this.isSelected(index) ? this.selectedFontColor : this.unselectedFontColor)
        .maxLines(1)

      if (this.showIndicator && this.isSelected(index) &&
        this.indicatorShape === ATabBarIndicatorShape.Custom) {
        // 只挂在选中项下：分支随 isSelected 切换而创建 / 销毁，indicator 自然跟着选中项走
        if (this.customIndicator) {
          this.customIndicator()
        }
      } else if (this.showIndicator && this.isSelected(index) &&
        (this.indicatorShape === ATabBarIndicatorShape.TopLine ||
          this.indicatorShape === ATabBarIndicatorShape.BottomLine)) {
        this.lineIndicator(index)
      }
    }
    .height(this.isRoundedRect() ? this.indicatorHeight : this.tabHeight)
    .padding({ left: this.innerPadding(), right: this.innerPadding() })
    .borderRadius(this.isRoundedRect() ? this.indicatorRadius : 0)
    .backgroundColor(this.isRoundedRect() && this.isSelected(index) ? this.indicatorColor : Color.Transparent)
  }

  // indicator 用 Stack 子节点 + offset 绘制，脱离布局，不会像 borderWidth 那样挤压文字
  @Builder
  lineIndicator(index: number) {
    Column() {}
      .width(this.indicatorWidthAt(index))
      .height(this.indicatorHeight)
      .borderRadius(this.indicatorRadius)
      .backgroundColor(this.indicatorColor)
      .offset({
        x: 0,
        y: (this.indicatorShape === ATabBarIndicatorShape.TopLine ? -1 : 1) *
          (this.tabHeight / 2 - this.indicatorHeight / 2 - this.indicatorSpacing)
      })
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
    // 窗口宽度尚未就绪时（首帧）退回 List 实测宽度兜底
    return windowWidth > 0 ? windowWidth : this.listWidth
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
