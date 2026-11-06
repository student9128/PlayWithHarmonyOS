import { AdaptiveUtils } from '../breakpoint/AdaptiveUtils'

/**
 * 圆角背景 indicator + 背景内文字反色（微信顶部 tab 那种效果）。
 *
 * 实现：底层一整行黑色文字，上层一个与 indicator 同宽同位置的「裁剪窗口」，
 * 窗口内放一整行白色文字并用 translate(-indicatorX) 反向抵消窗口位移，
 * 于是只有被红底覆盖的笔画显示为白色，窗口外的笔画仍是黑色。
 *
 * 逐帧跟手时只改 indicatorX / indicatorW 两个 @Local，全部是渲染层变换，
 * 不新增逐帧状态、不触发布局重排；代价是文字节点数翻倍（2N 个静态 Text）。
 *
 * 约束：两层文字必须像素级重合，所以选中/未选中不能改字号与字重，仅由反色区分。
 */
@ComponentV2
export struct BTabBar {
  @Require @Param tabList: string[]
  @Param index: number = 0
  @Param useOuterIndex: boolean = false
  // 侧滑跟手进度：浮点页索引（>=0 生效）；-1 表示未在侧滑
  @Param swipeProgress: number = -1

  @Param tabHeight: number = 46
  @Param uniformPadding: number = 16
  @Param tabSpacing: number = 8
  @Param fontSize: number = 15
  @Param fontWeight: number = 500
  @Param tabBackgroundColor: ResourceColor = Color.White
  // 背景外文字颜色
  @Param textColor: ResourceColor = '#182431'
  // 背景内文字颜色
  @Param activeTextColor: ResourceColor = Color.White
  @Param indicatorColor: ResourceColor = '#FA7070'
  @Param indicatorHeight: number = 30
  @Param indicatorRadius: number = 15
  @Param indicatorHorizontalPadding: number = 14
  // 是否启用像素级反色；false 退化为「整个选中 tab 文字变白」的普通写法，用于 demo 对比
  @Param reverseText: boolean = true

  @Event onChange: (index: number) => void

  @Local currentSelectedIndex: number = 0
  @Local titleWidths: number[] = []
  @Local indicatorX: number = 0
  @Local indicatorW: number = 0
  @Local indicatorShown: boolean = false

  private scroller: Scroller = new Scroller()
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

  @Monitor('swipeProgress')
  onSwipeProgressChanged(): void {
    this.applyIndicator()
  }

  @Computed
  private get currentIndex(): number {
    const raw: number = this.useOuterIndex ? this.index : this.currentSelectedIndex
    return raw >= 0 && raw < this.tabList.length ? raw : 0
  }

  private isSelected(index: number): boolean {
    const raw: number = this.useOuterIndex ? this.index : this.currentSelectedIndex
    return raw === index
  }

  private rebuildTitleWidths(): void {
    const widths: number[] = []
    this.tabList.forEach((title: string) => {
      widths.push(this.getUIContext().px2vp(this.getUIContext().getMeasureUtils().measureText({
        textContent: title,
        fontSize: this.fontSize,
        fontWeight: this.fontWeight
      })))
    })
    this.titleWidths = widths
  }

  private indicatorY(): number {
    return (this.tabHeight - this.indicatorHeight) / 2
  }

  private indicatorXAt(index: number): number {
    let x: number = 0
    for (let i = 0; i < index; i++) {
      x += this.itemWidth(i)
    }
    return x
  }

  private indicatorWAt(index: number): number {
    return this.itemWidth(index)
  }

  /** 跟手时按浮点页索引在相邻两页之间插值，宽度也一起渐变。 */
  private applyIndicator(): void {
    const last: number = this.titleWidths.length - 1
    if (last < 0) {
      this.indicatorShown = false
      return
    }
    const progress: number = this.swipeProgress
    if (progress >= 0 && progress <= last) {
      const from: number = Math.floor(progress)
      const to: number = Math.min(from + 1, last)
      const fraction: number = progress - from
      const xFrom: number = this.indicatorXAt(from)
      const wFrom: number = this.indicatorWAt(from)
      this.indicatorX = xFrom + (this.indicatorXAt(to) - xFrom) * fraction
      this.indicatorW = wFrom + (this.indicatorWAt(to) - wFrom) * fraction
    } else {
      this.indicatorX = this.indicatorXAt(this.currentIndex)
      this.indicatorW = this.indicatorWAt(this.currentIndex)
    }
    this.indicatorShown = true
  }

  private indicatorDuration(): number {
    // 跟手阶段关掉补间，避免窗口与内层文字的动画相位差导致边界错位
    return this.swipeProgress >= 0 ? 0 : 250
  }

