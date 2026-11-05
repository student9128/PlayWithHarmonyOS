import { ATabBar, ATabBarCenterMode, ATabBarIndicatorShape } from '../../widgets/ATabBar'
import { CustomTitleBar } from '../../widgets/CustomTitleBar'

@Entry
@ComponentV2
struct ATabBarPage {
  @Local topIndex: number = 0
  @Local bottomIndex: number = 2
  @Local roundedIndex: number = 1
  @Local customIndex: number = 0
  @Local showIndicator: boolean = true
  @Local centerMode: ATabBarCenterMode = ATabBarCenterMode.Screen
  private tabs: string[] = ['推荐', '热点', '财经', '科技', '体育', '娱乐', '汽车', '房产']

  build() {
    RelativeContainer() {
      CustomTitleBar({ title: 'ATabBar' }) {
        Scroll() {
          Column() {
            Button(this.showIndicator ? '点击隐藏 indicator' : '点击显示 indicator')
              .fontSize(14)
              .margin({ top: 12 })
              .onClick(() => {
                this.showIndicator = !this.showIndicator
              })

            Button(this.centerMode === ATabBarCenterMode.Screen ?
              '居中基准：屏幕（点此切 tab 可见区）' : '居中基准：tab 可见区（点此切屏幕）')
              .fontSize(14)
              .margin({ top: 10 })
              .onClick(() => {
                this.centerMode = this.centerMode === ATabBarCenterMode.Screen ?
                  ATabBarCenterMode.VisibleArea : ATabBarCenterMode.Screen
              })

            this.sectionTitle('1. 上划线 TopLine', 'indicatorShape = TopLine，可设粗细 / 圆角 / 距边距离')
            ATabBar({
              tabList: this.tabs,
              index: this.topIndex,
              useOuterIndex: true,
              showIndicator: this.showIndicator,
              centerMode: this.centerMode,
              indicatorShape: ATabBarIndicatorShape.TopLine,
              indicatorColor: '#FA7070',
              indicatorHeight: 3,
              indicatorRadius: 2,
              indicatorSpacing: 2,
              selectedFontColor: '#FA7070',
              onChange: (index: number) => {
                this.topIndex = index
              }
            })

            this.sectionTitle('2. 下划线 BottomLine', 'indicatorWidth = 20 固定短横线；showIndicator 可整体隐藏')
            ATabBar({
              tabList: this.tabs,
              index: this.bottomIndex,
              useOuterIndex: true,
              showIndicator: this.showIndicator,
              centerMode: this.centerMode,
              indicatorShape: ATabBarIndicatorShape.BottomLine,
              indicatorColor: '#4A90E2',
              indicatorWidth: 20,
              indicatorHeight: 4,
              indicatorRadius: 2,
              selectedFontColor: '#4A90E2',
              onChange: (index: number) => {
                this.bottomIndex = index
              }
            })

            this.sectionTitle('3. 圆角矩形背景 RoundedRect', 'indicatorHeight 作为背景高度，选中文字改为白色')
            ATabBar({
              tabList: this.tabs,
              index: this.roundedIndex,
              useOuterIndex: true,
              showIndicator: this.showIndicator,
              centerMode: this.centerMode,
              indicatorShape: ATabBarIndicatorShape.RoundedRect,
              indicatorColor: '#FA7070',
              indicatorHeight: 30,
              indicatorRadius: 15,
              indicatorHorizontalPadding: 14,
              tabHeight: 46,
              selectedFontColor: Color.White,
              onChange: (index: number) => {
                this.roundedIndex = index
              }
            })

            this.sectionTitle('4. 自定义 indicator Custom', 'customIndicator 用 Canvas 自绘「圆角线 + 白点」，点击会跟着选中项移动')
            ATabBar({
              tabList: this.tabs,
              index: this.customIndex,
              useOuterIndex: true,
              showIndicator: this.showIndicator,
              centerMode: this.centerMode,
              indicatorShape: ATabBarIndicatorShape.Custom,
              tabHeight: 46,
              selectedFontColor: '#8E44AD',
              customIndicator: () => {
                this.customIndicatorBuilder()
              },
              onChange: (index: number) => {
                this.customIndex = index
              }
            })

            Text(`当前选中：Top=${this.topIndex} / Bottom=${this.bottomIndex} / ` +
              `Rounded=${this.roundedIndex} / Custom=${this.customIndex}`)
              .fontSize(12)
              .fontColor($r('app.color.text_color'))
              .margin({ top: 20 })
          }
          .width('100%')
          .padding({ left: 12, right: 12, bottom: 24 })
        }
        .width('100%').height('100%')
      }
    }
    .width('100%').height('100%')
  }

  @Builder
  sectionTitle(title: string, desc: string) {
    Column() {
      Text(title)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_color'))
      Text(desc)
        .fontSize(12)
        .fontColor($r('app.color.text_color'))
        .margin({ top: 4 })
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .margin({ top: 24, bottom: 8 })
  }

  @Builder
  customIndicatorBuilder() {
    ATabBarCanvasIndicator()
  }
}

/**
 * customIndicator 示例：用 Canvas 真正「绘制」一个 indicator。
 * 只在选中 tab 下被创建，无状态：onReady 时直接画一次即可，无需随选中态重绘。
 */
@ComponentV2
struct ATabBarCanvasIndicator {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  private draw(): void {
    const ctx: CanvasRenderingContext2D = this.context
    ctx.clearRect(0, 0, 24, 10)
    ctx.strokeStyle = '#8E44AD'
    ctx.lineWidth = 4
    ctx.lineCap = 'round'
    ctx.beginPath()
    ctx.moveTo(4, 5)
    ctx.lineTo(20, 5)
    ctx.stroke()
    ctx.fillStyle = '#FFFFFF'
    ctx.beginPath()
    ctx.arc(12, 5, 1.5, 0, 2 * Math.PI)
    ctx.fill()
  }

  build() {
    Canvas(this.context)
      .width(24)
      .height(10)
      .offset({ x: 0, y: 14 })
      .onReady(() => {
        this.draw()
      })
  }
}
