import { CustomTitleBar } from '../../widgets/CustomTitleBar'
import { curves } from '@kit.ArkUI';

@Entry
@Component
struct ListItemReorderPage {
  @State arr: string[] = ['Java', 'Kotlin', 'JavaScript', 'TypeScript', 'Dart', 'Swift', 'ArkTS']
  @State dragItemX: string = '';
  @State dragIndex: number = -1;

  @Builder
  itemWhileDrag() {
    Row() {
      Text(this.dragItemX)
    }
    .padding({ left: 16, right: 16 })
    .width('100%')
    .height(40)
    .backgroundColor($r('app.color.color_background_list_item'))
    .borderRadius(16)
    .justifyContent(FlexAlign.Start)
  }

  build() {
    Column() {
      CustomTitleBar({ title: 'ListItemReorderPage' }) {
        Column() {
          this.firstList()
          Divider().margin({ top: 10 })
          this.secondList()
        }
      }
    }
  }

  @Builder
  deleteButton() {
    Text('删除')
      .fontColor($r('app.color.text_color'))
      .backgroundColor(Color.Red)
      .height('100%')
      .width(80)
      .textAlign(TextAlign.Center)
      .onClick(() => {

      })
  }

  @State dragItem: number = -1
  private dragRefOffset: number = 0
  @State offsetX: number = 0
  @State offsetY: number = 0

  @State lastOffsetY:number=0
  @Builder
  secondList() {
    List() {
      ForEach(this.arr, (item: string, index: number) => {
        ListItem() {
          Row() {
            Text(item);
            Text(`${index}`);
          }
          // .margin({ top: 10, })
          .padding({ left: 16, right: 16 })
          .width('100%')
          .height(40)
          .backgroundColor(this.dragItem==index?Color.Red:$r('app.color.color_background_list_item'))
          .borderRadius(16)
          .justifyContent(FlexAlign.SpaceBetween)
          .draggable(false)
          .animation({ curve: Curve.Sharp, duration: 300 });
        }.swipeAction({ end: this.deleteButton() })
        .zIndex(this.dragItem == index ? 3: 2)
        .opacity(this.dragItem==index?0.8:1)
        .translate(this.dragItem == index ? { y: this.offsetY } : { y: 0 })
        .transition(TransitionEffect.OPACITY)
        .gesture(GestureGroup(GestureMode.Sequence, LongPressGesture({repeat:true}).onAction((e) => {
          let index = this.arr.indexOf(item)
          this.dragItem=index
        }), PanGesture().onActionStart(e => {
          let index = this.arr.indexOf(item)
          this.dragItem = index
          this.dragRefOffset = 0
        }).onActionUpdate(event => {
          console.debug(`gesture=========PanGesture=onActionUpdate====index=${event.offsetY}`)
          this.offsetY = event.offsetY - this.dragRefOffset
          let isUp:boolean=(this.lastOffsetY-this.offsetY)<0
          this.lastOffsetY = this.offsetY;
          console.error(`哈哈====isUp=${isUp}=event.offsetY=${event.offsetY},走了,this.offsetY=${this.offsetY},dragRefOffset=${this.dragRefOffset}`)
            if(Math.abs(this.offsetY)>=20){
              let n = Math.ceil(Math.abs(this.offsetY)/40)
             let targetIndex = isUp?this.dragItem+n:this.dragItem-n
              if(targetIndex<0){
                targetIndex=0
              }
              if(targetIndex>=this.arr.length){
                targetIndex=this.arr.length-1
              }
              console.warn(`哈哈=====targetIndex=${targetIndex},dargItem=${this.dragItem}`)
              // animateTo({curve:Curve.Friction,duration:300},()=>{
              if (targetIndex >= 0 && targetIndex < this.arr.length) {
                this.swapItems(this.dragItem, targetIndex)
                this.dragItem = targetIndex
                console.error(`哈哈====event.offsetY=${event.offsetY},this.offsetY=${this.offsetY}}`)
                this.offsetY -= isUp ? n*40 : -40*n
                this.dragRefOffset += isUp ? 40*n : -40*n
                console.log(`哈哈===dragItem=${this.dragItem},targetIndex=${targetIndex},offsetY=${this.offsetY}}`)
              }else{
                console.warn(`哈哈=====不交换==${targetIndex}`)
              }
              // })
            }else{
              console.warn(`哈哈=====不交换==offsetY=${this.offsetY},event.offsetY=${event.offsetY},dragRefOffset=${this.dragRefOffset}`)
            }

        }).onActionEnd(e => {
          this.dragRefOffset=0
          this.offsetY=0
          this.dragItem = -1
          console.debug(`gesture=========PanGesture=onActionEnd====index=${index}=${JSON.stringify(e)}`)

        }).onActionCancel(() => {
          console.debug(`gesture=========PanGesture=onActionCancel`)
        }),).onCancel(()=>{
          console.debug(`gesture=========GestureGroup=onCancel`)
          animateTo({ curve: curves.interpolatingSpring(0, 1, 400, 38) }, () => {
            this.dragItem = -1
          })
          animateTo({
            curve: curves.interpolatingSpring(14, 1, 170, 17), delay: 150
          }, () => {
            // this.scaleItem = -1
          })
        }))
      },(item:string)=>item)
    }.divider({strokeWidth:1})
  }
  swapItems(oldIndex:number,newIndex:number){
    let temp = this.arr[oldIndex]
    this.arr[oldIndex]=this.arr[newIndex]
    this.arr[newIndex]=temp
  }

  @Builder
  firstList() {
    List() {
      ForEach(this.arr, (item: string, index) => {
        ListItem() {
          Row() {
            Text(item);
          }
          .margin({ top: 10, })
          .padding({ left: 16, right: 16 })
          .width('100%')
          .height(40)
          .backgroundColor($r('app.color.color_background_list_item'))
          .borderRadius(16)
          .justifyContent(FlexAlign.Start)
          .draggable(false)
          .animation({ curve: Curve.Sharp, duration: 300 });
        }
        .padding({ left: 16, right: 16 });
      }, (item: string) => item);

    }

    .onItemDragStart((event, index: number) => {
      this.dragItemX = this.arr[index];
      return this.itemWhileDrag();
    })
    .onItemDrop((event, itemIndex: number, insertIndex: number, isSuccess: boolean) => {
      if (!isSuccess || insertIndex >= this.arr.length) {
        return;
      }
      let temp = this.arr[itemIndex];
      this.arr[itemIndex] = this.arr[insertIndex];
      this.arr[insertIndex] = temp;
    })
  }
}