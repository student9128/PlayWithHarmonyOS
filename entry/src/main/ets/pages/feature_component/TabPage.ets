import { showToast } from '../../utils/ToastUtils';
import { CustomTitleBar } from '../../widgets/CustomTitleBar'

@Entry
@Component
struct TabPage {
  private controller: TabsController = new TabsController();
  @State currentSelectedIndex: number = 0;

  build() {
    RelativeContainer() {
      CustomTitleBar({ title: 'TabPage' }) {
        Tabs({ controller: this.controller }) {
          this.parentTabBuilder()
        }.animationDuration(300).onTabBarClick(index => {
          showToast(`${index}`)
          this.currentSelectedIndex = index

        })

      }
    }
  }



  subList: string[] = ['subTab1', 'subTab2', 'subTab3-----test']
  tabList:string[]=['Tab1','Tab2','Tab3']

  @Builder
  parentTabBuilder(){
    ForEach(this.tabList,(item:string,index:number)=>{
      TabContent() {
        Column() {
          Tabs() {
            this.newLocalBuilder(index)
          }.animationDuration(index)
        }
      }.tabBar(customTab({title:`${item}`,isSelected:this.currentSelectedIndex==index}))
    })
  }

  @Builder
  newLocalBuilder(tabIndex: number) {
    ForEach(this.subList, (item: string, index: number) => {
      if (index == 0 && tabIndex > 0) {
        TabContent() {
          Column() {
            Text(`${tabIndex}=${item}`)
          }
        }
        .tabBar(item).gesture(PanGesture(new PanGestureOptions({ direction: PanDirection.Right })).onActionStart(e => {
          this.controller.changeIndex(tabIndex-1)
          this.currentSelectedIndex=tabIndex-1
        }))
      } else
        if (index == this.subList.length - 1 && tabIndex!=this.tabList.length-1) {
          TabContent() {
            Column() {
              Text(`${tabIndex}=${item}`)
            }
          }
          .tabBar(item).gesture(PanGesture(new PanGestureOptions({ direction: PanDirection.Left })).onActionStart(e => {
            this.controller.changeIndex(tabIndex+1)
            this.currentSelectedIndex=(tabIndex+1)
          }))
        } else {
        TabContent() {
          Column() {
            Text(`${tabIndex}=${item}`)
          }
        }
        .tabBar(item)
      }
    }, (item: string) => item)

  }
}
class TabParams{
  title:string=''
  isSelected:boolean=false
}
/**
 * 必须使用引用传值，否无法刷新 UI
 * 使用 ComponentV2配合 ObservedV2和 Trace ，不支持基本数据类型
 * https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-builder-V5#builder函数联合v2装饰器使用
 * @Builder只接受一个参数，当传入一个参数的时候，通过对象字面量的形式传递，值的改变会引起UI的刷新。
 * @param title
 * @param isSelected
 */
@Builder
function customTab(param:TabParams) {
  Text(param.title)
    .fontColor(param.isSelected?Color.Orange:Color.Black)
    .borderColor(param.isSelected ? Color.Orange : Color.Gray)
    .borderRadius(10)
    .borderWidth(1)
    .padding({
      left: 10,
      right: 10,
      top: 3,
      bottom: 3
    })
    .backgroundColor(param.isSelected ? Color.Transparent : Color.Gray)
}