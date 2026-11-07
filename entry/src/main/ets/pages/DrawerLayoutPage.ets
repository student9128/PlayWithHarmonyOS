import { AppTitleBar } from '../widgets/AppTitleBar'
import { DrawerLayout } from '@smarthane/drawer-layout';

/**
 * 第三方 DrawerLayout 是状态管理 V1 组件，model 参数为 @Link，
 * 只能通过 V1 的 $model 引用语法传入，V2 组件中不存在该语法。
 * 因此用一层极薄的 V1 适配组件隔离第三方库；页面本体 DrawerLayoutPage 仍是 V2，
 * 且调用适配层时不传递任何变量，符合 V2 使用 V1 组件的混用规则。
 */
@Component
struct DrawerLayoutHost {
  @State drawerModel: DrawerLayout.Model = new DrawerLayout.Model()
    .setDrawerType(DrawerLayout.Type.LEFT)
    .setDrawerWidth(300)
    .setMaskColor(Color.Transparent)

  aboutToAppear(): void {
    this.drawerModel.setDrawerStateCallback((drawerType, isOpen) => {
      console.debug(`drawerType: ${drawerType}, isOpen: ${isOpen}`)
    })
  }

  build() {
    Column() {
      DrawerLayout({
        model: $drawerModel,
        drawerView: () => {
          this.buildDrawerView()
        },
        contentView: () => {
          this.buildContentView()
        }
      }).height('100%')
    }
  }

  @Builder
  buildContentView() {
    Column() {
      Text('这是内容')
      Button('打开drawer').onClick(() => {
        this.drawerModel.openOrCloseDrawer()
      })
    }
  }

  @Builder
  buildDrawerView() {
    Column() {
      Text('左边抽屉')
    }
    .backgroundColor(Color.Green)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}

@ComponentV2
export struct DrawerLayoutPage {
  build() {
    Column() {
      DrawerLayoutHost()
    }
    .width('100%')
    .height('100%')
  }
}

@Builder
export function DrawerLayoutPageBuilder() {
  NavDestination() {
    Column() {
      AppTitleBar({ title: 'DrawerLayoutPage' })
      Column() {
        DrawerLayoutPage()
      }.width('100%').layoutWeight(1)
    }.width('100%').height('100%')
  }.hideTitleBar(true)
}