  build() {
    Scroll(this.scroller) {
      Row() {
        // 1. 最底层：红色圆角背景（绘制在下层，不遮挡文字）
        if (this.indicatorShown) {
          Column() {}
            .width(this.indicatorW)
            .height(this.indicatorHeight)
            .backgroundColor(this.indicatorColor)
            .borderRadius(this.indicatorRadius)
            .position({ x: 0, y: 0 })
            .translate({ x: this.indicatorX, y: this.indicatorY() })
            .animation({ duration: this.indicatorDuration(), curve: Curve.EaseInOut })
            .hitTestBehavior(HitTestMode.Transparent)
        }

        // 2. 中层：文字 + 点击区（反色开启时全黑，关闭时选中项整字变白）
        ForEach(this.tabList, (item: string, index: number) => {
          Column() {
            Text(item)
              .fontSize(this.fontSize)
              .fontWeight(this.fontWeight)
              .fontColor(!this.reverseText && this.isSelected(index) ?
                this.activeTextColor : this.textColor)
              .maxLines(1)
          }
          .width(this.itemWidth(index))
          .height(this.tabHeight)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .onClick(() => {
            if (index === this.currentIndex) {
              return
            }
            if (!this.useOuterIndex) {
              this.currentSelectedIndex = index
            }
            this.onChange(index)
          })
        }, (item: string, index: number) => `${index}_${item}`)

        // 3. 最上层：与红底同形同位置的透明裁剪窗口，只露出窗口内的白色文字
        if (this.indicatorShown && this.reverseText) {
          Stack({ alignContent: Alignment.TopStart }) {
            Row() {
              ForEach(this.tabList, (item: string, index: number) => {
                Column() {
                  Text(item)
                    .fontSize(this.fontSize)
                    .fontWeight(this.fontWeight)
                    .fontColor(this.activeTextColor)
                    .maxLines(1)
                }
                .width(this.itemWidth(index))
                .height(this.tabHeight)
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
              }, (item: string, index: number) => `reverse_${index}_${item}`)
            }
            .width(this.totalWidth())
            .height(this.tabHeight)
            // 反向抵消窗口位移，让窗口内的白字与底层黑字像素级重合
            .translate({ x: -this.indicatorX, y: -this.indicatorY() })
            .animation({ duration: this.indicatorDuration(), curve: Curve.EaseInOut })
          }
          .width(this.indicatorW)
          .height(this.indicatorHeight)
          .borderRadius(this.indicatorRadius)
          .clip(true)
          .position({ x: 0, y: 0 })
          .translate({ x: this.indicatorX, y: this.indicatorY() })
          .animation({ duration: this.indicatorDuration(), curve: Curve.EaseInOut })
          .hitTestBehavior(HitTestMode.Transparent)
        }
      }
      .width(this.totalWidth())
      .height(this.tabHeight)
    }
    .width('100%')
    .height(this.tabHeight)
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.None)
    .backgroundColor(this.tabBackgroundColor)
    .onAreaChange((_oldValue: Area, newValue: Area) => {
      const width: number = Number(newValue.width)
      if (width <= 0 || width === this.listWidth) {
        return
      }
      this.listWidth = width
      this.scrollToCenter(this.currentIndex)
    })
  }

  private scrollToCenter(index: number): void {
    if (this.titleWidths.length === 0 ||
      index < 0 || index >= this.titleWidths.length) {
      return
    }
    const visibleWidth: number = this.listWidth > 0 ? this.listWidth : AdaptiveUtils.windowWidth()
    if (visibleWidth <= 0) {
      return
    }
    let offset: number = 0
    for (let i = 0; i < index; i++) {
      offset += this.itemWidth(i)
    }
    const itemCenter: number = offset + this.itemWidth(index) / 2
    this.scroller.scrollTo({
      xOffset: Math.max(itemCenter - visibleWidth / 2, 0),
      yOffset: 0,
      animation: true
    })
  }

  private totalWidth(): number {
    let total: number = 0
    for (let i = 0; i < this.titleWidths.length; i++) {
      total += this.itemWidth(i)
    }
    return total
  }

  private itemWidth(index: number): number {
    return this.itemLeftPadding(index) + this.contentWidth(index) + this.itemRightPadding(index)
  }

  private contentWidth(index: number): number {
    return this.titleWidths[index] + this.indicatorHorizontalPadding * 2
  }

  private itemLeftPadding(index: number): number {
    return index === 0 ? this.uniformPadding : this.tabSpacing
  }

  private itemRightPadding(index: number): number {
    return index === this.tabList.length - 1 ? this.uniformPadding : this.tabSpacing
  }
}
